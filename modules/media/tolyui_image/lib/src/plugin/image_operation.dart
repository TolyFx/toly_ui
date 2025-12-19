part of 'tolyui_image_plugin.dart';

mixin ImageOperation {
  Future<int> total();

  Future<bool> clear({Duration? duration});

  Future<bool> delete(String url, {String? cacheKey}) async {
    File? file = await find(url, cacheKey: cacheKey);
    if (file != null) {
      await file.delete();
      return true;
    }
    return false;
  }

  Future<File?> find(String url, {String? cacheKey});

  File? findSync(String url, {String? cacheKey});

  Future<bool> exist(String url, {String? cacheKey}) async {
    File? file = await find(url, cacheKey: cacheKey);
    return file != null;
  }

  bool existSync(String url, {String? cacheKey}) {
    File? file = findSync(url, cacheKey: cacheKey);
    return file != null;
  }
}

mixin ImageOperationImpl on ImageOperation {
  Directory get imageSaveDir;

  @override
  Future<bool> clear({Duration? duration}) async {
    try {
      final Directory dir = imageSaveDir;
      if (dir.existsSync()) {
        if (duration == null) {
          dir.deleteSync(recursive: true);
        } else {
          final DateTime now = DateTime.now();
          await for (final FileSystemEntity file in dir.list()) {
            final FileStat fs = file.statSync();
            if (now.subtract(duration).isAfter(fs.changed)) {
              file.deleteSync(recursive: true);
            }
          }
        }
      }
    } catch (_) {
      return false;
    }
    return true;
  }

  @override
  Future<File?> find(String url, {String? cacheKey}) async {
    try {
      final String key = cacheKey ?? keyToMd5(url);
      Directory dir = FxImagePlugin().imageSaveDir;
      File file = File(p.join(dir.path, key));
      if (await file.exists()) {
        return file;
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  @override
  File? findSync(String url, {String? cacheKey}) {
    try {
      final String key = cacheKey ?? keyToMd5(url);
      Directory dir = FxImagePlugin().imageSaveDir;
      File file = File(p.join(dir.path, key));
      if (file.existsSync()) {
        return file;
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  @override
  Future<int> total() async {
    int size = 0;
    final Directory dir = imageSaveDir;
    if (dir.existsSync()) {
      await for (final FileSystemEntity file in dir.list()) {
        size += file.statSync().size;
      }
    }
    return size;
  }
}
