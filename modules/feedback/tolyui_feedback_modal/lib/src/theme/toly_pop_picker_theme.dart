import 'dart:ui';
import 'package:flutter/material.dart';

class TolyPopPickerTheme extends ThemeExtension<TolyPopPickerTheme> {
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? separatorColor;
  final double? separatorHeight;
  final double? itemHeight;
  final TextStyle? itemTextStyle;
  final TextStyle? disabledItemTextStyle;
  final TextStyle? cancelTextStyle;
  final TextStyle? titleTextStyle;
  final TextStyle? messageStyle;
  final double? cancelHeight;
  final EdgeInsets? itemPadding;
  final EdgeInsets? titlePadding;

  const TolyPopPickerTheme({
    this.borderRadius,
    this.backgroundColor,
    this.separatorColor,
    this.separatorHeight,
    this.itemHeight,
    this.itemTextStyle,
    this.disabledItemTextStyle,
    this.messageStyle,
    this.cancelTextStyle,
    this.titleTextStyle,
    this.cancelHeight,
    this.itemPadding,
    this.titlePadding,
  });

  /// 亮色主题
  factory TolyPopPickerTheme.light() {
    return const TolyPopPickerTheme(
      borderRadius: 12.0,
      backgroundColor: Colors.white,
      separatorColor: Color(0xffE5E3E4),
      separatorHeight: 10.0,
      itemHeight: 52.0,
      cancelHeight: 50.0,
      itemTextStyle: TextStyle(fontSize: 16, color: Colors.black),
      disabledItemTextStyle: TextStyle(fontSize: 16, color: Colors.grey),
      cancelTextStyle: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
      titleTextStyle: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
      messageStyle: TextStyle(fontSize: 14, color: Color(0xff999999)),
    );
  }

  /// 暗色主题
  factory TolyPopPickerTheme.dark() {
    return const TolyPopPickerTheme(
      borderRadius: 12.0,
      backgroundColor: Color(0xff2C2C2E),
      separatorColor: Color(0xff3A3A3C),
      separatorHeight: 10.0,
      itemHeight: 52.0,
      cancelHeight: 50.0,
      itemTextStyle: TextStyle(fontSize: 16, color: Colors.white),
      disabledItemTextStyle: TextStyle(fontSize: 16, color: Color(0xff8E8E93)),
      cancelTextStyle: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
      titleTextStyle: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
      messageStyle: TextStyle(fontSize: 14, color: Color(0xffAEAEB2)),
    );
  }

  static TolyPopPickerTheme of(BuildContext context) {
    final theme = Theme.of(context).extension<TolyPopPickerTheme>();
    if (theme != null) return theme;
    
    // 根据系统主题自动选择
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark 
        ? TolyPopPickerTheme.dark() 
        : TolyPopPickerTheme.light();
  }

  /// 合并主题，优先使用用户传入的非空字段
  TolyPopPickerTheme merge(TolyPopPickerTheme? other) {
    if (other == null) return this;
    return TolyPopPickerTheme(
      borderRadius: other.borderRadius ?? borderRadius,
      backgroundColor: other.backgroundColor ?? backgroundColor,
      separatorColor: other.separatorColor ?? separatorColor,
      separatorHeight: other.separatorHeight ?? separatorHeight,
      itemHeight: other.itemHeight ?? itemHeight,
      itemTextStyle: other.itemTextStyle ?? itemTextStyle,
      disabledItemTextStyle: other.disabledItemTextStyle ?? disabledItemTextStyle,
      cancelTextStyle: other.cancelTextStyle ?? cancelTextStyle,
      titleTextStyle: other.titleTextStyle ?? titleTextStyle,
      messageStyle: other.messageStyle ?? messageStyle,
      cancelHeight: other.cancelHeight ?? cancelHeight,
      itemPadding: other.itemPadding ?? itemPadding,
      titlePadding: other.titlePadding ?? titlePadding,
    );
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
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t),
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t),
      separatorColor: Color.lerp(separatorColor, other.separatorColor, t),
      separatorHeight: lerpDouble(separatorHeight, other.separatorHeight, t),
      itemHeight: lerpDouble(itemHeight, other.itemHeight, t),
      itemTextStyle: TextStyle.lerp(itemTextStyle, other.itemTextStyle, t),
      disabledItemTextStyle: TextStyle.lerp(
          disabledItemTextStyle, other.disabledItemTextStyle, t),
      cancelTextStyle: TextStyle.lerp(
          cancelTextStyle, other.cancelTextStyle, t),
      titleTextStyle: TextStyle.lerp(titleTextStyle, other.titleTextStyle, t),
      messageStyle: TextStyle.lerp(messageStyle, other.messageStyle, t),
      cancelHeight: lerpDouble(cancelHeight, other.cancelHeight, t),
      itemPadding: EdgeInsets.lerp(itemPadding, other.itemPadding, t),
      titlePadding: EdgeInsets.lerp(titlePadding, other.titlePadding, t),
    );
  }

}