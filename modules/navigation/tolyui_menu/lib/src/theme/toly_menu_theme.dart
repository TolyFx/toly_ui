import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Toly 菜单组件使用的视觉配置。
@immutable
final class TolyMenuThemeData extends ThemeExtension<TolyMenuThemeData> {
  /// 单个菜单面板的宽度。
  final double panelWidth;

  /// 单个菜单项的高度。
  final double itemHeight;

  /// 相邻子菜单面板之间的距离。
  final double submenuGap;

  /// 菜单面板背景色。
  final Color backgroundColor;

  /// 菜单项默认前景色。
  final Color foregroundColor;

  /// 禁用菜单项的前景色。
  final Color disabledColor;

  /// 活动菜单项背景色。
  final Color activeColor;

  /// 菜单边框色。
  final Color borderColor;

  /// 菜单边框宽度。
  final double borderWidth;

  /// 菜单面板的 Material 阴影高度。
  final double elevation;

  /// 菜单面板阴影色。
  final Color shadowColor;

  /// 菜单面板圆角。
  final BorderRadius borderRadius;

  /// 菜单项圆角。
  final BorderRadius itemBorderRadius;

  const TolyMenuThemeData({
    this.panelWidth = 238,
    this.itemHeight = 28,
    this.submenuGap = 2,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.disabledColor,
    required this.activeColor,
    required this.borderColor,
    this.borderWidth = 0.5,
    this.elevation = 8,
    required this.shadowColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.itemBorderRadius = const BorderRadius.all(Radius.circular(4)),
  });

  /// 根据当前 ColorScheme 创建默认菜单主题。
  factory TolyMenuThemeData.fromColorScheme(ColorScheme colors) {
    return TolyMenuThemeData(
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
      disabledColor: colors.onSurface.withValues(alpha: 0.38),
      activeColor: colors.brightness == Brightness.light
          ? const Color(0xfff5f5f5)
          : colors.onSurface.withValues(alpha: 0.08),
      borderColor: colors.outlineVariant,
      shadowColor: colors.shadow.withValues(alpha: 0.16),
    );
  }

  @override
  TolyMenuThemeData copyWith({
    double? panelWidth,
    double? itemHeight,
    double? submenuGap,
    Color? backgroundColor,
    Color? foregroundColor,
    Color? disabledColor,
    Color? activeColor,
    Color? borderColor,
    double? borderWidth,
    double? elevation,
    Color? shadowColor,
    BorderRadius? borderRadius,
    BorderRadius? itemBorderRadius,
  }) {
    return TolyMenuThemeData(
      panelWidth: panelWidth ?? this.panelWidth,
      itemHeight: itemHeight ?? this.itemHeight,
      submenuGap: submenuGap ?? this.submenuGap,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      disabledColor: disabledColor ?? this.disabledColor,
      activeColor: activeColor ?? this.activeColor,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      elevation: elevation ?? this.elevation,
      shadowColor: shadowColor ?? this.shadowColor,
      borderRadius: borderRadius ?? this.borderRadius,
      itemBorderRadius: itemBorderRadius ?? this.itemBorderRadius,
    );
  }

  @override
  TolyMenuThemeData lerp(
    covariant TolyMenuThemeData? other,
    double t,
  ) {
    if (other == null) return this;
    return TolyMenuThemeData(
      panelWidth: lerpDouble(panelWidth, other.panelWidth, t)!,
      itemHeight: lerpDouble(itemHeight, other.itemHeight, t)!,
      submenuGap: lerpDouble(submenuGap, other.submenuGap, t)!,
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      foregroundColor: Color.lerp(foregroundColor, other.foregroundColor, t)!,
      disabledColor: Color.lerp(disabledColor, other.disabledColor, t)!,
      activeColor: Color.lerp(activeColor, other.activeColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t)!,
      elevation: lerpDouble(elevation, other.elevation, t)!,
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t)!,
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t)!,
      itemBorderRadius: BorderRadius.lerp(
        itemBorderRadius,
        other.itemBorderRadius,
        t,
      )!,
    );
  }
}

/// 从当前 Theme 中读取菜单主题。
extension TolyMenuThemeContext on BuildContext {
  /// 当前生效的菜单主题。
  TolyMenuThemeData get tolyMenuTheme {
    return Theme.of(this).extension<TolyMenuThemeData>() ??
        TolyMenuThemeData.fromColorScheme(Theme.of(this).colorScheme);
  }
}
