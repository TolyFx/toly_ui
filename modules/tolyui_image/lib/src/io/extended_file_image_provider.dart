import 'dart:ui' as ui show Codec, ImmutableBuffer;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' hide FileImage;
import 'extended_image_provider.dart';
import 'platform.dart';

class ExtendedFileImageProvider extends FileImage
    with ExtendedImageProvider<FileImage> {
  const ExtendedFileImageProvider(
    File file, {
    double scale = 1.0,
    this.cacheRawData = false,
    this.imageCacheName,
  })  : assert(!kIsWeb, 'not support on web'),
        super(file, scale: scale);

  /// Whether cache raw data if you need to get raw data directly.
  /// For example, we need raw image data to edit,
  /// but [ui.Image.toByteData()] is very slow. So we cache the image
  /// data here.
  @override
  final bool cacheRawData;

  /// The name of [ImageCache], you can define custom [ImageCache] to store this provider.
  @override
  final String? imageCacheName;

  @override
  ImageStreamCompleter loadImage(FileImage key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode),
      scale: key.scale,
      debugLabel: key.file.path,
      informationCollector: () => <DiagnosticsNode>[
        ErrorDescription('Path: ${file.path}'),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(
      FileImage key, ImageDecoderCallback decode) async {
    assert(key == this);

    // TODO(jonahwilliams): making this sync caused test failures that seem to
    // indicate that we can fail to call evict unless at least one await has
    // occurred in the test.
    // https://github.com/flutter/flutter/issues/113044
    final int lengthInBytes = await file.length();
    if (lengthInBytes == 0) {
      // The file may become available later.
      PaintingBinding.instance.imageCache.evict(key);
      throw StateError('$file is empty and cannot be loaded as an image.');
    }
    // TODO(zmtzawqlp): https://github.com/flutter/flutter/pull/112892
    // if we use ImmutableBuffer.fromFilePath, we can't cache bytes to edit
    //
    if (cacheRawData) {
      final Uint8List bytes = await file.readAsBytes();
      return await instantiateImageCodec(bytes, decode);
    } else {
      return (file.runtimeType == File)
          ? decode(await ui.ImmutableBuffer.fromFilePath(file.path))
          : decode(
              await ui.ImmutableBuffer.fromUint8List(await file.readAsBytes()));
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is ExtendedFileImageProvider &&
        file.path == other.file.path &&
        scale == other.scale &&
        cacheRawData == other.cacheRawData &&
        imageCacheName == other.imageCacheName;
  }

  @override
  int get hashCode => Object.hash(
        file.path,
        scale,
        cacheRawData,
        imageCacheName,
      );

  @override
  String toString() =>
      '${objectRuntimeType(this, 'FileImage')}("${file.path}", scale: $scale)';
}
