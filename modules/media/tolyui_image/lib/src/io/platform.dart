import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'toly_image_io.dart';
import 'package:flutter/widgets.dart';
export 'adapter/platform/platform_io.dart';

const String cacheImageFolderName = 'toly_image_cache';

///clear all of image in memory
void clearMemoryImageCache([String? name]) {
  if (name != null) {
    if (imageCaches.containsKey(name)) {
      imageCaches[name]!.clear();
      imageCaches[name]!.clearLiveImages();
      imageCaches.remove(name);
    }
  } else {
    PaintingBinding.instance.imageCache.clear();

    PaintingBinding.instance.imageCache.clearLiveImages();
  }
}

/// get ImageCache
ImageCache? getMemoryImageCache([String? name]) {
  if (name != null) {
    if (imageCaches.containsKey(name)) {
      return imageCaches[name];
    } else {
      return null;
    }
  } else {
    return PaintingBinding.instance.imageCache;
  }
}

/// get network image data from cached
Future<Uint8List?> getNetworkImageData(
  String url, {
  bool useCache = true,
  StreamController<ImageChunkEvent>? chunkEvents,
}) async {
  return FxNetworkImageProvider(url, cache: useCache).getNetworkImageData(
    chunkEvents: chunkEvents,
  );
}

/// get md5 from key
String keyToMd5(String key) => md5.convert(utf8.encode(key)).toString();
