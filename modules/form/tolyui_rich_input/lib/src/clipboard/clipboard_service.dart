/// 剪贴板服务 — 处理富文本复制/粘贴
library;

import 'package:flutter/services.dart';
import 'package:flutter_quill/quill_delta.dart';

import '../serialization/serialization_service.dart';

/// 支持的图片 MIME 类型
const supportedImageTypes = {
  'image/png',
  'image/jpeg',
  'image/gif',
  'image/webp',
  'image/bmp',
};

/// 支持的文件 MIME 类型
const supportedFileTypes = {
  'application/pdf',
  'application/zip',
  'application/x-rar-compressed',
  'text/plain',
  'application/msword',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'application/vnd.ms-excel',
  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
};

/// 粘贴内容类型
enum PasteType { richText, plainText, image, file, unsupported }

/// 粘贴结果
class PasteResult {
  const PasteResult({
    required this.type,
    this.delta,
    this.imageData,
    this.file,
    this.errorMessage,
  });

  final PasteType type;
  final Delta? delta;
  final Uint8List? imageData;
  final PastedFile? file;
  final String? errorMessage;

  factory PasteResult.unsupported(String mimeType) => PasteResult(
        type: PasteType.unsupported,
        errorMessage: '不支持的文件类型: $mimeType',
      );
}

/// 粘贴的文件
class PastedFile {
  const PastedFile({
    required this.name,
    required this.size,
    required this.mimeType,
    required this.data,
  });

  final String name;
  final int size;
  final String mimeType;
  final Uint8List data;
}

/// 图片尺寸约束
class ImageConstraints {
  const ImageConstraints({
    this.maxWidth = 300,
    this.maxHeight = 300,
  });

  final int maxWidth;
  final int maxHeight;

  /// 等比缩放计算
  ({int width, int height}) scaleToFit(
      int originalWidth, int originalHeight) {
    if (originalWidth <= maxWidth && originalHeight <= maxHeight) {
      return (width: originalWidth, height: originalHeight);
    }
    final widthRatio = maxWidth / originalWidth;
    final heightRatio = maxHeight / originalHeight;
    double ratio;
    if (widthRatio < heightRatio) {
      ratio = widthRatio;
    } else {
      ratio = heightRatio;
    }
    return (
      width: (originalWidth * ratio).round(),
      height: (originalHeight * ratio).round(),
    );
  }
}

/// 剪贴板服务
class ClipboardService {
  ClipboardService({
    SerializationService? serializationService,
    this.imageConstraints = const ImageConstraints(),
  }) : _serialization = serializationService ?? SerializationService();

  final SerializationService _serialization;
  final ImageConstraints imageConstraints;

  Delta parseHtmlToDelta(String html) {
    return _serialization.fromHtml(html);
  }

  String deltaToHtml(Delta delta) {
    return _serialization.toHtml(delta);
  }

  String deltaToPlainText(Delta delta) {
    return _serialization.toPlainText(delta);
  }

  /// 处理粘贴事件
  Future<PasteResult> handlePaste({bool plainTextOnly = false}) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);

    if (plainTextOnly || data != null) {
      final text = data?.text ?? '';
      if (plainTextOnly) {
        final delta = Delta()..insert(text);
        return PasteResult(type: PasteType.plainText, delta: delta);
      }
      final htmlData = await Clipboard.getData('text/html');
      if (htmlData?.text != null && htmlData!.text!.isNotEmpty) {
        final delta = parseHtmlToDelta(htmlData.text!);
        return PasteResult(type: PasteType.richText, delta: delta);
      }
      final delta = Delta()..insert(text);
      return PasteResult(type: PasteType.plainText, delta: delta);
    }

    return const PasteResult(type: PasteType.plainText);
  }

  /// 处理图片粘贴
  PasteResult handleImagePaste({
    required Uint8List imageData,
    required String mimeType,
    required int width,
    required int height,
  }) {
    if (!supportedImageTypes.contains(mimeType)) {
      return PasteResult.unsupported(mimeType);
    }
    imageConstraints.scaleToFit(width, height);
    return PasteResult(type: PasteType.image, imageData: imageData);
  }

  /// 处理文件粘贴
  PasteResult handleFilePaste({
    required String name,
    required int size,
    required String mimeType,
    required Uint8List data,
  }) {
    if (!supportedFileTypes.contains(mimeType) &&
        !supportedImageTypes.contains(mimeType)) {
      return PasteResult.unsupported(mimeType);
    }
    return PasteResult(
      type: PasteType.file,
      file: PastedFile(
          name: name, size: size, mimeType: mimeType, data: data),
    );
  }

  /// 复制到剪贴板
  Future<void> copyToClipboard(Delta delta) async {
    final plainText = deltaToPlainText(delta);
    await Clipboard.setData(ClipboardData(text: plainText));
  }

  bool isSupportedType(String mimeType) {
    return supportedImageTypes.contains(mimeType) ||
        supportedFileTypes.contains(mimeType);
  }
}
