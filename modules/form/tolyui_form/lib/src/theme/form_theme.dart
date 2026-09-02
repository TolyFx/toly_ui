import 'package:flutter/material.dart';

/// 表单控件的视觉密度。
enum TolyFormDensity {
  /// Figma 属性面板式紧凑密度。
  compact,

  /// 常规桌面表单密度。
  regular,
}

/// Toly 表单组件共享的主题令牌。
@immutable
class TolyFormThemeData extends ThemeExtension<TolyFormThemeData> {
  /// 紧凑控件高度。
  final double compactHeight;

  /// 常规控件高度。
  final double regularHeight;

  /// 控件圆角。
  final BorderRadius borderRadius;

  /// 默认边框色。
  final Color borderColor;

  /// 悬停边框色。
  final Color hoverBorderColor;

  /// 聚焦边框色。
  final Color focusBorderColor;

  /// 错误状态颜色。
  final Color errorColor;

  /// 禁用背景色。
  final Color disabledFillColor;

  /// 字段背景色。
  final Color fillColor;

  /// 字段悬停背景色。
  final Color hoverFillColor;

  /// 字段聚焦背景色。
  final Color focusFillColor;

  /// 状态过渡时长。
  final Duration animationDuration;

  const TolyFormThemeData({
    this.compactHeight = 28,
    this.regularHeight = 34,
    this.borderRadius = const BorderRadius.all(Radius.circular(5)),
    required this.borderColor,
    required this.hoverBorderColor,
    required this.focusBorderColor,
    required this.errorColor,
    required this.disabledFillColor,
    required this.fillColor,
    required this.hoverFillColor,
    required this.focusFillColor,
    this.animationDuration = const Duration(milliseconds: 120),
  });

  /// 从当前 Material 主题生成默认表单令牌。
  factory TolyFormThemeData.fallback(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return TolyFormThemeData(
      borderColor: Colors.transparent,
      hoverBorderColor: Colors.transparent,
      focusBorderColor: colors.primary,
      errorColor: colors.error,
      disabledFillColor: colors.onSurface.withValues(alpha: 0.04),
      fillColor: colors.onSurface.withValues(alpha: 0.045),
      hoverFillColor: colors.onSurface.withValues(alpha: 0.08),
      focusFillColor: colors.surface,
    );
  }

  /// 读取主题扩展；应用未配置时使用 Material 主题推导值。
  static TolyFormThemeData of(BuildContext context) {
    return Theme.of(context).extension<TolyFormThemeData>() ??
        TolyFormThemeData.fallback(context);
  }

  /// 返回指定密度对应的控件高度。
  double heightOf(TolyFormDensity density) => switch (density) {
        TolyFormDensity.compact => compactHeight,
        TolyFormDensity.regular => regularHeight,
      };

  @override
  TolyFormThemeData copyWith({
    double? compactHeight,
    double? regularHeight,
    BorderRadius? borderRadius,
    Color? borderColor,
    Color? hoverBorderColor,
    Color? focusBorderColor,
    Color? errorColor,
    Color? disabledFillColor,
    Color? fillColor,
    Color? hoverFillColor,
    Color? focusFillColor,
    Duration? animationDuration,
  }) {
    return TolyFormThemeData(
      compactHeight: compactHeight ?? this.compactHeight,
      regularHeight: regularHeight ?? this.regularHeight,
      borderRadius: borderRadius ?? this.borderRadius,
      borderColor: borderColor ?? this.borderColor,
      hoverBorderColor: hoverBorderColor ?? this.hoverBorderColor,
      focusBorderColor: focusBorderColor ?? this.focusBorderColor,
      errorColor: errorColor ?? this.errorColor,
      disabledFillColor: disabledFillColor ?? this.disabledFillColor,
      fillColor: fillColor ?? this.fillColor,
      hoverFillColor: hoverFillColor ?? this.hoverFillColor,
      focusFillColor: focusFillColor ?? this.focusFillColor,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }

  @override
  TolyFormThemeData lerp(
    covariant ThemeExtension<TolyFormThemeData>? other,
    double t,
  ) {
    if (other is! TolyFormThemeData) return this;
    return TolyFormThemeData(
      compactHeight: _lerpDouble(compactHeight, other.compactHeight, t),
      regularHeight: _lerpDouble(regularHeight, other.regularHeight, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      hoverBorderColor: Color.lerp(
        hoverBorderColor,
        other.hoverBorderColor,
        t,
      )!,
      focusBorderColor: Color.lerp(
        focusBorderColor,
        other.focusBorderColor,
        t,
      )!,
      errorColor: Color.lerp(errorColor, other.errorColor, t)!,
      disabledFillColor: Color.lerp(
        disabledFillColor,
        other.disabledFillColor,
        t,
      )!,
      fillColor: Color.lerp(fillColor, other.fillColor, t)!,
      hoverFillColor: Color.lerp(
        hoverFillColor,
        other.hoverFillColor,
        t,
      )!,
      focusFillColor: Color.lerp(
        focusFillColor,
        other.focusFillColor,
        t,
      )!,
      animationDuration: t < 0.5 ? animationDuration : other.animationDuration,
    );
  }

  double _lerpDouble(double begin, double end, double t) {
    return begin + (end - begin) * t;
  }
}
