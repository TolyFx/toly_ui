// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: implementation_imports

import 'dart:async';
import 'dart:js_interop';
import 'dart:ui' as ui;
import 'dart:ui_web' as ui_web;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:http_client_helper/http_client_helper.dart';
import 'package:web/web.dart' as web;
// ignore: directives_ordering
import 'package:flutter/src/painting/image_provider.dart' as image_provider;

import '../../../../tolyui_image.dart';

/// Creates a type for an overridable factory function for testing purposes.
typedef HttpRequestFactory = web.XMLHttpRequest Function();

// Method signature for _loadAsync decode callbacks.
typedef _SimpleDecoderCallback = Future<ui.Codec> Function(
    ui.ImmutableBuffer buffer);

/// Default HTTP client.
web.XMLHttpRequest _httpClient() {
  return web.XMLHttpRequest();
}

/// Creates an overridable factory function.
HttpRequestFactory httpRequestFactory = _httpClient;

/// Restores to the default HTTP request factory.
void debugRestoreHttpRequestFactory() {
  httpRequestFactory = _httpClient;
}

/// The web implementation of [image_provider.NetworkImage].
///
/// NetworkImage on the web does not support decoding to a specified size.
class FxNetworkImageProviderImpl
    extends ImageProvider<FxNetworkImageProvider>
    with
        FxImageProvider<
            FxNetworkImageProvider>
    implements
        FxNetworkImageProvider {
  /// Creates an object that fetches the image at the given URL.
  ///
  /// The arguments [url] and [scale] must not be null.
  FxNetworkImageProviderImpl(
    this.url, {
    this.scale = 1.0,
    this.headers,
    this.cache = false,
    this.retries = 3,
    this.timeLimit,
    this.timeRetry = const Duration(milliseconds: 100),
    this.cancelToken,
    this.cacheKey,
    this.printError = true,
    this.cacheRawData = false,
    this.imageCacheName,
    this.cacheMaxAge,
  });

  @override
  final String url;

  @override
  final double scale;

  @override
  final Map<String, String>? headers;

  @override
  final bool cache;

  @override
  final CancellationToken? cancelToken;

  @override
  final int retries;

  @override
  final Duration? timeLimit;

  @override
  final Duration timeRetry;

  @override
  final String? cacheKey;

  /// print error
  @override
  final bool printError;

  @override
  final bool cacheRawData;

  /// The name of [ImageCache], you can define custom [ImageCache] to store this provider.
  @override
  final String? imageCacheName;

  /// The duration before local cache is expired.
  /// After this time the cache is expired and the image is reloaded.
  @override
  final Duration? cacheMaxAge;

  @override
  Future<FxNetworkImageProviderImpl> obtainKey(
      ImageConfiguration configuration) {
    return SynchronousFuture<FxNetworkImageProviderImpl>(this);
  }

  @override
  ImageStreamCompleter loadImage(
      FxNetworkImageProvider key,
      image_provider.ImageDecoderCallback decode) {
    // Ownership of this controller is handed off to [_loadAsync]; it is that
    // method's responsibility to close the controller's stream when the image
    // has been loaded or an error is thrown.
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      chunkEvents: chunkEvents.stream,
      codec: _loadAsync(key, decode, chunkEvents),
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: _imageStreamInformationCollector(key),
    );
  }

  InformationCollector? _imageStreamInformationCollector(
      FxNetworkImageProvider key) {
    InformationCollector? collector;
    assert(() {
      collector = () => <DiagnosticsNode>[
            DiagnosticsProperty<image_provider.ImageProvider>(
                'Image provider', this),
            DiagnosticsProperty<
                    FxNetworkImageProvider>(
                'Image key', key),
          ];
      return true;
    }());
    return collector;
  }

  // Html renderer does not support decoding network images to a specified size. The decode parameter
  // here is ignored and `ui_web.createImageCodecFromUrl` will be used directly
  // in place of the typical `instantiateImageCodec` method.
  Future<ui.Codec> _loadAsync(
    FxNetworkImageProvider key,
    _SimpleDecoderCallback decode,
    StreamController<ImageChunkEvent> chunkEvents,
  ) async {
    assert(key == this);

    final Uri resolved = Uri.base.resolve(key.url);

    final bool containsNetworkImageHeaders = key.headers?.isNotEmpty ?? false;

    // We use a different method when headers are set because the
    // `ui_web.createImageCodecFromUrl` method is not capable of handling headers.
    if (isCanvasKit || containsNetworkImageHeaders) {
      final Completer<web.XMLHttpRequest> completer =
          Completer<web.XMLHttpRequest>();
      final web.XMLHttpRequest request = httpRequestFactory();

      request.open('GET', key.url, true);
      request.responseType = 'arraybuffer';
      if (containsNetworkImageHeaders) {
        key.headers!.forEach((String header, String value) {
          request.setRequestHeader(header, value);
        });
      }

      request.addEventListener(
          'load',
          (web.Event e) {
            final int status = request.status;
            final bool accepted = status >= 200 && status < 300;
            final bool fileUri = status == 0; // file:// URIs have status of 0.
            final bool notModified = status == 304;
            final bool unknownRedirect = status > 307 && status < 400;
            final bool success =
                accepted || fileUri || notModified || unknownRedirect;

            if (success) {
              completer.complete(request);
            } else {
              completer.completeError(e);
              throw image_provider.NetworkImageLoadException(
                  statusCode: status, uri: resolved);
            }
          }.toJS);

      request.addEventListener(
          'error', ((JSObject e) => completer.completeError(e)).toJS);

      request.send();

      await completer.future;

      final Uint8List bytes =
          (request.response! as JSArrayBuffer).toDart.asUint8List();

      if (bytes.lengthInBytes == 0) {
        throw image_provider.NetworkImageLoadException(
            statusCode: request.status, uri: resolved);
      }
      return decode(await ui.ImmutableBuffer.fromUint8List(bytes));
    } else {
      return ui_web.createImageCodecFromUrl(
        resolved,
        chunkCallback: (int bytes, int total) {
          chunkEvents.add(ImageChunkEvent(
              cumulativeBytesLoaded: bytes, expectedTotalBytes: total));
        },
      );
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is FxNetworkImageProviderImpl &&
        url == other.url &&
        scale == other.scale &&
        //cacheRawData == other.cacheRawData &&
        imageCacheName == other.imageCacheName;
  }

  @override
  int get hashCode => Object.hash(
        url,
        scale,
        //cacheRawData,
        imageCacheName,
      );

  @override
  String toString() => '$runtimeType("$url", scale: $scale)';

  // not support on web
  @override
  Future<Uint8List?> getNetworkImageData({
    StreamController<ImageChunkEvent>? chunkEvents,
  }) {
    return Future<Uint8List>.error('not support on web');
  }

  static dynamic get httpClient => null;
}
