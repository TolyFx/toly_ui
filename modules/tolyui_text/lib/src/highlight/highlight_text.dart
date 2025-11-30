import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'rule.dart';
part 'model.dart';

class HighlightText extends StatelessWidget {
  final String src;
  final Map<Rule, TextStyle> rules;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;

  final TextScaler? textScaler;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final ui.TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

  const HighlightText(
    this.src, {
    super.key,
    this.rules = const {},
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  HighlightText.withArg(
    this.src, {
    super.key,
    String? arg,
    TextStyle? highlightStyle,
    bool caseSensitive = true,
    OnMatchTap? onTap,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  }) : rules = arg != null && highlightStyle != null
            ? {
                Rule(
                  RegExp(RegExp.escape(arg), caseSensitive: caseSensitive),
                  onTap: onTap,
                ): highlightStyle
              }
            : {};

  @override
  Widget build(BuildContext context) {
    if (rules.isEmpty) {
      return Text(
        src,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaler: textScaler,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
      );
    }

    List<_Highlight> parts = [];

    for (final MapEntry<Rule, TextStyle> entry in rules.entries) {
      final Iterable<Match> matches = entry.key.allMatches(src);
      int i =0;
      for (final Match match in matches) {
        final HighlightMatch highlightMatch = HighlightMatch(
            entry.key.pattern.toString(),
            match.group(0)!,
            match.start,
            match.end,i);
        parts.add(_Highlight(
            match.start,
            match.group(0)!,
            entry.value,
            entry.key.onTap != null
                ? () => entry.key.onTap!(highlightMatch)
                : null));
        i++;
      }
    }

    return Text.rich(
      _formSpan(parts),
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }

  InlineSpan _formSpan(List<_Highlight> parts) {
    // 排序并解决重叠冲突
    parts.sort((a, b) {
      int startCompare = a.start.compareTo(b.start);
      if (startCompare != 0) return startCompare;
      // 如果起始位置相同，优先选择更长的匹配
      return b.text.length.compareTo(a.text.length);
    });

    // 过滤重叠的匹配
    List<_Highlight> filteredParts = [];
    for (final highlight in parts) {
      bool hasOverlap = false;
      for (final existing in filteredParts) {
        int existingEnd = existing.start + existing.text.length;
        int highlightEnd = highlight.start + highlight.text.length;
        
        // 检查是否有重叠
        if (!(highlight.start >= existingEnd || highlightEnd <= existing.start)) {
          hasOverlap = true;
          break;
        }
      }
      if (!hasOverlap) {
        filteredParts.add(highlight);
      }
    }

    // 按起始位置重新排序
    filteredParts.sort((a, b) => a.start.compareTo(b.start));

    List<TextSpan> spans = [];
    int start = 0;

    for (final highlight in filteredParts) {
      if (highlight.start > start) {
        spans.add(TextSpan(
          text: src.substring(start, highlight.start),
          style: style,
        ));
      }
      spans.add(TextSpan(
        text: highlight.text,
        style: highlight.style,
        recognizer: highlight.onTap != null
            ? (TapGestureRecognizer()..onTap = highlight.onTap)
            : null,
      ));
      start = highlight.start + highlight.text.length;
    }

    if (start < src.length) {
      spans.add(TextSpan(text: src.substring(start), style: style));
    }

    return TextSpan(children: spans);
  }
}
