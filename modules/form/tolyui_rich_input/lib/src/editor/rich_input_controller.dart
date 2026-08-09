/// RichInputController — 富文本输入主控制器
///
/// 封装 [QuillController]，提供面向消息输入的 API：
/// 格式切换、嵌入插入、回车处理、内容访问
library;

import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';

import '../types.dart';

/// 提交回调
typedef SubmitCallback = void Function(Delta delta);

/// 图片粘贴回调，接收图片字节，返回文件路径/URL 或 null
typedef ImagePasteCallback = Future<String?> Function(Uint8List imageBytes);

/// 富文本输入主控制器
class RichInputController extends ChangeNotifier {
  RichInputController({
    Document? document,
    TextSelection? selection,
    ImagePasteCallback? onImagePaste,
  }) : quillController = QuillController(
          document: document ?? Document(),
          selection: selection ?? const TextSelection.collapsed(offset: 0),
          config: QuillControllerConfig(
            clipboardConfig: onImagePaste != null
                ? QuillClipboardConfig(onImagePaste: onImagePaste)
                : null,
          ),
        ) {
    quillController.addListener(_onQuillChanged);
  }

  /// 底层 flutter_quill 控制器
  final QuillController quillController;

  /// 当前文档内容的 Delta
  Delta get delta => quillController.document.toDelta();

  /// 纯文本内容
  String get plainText => quillController.document.toPlainText();

  /// 文档是否为空
  bool get isEmpty => quillController.document.isEmpty();

  /// 清空输入框
  void clear() {
    quillController.clear();
    notifyListeners();
  }

  /// 切换指定格式
  void toggleFormat(FormatType format) {
    final attr = _formatToAttribute(format);
    if (attr == null) return;

    if (format.isInline) {
      _toggleInlineFormat(attr);
    } else {
      _toggleBlockFormat(format, attr);
    }
  }

  /// 在光标位置插入嵌入对象
  void insertEmbed(Embeddable embed) {
    final index = quillController.selection.baseOffset;
    final length = quillController.selection.extentOffset - index;
    quillController.replaceText(
      index,
      length,
      embed,
      TextSelection.collapsed(offset: index + 1),
    );
  }

  /// 处理回车键
  ///
  /// [isShiftPressed] 为 true 时插入换行，否则返回 skipRemainingHandlers 信号提交
  KeyEventResult handleEnterKey({required bool isShiftPressed}) {
    if (isShiftPressed) {
      final index = quillController.selection.baseOffset;
      final length = quillController.selection.extentOffset - index;
      quillController.replaceText(
        index,
        length,
        '\n',
        TextSelection.collapsed(offset: index + 1),
      );
      return KeyEventResult.handled;
    }
    return KeyEventResult.skipRemainingHandlers;
  }

  /// 从 Delta 恢复内容
  void restoreFromDelta(Delta delta) {
    quillController.document = Document.fromDelta(delta);
    quillController.updateSelection(
      const TextSelection.collapsed(offset: 0),
      ChangeSource.local,
    );
    notifyListeners();
  }

  /// 获取当前选区样式
  Style getSelectionStyle() => quillController.getSelectionStyle();

  /// 指定格式是否在当前选区激活
  bool isFormatActive(FormatType format) {
    final style = getSelectionStyle();
    final key = format.deltaKey;

    if (format == FormatType.orderedList) {
      return style.attributes[key]?.value == 'ordered';
    }
    if (format == FormatType.bulletList) {
      return style.attributes[key]?.value == 'bullet';
    }
    return style.attributes.containsKey(key);
  }

  @override
  void dispose() {
    quillController.removeListener(_onQuillChanged);
    quillController.dispose();
    super.dispose();
  }

  void _onQuillChanged() {
    notifyListeners();
  }

  Attribute? _formatToAttribute(FormatType format) {
    switch (format) {
      case FormatType.bold:
        return Attribute.bold;
      case FormatType.italic:
        return Attribute.italic;
      case FormatType.underline:
        return Attribute.underline;
      case FormatType.strikethrough:
        return Attribute.strikeThrough;
      case FormatType.codeBlock:
        return Attribute.codeBlock;
      case FormatType.blockquote:
        return Attribute.blockQuote;
      case FormatType.orderedList:
        return Attribute.ol;
      case FormatType.bulletList:
        return Attribute.ul;
      case FormatType.link:
        return null;
    }
  }

  void _toggleInlineFormat(Attribute attr) {
    final style = getSelectionStyle();
    final isActive = style.containsKey(attr.key);

    if (isActive) {
      quillController.formatSelection(Attribute.clone(attr, null));
    } else {
      quillController.formatSelection(attr);
    }
  }

  void _toggleBlockFormat(FormatType format, Attribute attr) {
    final style = getSelectionStyle();
    final currentAttr = style.attributes[attr.key];

    if (format == FormatType.orderedList || format == FormatType.bulletList) {
      String targetValue;
      if (format == FormatType.orderedList) {
        targetValue = 'ordered';
      } else {
        targetValue = 'bullet';
      }
      if (currentAttr?.value == targetValue) {
        quillController.formatSelection(Attribute.clone(Attribute.list, null));
      } else {
        quillController.formatSelection(attr);
      }
    } else {
      if (currentAttr != null) {
        quillController.formatSelection(Attribute.clone(attr, null));
      } else {
        quillController.formatSelection(attr);
      }
    }
  }
}
