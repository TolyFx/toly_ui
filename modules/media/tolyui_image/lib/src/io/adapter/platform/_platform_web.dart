import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Web 平台文件模拟类
/// 无具体实现
// ignore_for_file: always_specify_types,avoid_unused_constructor_parameters,unused_field
class File {
  /// 创建一个 [File] 对象。
  ///
  /// 如果 [path] 是相对路径，在使用时将相对于当前工作目录
  /// （参见 [Directory.current]）进行解释。
  ///
  /// 如果 [path] 是绝对路径，则不受当前工作目录变化的影响。
  ///

  File(this.path) : assert(false, 'Web平台不支持');

  /// 将整个文件内容读取为字节列表。
  ///
  /// 返回一个 `Future<Uint8List>`，完成时包含文件内容的字节列表。
  Future<Uint8List> readAsBytes() async => Uint8List.fromList(<int>[]);

  /// 文件的长度。
  ///
  /// 返回一个 `Future<int>`，完成时包含以字节为单位的长度。
  Future<int> length() async {
    return 0;
  }

  /// 此随机访问文件的底层文件路径。
  final String path;
}

/// Web平台文件图像模拟类
/// 无具体实现
class FileImage extends ImageProvider<FileImage> {
  /// 创建一个将 [File] 解码为图像的对象。
  ///
  /// 参数不能为空。
  const FileImage(this.file, {this.scale = 1.0});

  /// 要解码为图像的文件。
  final File file;

  /// 要放置在图像的 [ImageInfo] 对象中的缩放比例。
  final double scale;

  @override
  Future<FileImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<FileImage>(this);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is FileImage &&
        other.file.path == file.path &&
        other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(file.path, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'FileImage')}("${file.path}", scale: $scale)';
}
