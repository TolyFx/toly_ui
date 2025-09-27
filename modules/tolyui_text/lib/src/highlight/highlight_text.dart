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

      for (final Match match in matches) {
        final HighlightMatch highlightMatch = HighlightMatch(
            entry.key.pattern.toString(),
            match.group(0)!,
            match.start,
            match.end);
        parts.add(_Highlight(
            match.start,
            match.group(0)!,
            entry.value,
            entry.key.onTap != null
                ? () => entry.key.onTap!(highlightMatch)
                : null));
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
    parts.sort((a, b) => a.start.compareTo(b.start));

    List<TextSpan> spans = [];
    int start = 0;

    for (final highlight in parts) {
      if (highlight.start >= start) {
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
    }

    if (start < src.length) {
      spans.add(TextSpan(text: src.substring(start), style: style));
    }

    return TextSpan(children: spans);
  }
}
