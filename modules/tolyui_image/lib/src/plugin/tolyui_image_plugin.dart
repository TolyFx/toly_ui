import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../io/platform.dart';

part 'image_operation.dart';

abstract class TolyPlugin<T> {
  Future<void> mount({T? res});
}

class TolyImagePlugin
    with ImageOperation, ImageOperationImpl
    implements TolyPlugin<Directory?> {
  TolyImagePlugin._();

  static TolyImagePlugin? _instance;

  factory TolyImagePlugin() {
    _instance ??= TolyImagePlugin._();
    return _instance!;
  }

  late Directory _imageSaveDir;

  @override
  Directory get imageSaveDir => _imageSaveDir;

  @override
  Future<void> mount({Directory? res}) async {
    _imageSaveDir = res ??
        Directory(p.join(
          (await getTemporaryDirectory()).path,
          cacheImageFolderName,
        ));
    if (!_imageSaveDir.existsSync()) {
      _imageSaveDir.createSync(recursive: true);
    }
  }
}
