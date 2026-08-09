/// 自定义嵌入类型定义
///
/// 定义 MentionEmbed、EmojiEmbed、ImageEmbed、FileEmbed
library;

import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:flutter_quill/flutter_quill.dart';

/// @提及嵌入
class MentionEmbed extends CustomBlockEmbed {
  static const String mentionType = 'mention';

  MentionEmbed({required this.userId, required this.displayName})
      : super(mentionType,
            jsonEncode({'userId': userId, 'displayName': displayName}));

  final String userId;
  final String displayName;

  Map<String, dynamic> toJsonMap() {
    return {'userId': userId, 'displayName': displayName};
  }

  factory MentionEmbed.fromJson(Map<String, dynamic> json) {
    return MentionEmbed(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
    );
  }

  factory MentionEmbed.fromData(String data) {
    final json = jsonDecode(data) as Map<String, dynamic>;
    return MentionEmbed.fromJson(json);
  }
}

/// 表情嵌入
class EmojiEmbed extends CustomBlockEmbed {
  static const String emojiType = 'emoji';

  EmojiEmbed({required this.emojiCode, this.customImagePath})
      : super(
            emojiType,
            jsonEncode({
              'code': emojiCode,
              if (customImagePath != null) 'imagePath': customImagePath,
            }));

  final String emojiCode;
  final String? customImagePath;

  Map<String, dynamic> toJsonMap() {
    return {
      'code': emojiCode,
      if (customImagePath != null) 'imagePath': customImagePath,
    };
  }

  factory EmojiEmbed.fromJson(Map<String, dynamic> json) {
    return EmojiEmbed(
      emojiCode: json['code'] as String,
      customImagePath: json['imagePath'] as String?,
    );
  }

  factory EmojiEmbed.fromData(String data) {
    final json = jsonDecode(data) as Map<String, dynamic>;
    return EmojiEmbed.fromJson(json);
  }
}

/// 图片嵌入
class ImageEmbed extends CustomBlockEmbed {
  static const String imageType = 'customImage';

  ImageEmbed({required this.src, this.width, this.height, this.alt})
      : super(
            imageType,
            jsonEncode({
              'src': src,
              if (width != null) 'width': width,
              if (height != null) 'height': height,
              if (alt != null) 'alt': alt,
            }));

  final String src;
  final int? width;
  final int? height;
  final String? alt;

  Map<String, dynamic> toJsonMap() {
    return {
      'src': src,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (alt != null) 'alt': alt,
    };
  }

  factory ImageEmbed.fromJson(Map<String, dynamic> json) {
    return ImageEmbed(
      src: json['src'] as String,
      width: json['width'] as int?,
      height: json['height'] as int?,
      alt: json['alt'] as String?,
    );
  }

  factory ImageEmbed.fromData(String data) {
    final json = jsonDecode(data) as Map<String, dynamic>;
    return ImageEmbed.fromJson(json);
  }
}

/// 文件嵌入
class FileEmbed extends CustomBlockEmbed {
  static const String fileType = 'file';

  FileEmbed({
    required this.name,
    required this.size,
    required this.mimeType,
    required this.path,
  }) : super(
            fileType,
            jsonEncode({
              'name': name,
              'size': size,
              'type': mimeType,
              'path': path,
            }));

  final String name;
  final int size;
  final String mimeType;
  final String path;

  Map<String, dynamic> toJsonMap() {
    return {
      'name': name,
      'size': size,
      'type': mimeType,
      'path': path,
    };
  }

  factory FileEmbed.fromJson(Map<String, dynamic> json) {
    return FileEmbed(
      name: json['name'] as String,
      size: json['size'] as int,
      mimeType: json['type'] as String,
      path: json['path'] as String,
    );
  }

  factory FileEmbed.fromData(String data) {
    final json = jsonDecode(data) as Map<String, dynamic>;
    return FileEmbed.fromJson(json);
  }
}

/// 解析自定义嵌入类型
Embeddable? parseCustomEmbed(Embeddable embeddable) {
  final data = embeddable.data as String;
  switch (embeddable.type) {
    case MentionEmbed.mentionType:
      return MentionEmbed.fromData(data);
    case EmojiEmbed.emojiType:
      return EmojiEmbed.fromData(data);
    case ImageEmbed.imageType:
      return ImageEmbed.fromData(data);
    case FileEmbed.fileType:
      return FileEmbed.fromData(data);
    default:
      return null;
  }
}
