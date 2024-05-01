import 'dart:ui';

import 'package:flutter/material.dart';

class TolyMenuTheme extends ThemeExtension<TolyMenuTheme> {
  /// 未选中标签文字
  final TextStyle? unselectedLabelTextStyle;

  /// 选中标签文字
  final TextStyle? selectedLabelTextStyle;

  final TextStyle? hoverLabelTextStyle;

  final Color? backgroundColor;
  final Color? expandBackgroundColor;
  final Color? selectedItemBackground;

  TolyMenuTheme({
    this.unselectedLabelTextStyle,
    this.backgroundColor,
    this.selectedItemBackground,
    this.expandBackgroundColor,
    this.selectedLabelTextStyle,
    this.hoverLabelTextStyle,
  });

  @override
  TolyMenuTheme copyWith({
    TextStyle? unselectedLabelTextStyle,
    TextStyle? selectedLabelTextStyle,
    TextStyle? hoverLabelTextStyle,
    Color? backgroundColor,
    Color? activeItemBackground,
    Color? expandBackgroundColor,
  }) {
    return TolyMenuTheme(
      unselectedLabelTextStyle: unselectedLabelTextStyle ?? this.unselectedLabelTextStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      selectedLabelTextStyle: selectedLabelTextStyle ?? this.selectedLabelTextStyle,
      hoverLabelTextStyle: hoverLabelTextStyle ?? this.hoverLabelTextStyle,
      expandBackgroundColor: expandBackgroundColor ?? this.expandBackgroundColor,
      selectedItemBackground: activeItemBackground ?? this.selectedItemBackground,
    );
  }

  @override
  TolyMenuTheme lerp(TolyMenuTheme? other, double t) {
    if (other is! TolyMenuTheme) {
      return this;
    }
    return TolyMenuTheme(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      unselectedLabelTextStyle: TextStyle.lerp(unselectedLabelTextStyle, other.unselectedLabelTextStyle, t),
      selectedLabelTextStyle: TextStyle.lerp(selectedLabelTextStyle, other.selectedLabelTextStyle, t),
      hoverLabelTextStyle: TextStyle.lerp(hoverLabelTextStyle, other.hoverLabelTextStyle, t),
      selectedItemBackground: Color.lerp(selectedItemBackground, other.selectedItemBackground, t),
    );
  }
}
