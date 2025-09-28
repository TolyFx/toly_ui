import 'dart:ui';
import 'package:flutter/material.dart';

class TolyPopPickerTheme extends ThemeExtension<TolyPopPickerTheme> {
  final double borderRadius;
  final Color backgroundColor;
  final Color separatorColor;
  final double separatorHeight;
  final double itemHeight;
  final TextStyle? itemTextStyle;
  final TextStyle? disabledItemTextStyle;
  final TextStyle? cancelTextStyle;
  final TextStyle? titleTextStyle;
  final TextStyle? messageStyle;
  final double cancelHeight;
  final EdgeInsets? itemPadding;
  final EdgeInsets? titlePadding;

  const TolyPopPickerTheme({
    this.borderRadius = 12.0,
    this.backgroundColor = Colors.white,
    this.separatorColor = const Color(0xffE5E3E4),
    this.separatorHeight = 10.0,
    this.itemHeight = 52.0,
    this.itemTextStyle = const TextStyle(fontSize: 16, color: Colors.black),
    this.disabledItemTextStyle = const TextStyle(fontSize: 16, color: Colors.grey),
    this.messageStyle = const TextStyle(fontSize: 14, color: Color(0xff999999)),
    this.cancelTextStyle = const TextStyle(
        fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
    this.titleTextStyle= const TextStyle(fontSize: 16, color: Colors.black,fontWeight: FontWeight.bold),
    this.cancelHeight = 50.0,
    this.itemPadding,
    this.titlePadding,
  });

  static TolyPopPickerTheme of(BuildContext context) {
    return Theme.of(context).extension<TolyPopPickerTheme>() ??
        const TolyPopPickerTheme();
  }

  @override
  TolyPopPickerTheme copyWith({
    double? borderRadius,
    Color? backgroundColor,
    Color? separatorColor,
    double? separatorHeight,
    double? itemHeight,
    TextStyle? itemTextStyle,
    TextStyle? disabledItemTextStyle,
    TextStyle? cancelTextStyle,
    TextStyle? titleTextStyle,
    TextStyle? messageStyle,
    double? cancelHeight,
    EdgeInsets? itemPadding,
    EdgeInsets? titlePadding,
  }) {
    return TolyPopPickerTheme(
      borderRadius: borderRadius ?? this.borderRadius,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      separatorColor: separatorColor ?? this.separatorColor,
      separatorHeight: separatorHeight ?? this.separatorHeight,
      itemHeight: itemHeight ?? this.itemHeight,
      messageStyle: messageStyle ?? this.messageStyle,
      itemTextStyle: itemTextStyle ?? this.itemTextStyle,
      disabledItemTextStyle: disabledItemTextStyle ??
          this.disabledItemTextStyle,
      cancelTextStyle: cancelTextStyle ?? this.cancelTextStyle,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      cancelHeight: cancelHeight ?? this.cancelHeight,
      itemPadding: itemPadding ?? this.itemPadding,
      titlePadding: titlePadding ?? this.titlePadding,
    );
  }

  @override
  TolyPopPickerTheme lerp(ThemeExtension<TolyPopPickerTheme>? other, double t) {
    if (other is! TolyPopPickerTheme) return this;
    return TolyPopPickerTheme(
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t) ??
          borderRadius,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t) ??
          backgroundColor,
      separatorColor: Color.lerp(separatorColor, other.separatorColor, t) ??
          separatorColor,
      separatorHeight: lerpDouble(separatorHeight, other.separatorHeight, t) ??
          separatorHeight,
      itemHeight: lerpDouble(itemHeight, other.itemHeight, t) ?? itemHeight,
      itemTextStyle: TextStyle.lerp(itemTextStyle, other.itemTextStyle, t),
      disabledItemTextStyle: TextStyle.lerp(
          disabledItemTextStyle, other.disabledItemTextStyle, t),
      cancelTextStyle: TextStyle.lerp(
          cancelTextStyle, other.cancelTextStyle, t),
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t),
      messageStyle: TextStyle.lerp(messageStyle, other.messageStyle, t),
      cancelHeight: lerpDouble(cancelHeight, other.cancelHeight, t) ??
          cancelHeight,
      itemPadding: EdgeInsets.lerp(itemPadding, other.itemPadding, t),
      titlePadding: EdgeInsets.lerp(titlePadding, other.titlePadding, t),
    );
  }

}