/// 富文本输入核心类型定义
library;

/// 支持的富文本格式类型
enum FormatType {
  /// 加粗 (Ctrl/Cmd+B)
  bold,

  /// 斜体 (Ctrl/Cmd+I)
  italic,

  /// 下划线 (Ctrl/Cmd+U)
  underline,

  /// 删除线
  strikethrough,

  /// 代码块 (```)
  codeBlock,

  /// 引用 ("> ")
  blockquote,

  /// 有序列表
  orderedList,

  /// 无序列表
  bulletList,

  /// 超链接
  link,
}

/// FormatType 到 Quill Delta 属性的映射
extension FormatTypeExtension on FormatType {
  /// 对应的 Quill Delta attribute key
  String get deltaKey {
    switch (this) {
      case FormatType.bold:
        return 'bold';
      case FormatType.italic:
        return 'italic';
      case FormatType.underline:
        return 'underline';
      case FormatType.strikethrough:
        return 'strike';
      case FormatType.codeBlock:
        return 'code-block';
      case FormatType.blockquote:
        return 'blockquote';
      case FormatType.orderedList:
        return 'list';
      case FormatType.bulletList:
        return 'list';
      case FormatType.link:
        return 'link';
    }
  }

  /// 列表类型的 Delta attribute value
  dynamic get deltaValue {
    switch (this) {
      case FormatType.orderedList:
        return 'ordered';
      case FormatType.bulletList:
        return 'bullet';
      default:
        return true;
    }
  }

  /// 是否为行内格式
  bool get isInline {
    switch (this) {
      case FormatType.bold:
      case FormatType.italic:
      case FormatType.underline:
      case FormatType.strikethrough:
      case FormatType.link:
        return true;
      case FormatType.codeBlock:
      case FormatType.blockquote:
      case FormatType.orderedList:
      case FormatType.bulletList:
        return false;
    }
  }

  /// 是否为块级格式
  bool get isBlock => !isInline;
}
