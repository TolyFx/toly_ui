/// 在同一个可编辑文本渲染层内提供 JSON 语法高亮。

library;

import 'package:flutter/material.dart';

import 'json_editor_style.dart';

/// 通过 `TextEditingController.buildTextSpan` 保证文字、光标和选区同源布局。
class JsonHighlightController extends TextEditingController {
  /// 当前编辑器样式，由宿主组件在构建时同步。
  JsonEditorStyle? editorStyle;

  JsonHighlightController({super.text});

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final JsonEditorStyle? effectiveStyle = editorStyle;
    if (effectiveStyle == null ||
        (withComposing &&
            value.composing.isValid &&
            !value.composing.isCollapsed)) {
      return super.buildTextSpan(
        context: context,
        style: style,
        withComposing: withComposing,
      );
    }
    return TextSpan(
      style: style,
      children: highlight(text, effectiveStyle),
    );
  }

  /// 将 JSON 标记拆分为保持原始字符长度不变的彩色文本片段。
  static List<TextSpan> highlight(String text, JsonEditorStyle style) {
    final List<TextSpan> spans = [];
    final RegExp regex = RegExp(
      r'("(?:[^"\\]|\\.)*")\s*:|("(?:[^"\\]|\\.)*")|(-?\d+\.?\d*(?:[eE][+-]?\d+)?)|(\btrue\b|\bfalse\b)|(\bnull\b)|([\[\]{}:,])',
    );
    int lastEnd = 0;
    for (final RegExpMatch match in regex.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastEnd, match.start),
            style: TextStyle(color: style.bracketColor),
          ),
        );
      }
      spans.add(_highlightedMatch(match, style));
      lastEnd = match.end;
    }
    if (lastEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastEnd),
          style: TextStyle(color: style.bracketColor),
        ),
      );
    }
    return spans;
  }

  /// 根据正则捕获组返回单个 JSON 标记的颜色。
  static TextSpan _highlightedMatch(
    RegExpMatch match,
    JsonEditorStyle style,
  ) {
    if (match.group(1) != null) {
      final String key = match.group(1)!;
      final String suffix = match.group(0)!.substring(key.length);
      return TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: key,
            style: TextStyle(color: style.keyColor),
          ),
          TextSpan(
            text: suffix,
            style: TextStyle(color: style.bracketColor),
          ),
        ],
      );
    }
    if (match.group(2) != null) {
      return TextSpan(
        text: match.group(2),
        style: TextStyle(color: style.stringColor),
      );
    }
    if (match.group(3) != null) {
      return TextSpan(
        text: match.group(3),
        style: TextStyle(color: style.numberColor),
      );
    }
    if (match.group(4) != null) {
      return TextSpan(
        text: match.group(4),
        style: TextStyle(color: style.boolColor),
      );
    }
    if (match.group(5) != null) {
      return TextSpan(
        text: match.group(5),
        style: TextStyle(color: style.nullColor),
      );
    }
    return TextSpan(
      text: match.group(6),
      style: TextStyle(color: style.bracketColor),
    );
  }
}
