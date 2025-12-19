import 'package:flutter/material.dart';

enum LineType {
  none, // 不展示
  active, // 激活时展示
  always, // 一直展示
}

class LinkTheme extends ThemeExtension<LinkTheme> {
  final TextStyle? style;
  final Color? hoverColor;
  final LineType? lineType;

  LinkTheme({this.style, this.hoverColor, this.lineType});

  @override
  LinkTheme copyWith({
    TextStyle? style,
    Color? hoverColor,
    LineType? lineType,
  }) {
    return LinkTheme(
      style: style ?? this.style,
      hoverColor: hoverColor ?? this.hoverColor,
      lineType: lineType ?? this.lineType,
    );
  }

  @override
  LinkTheme lerp(LinkTheme? other, double t) {
    if (other is! LinkTheme) {
      return this;
    }
    return LinkTheme(
        hoverColor: Color.lerp(hoverColor, other.hoverColor, t),
        style: TextStyle.lerp(style, other.style, t),
        lineType: lineType);
  }
}
