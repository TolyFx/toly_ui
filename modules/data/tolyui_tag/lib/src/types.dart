import 'dart:ui';
import 'package:flutter/material.dart';

/// Tag variant types
enum TagVariant {
  filled,
  solid,
  outlined,
  dashed,
}

/// Preset color types
enum PresetColorType {
  magenta,
  red,
  volcano,
  orange,
  gold,
  lime,
  green,
  cyan,
  blue,
  geekblue,
  purple,
}

/// Status color types
enum PresetStatusColorType {
  success,
  processing,
  error,
  warning,
}

/// Tag theme configuration
class TagTheme extends ThemeExtension<TagTheme> {
  final Color defaultBg;
  final Color defaultColor;
  final Color solidTextColor;
  final Color colorBorder;
  final Color colorIcon;
  final Color colorTextHeading;
  final Color colorPrimary;
  final Color colorPrimaryHover;
  final Color colorPrimaryActive;
  final Color colorFillSecondary;
  final Color colorTextLightSolid;
  final Color colorTextDisabled;
  final Color colorBgContainerDisabled;
  final Color colorBorderDisabled;
  final Color colorBgSolid;
  final double fontSize;
  final double lineHeight;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final double borderWidth;
  final double borderRadius;
  final Duration animationDuration;

  const TagTheme({
    required this.defaultBg,
    required this.defaultColor,
    required this.solidTextColor,
    required this.colorBorder,
    required this.colorIcon,
    required this.colorTextHeading,
    required this.colorPrimary,
    required this.colorPrimaryHover,
    required this.colorPrimaryActive,
    required this.colorFillSecondary,
    required this.colorTextLightSolid,
    required this.colorTextDisabled,
    required this.colorBgContainerDisabled,
    required this.colorBorderDisabled,
    required this.colorBgSolid,
    this.fontSize = 12.0,
    this.lineHeight = 20.0,
    this.iconSize = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
    this.borderWidth = 1.0,
    this.borderRadius = 4.0,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  TagTheme.tolyui({
    this.defaultBg = const Color(0xFFFAFAFA),
    this.defaultColor = const Color(0xFF000000),
    this.solidTextColor = Colors.white,
    this.colorBorder = const Color(0xFFD9D9D9),
    this.colorIcon = const Color(0xFF8C8C8C),
    this.colorTextHeading = const Color(0xFF262626),
    this.colorPrimary = const Color(0xFF1890FF),
    this.colorPrimaryHover = const Color(0xFF40A9FF),
    this.colorPrimaryActive = const Color(0xFF096DD9),
    this.colorFillSecondary = const Color(0xFFF5F5F5),
    this.colorTextLightSolid = Colors.white,
    this.colorTextDisabled = const Color(0xFFBFBFBF),
    this.colorBgContainerDisabled = const Color(0xFFF5F5F5),
    this.colorBorderDisabled = const Color(0xFFD9D9D9),
    this.colorBgSolid = const Color(0xFF595959),
    this.fontSize = 12.0,
    this.lineHeight = 20.0,
    this.iconSize = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
    this.borderWidth = 1.0,
    this.borderRadius = 4.0,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  TagTheme copyWith({
    Color? defaultBg,
    Color? defaultColor,
    Color? solidTextColor,
    Color? colorBorder,
    Color? colorIcon,
    Color? colorTextHeading,
    Color? colorPrimary,
    Color? colorPrimaryHover,
    Color? colorPrimaryActive,
    Color? colorFillSecondary,
    Color? colorTextLightSolid,
    Color? colorTextDisabled,
    Color? colorBgContainerDisabled,
    Color? colorBorderDisabled,
    Color? colorBgSolid,
    double? fontSize,
    double? lineHeight,
    double? iconSize,
    EdgeInsetsGeometry? padding,
    double? borderWidth,
    double? borderRadius,
    Duration? animationDuration,
  }) {
    return TagTheme(
      defaultBg: defaultBg ?? this.defaultBg,
      defaultColor: defaultColor ?? this.defaultColor,
      solidTextColor: solidTextColor ?? this.solidTextColor,
      colorBorder: colorBorder ?? this.colorBorder,
      colorIcon: colorIcon ?? this.colorIcon,
      colorTextHeading: colorTextHeading ?? this.colorTextHeading,
      colorPrimary: colorPrimary ?? this.colorPrimary,
      colorPrimaryHover: colorPrimaryHover ?? this.colorPrimaryHover,
      colorPrimaryActive: colorPrimaryActive ?? this.colorPrimaryActive,
      colorFillSecondary: colorFillSecondary ?? this.colorFillSecondary,
      colorTextLightSolid: colorTextLightSolid ?? this.colorTextLightSolid,
      colorTextDisabled: colorTextDisabled ?? this.colorTextDisabled,
      colorBgContainerDisabled: colorBgContainerDisabled ?? this.colorBgContainerDisabled,
      colorBorderDisabled: colorBorderDisabled ?? this.colorBorderDisabled,
      colorBgSolid: colorBgSolid ?? this.colorBgSolid,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      iconSize: iconSize ?? this.iconSize,
      padding: padding ?? this.padding,
      borderWidth: borderWidth ?? this.borderWidth,
      borderRadius: borderRadius ?? this.borderRadius,
      animationDuration: animationDuration ?? this.animationDuration,
    );
  }

  @override
  TagTheme lerp(TagTheme? other, double t) {
    if (other is! TagTheme) return this;
    return TagTheme(
      defaultBg: Color.lerp(defaultBg, other.defaultBg, t)!,
      defaultColor: Color.lerp(defaultColor, other.defaultColor, t)!,
      solidTextColor: Color.lerp(solidTextColor, other.solidTextColor, t)!,
      colorBorder: Color.lerp(colorBorder, other.colorBorder, t)!,
      colorIcon: Color.lerp(colorIcon, other.colorIcon, t)!,
      colorTextHeading: Color.lerp(colorTextHeading, other.colorTextHeading, t)!,
      colorPrimary: Color.lerp(colorPrimary, other.colorPrimary, t)!,
      colorPrimaryHover: Color.lerp(colorPrimaryHover, other.colorPrimaryHover, t)!,
      colorPrimaryActive: Color.lerp(colorPrimaryActive, other.colorPrimaryActive, t)!,
      colorFillSecondary: Color.lerp(colorFillSecondary, other.colorFillSecondary, t)!,
      colorTextLightSolid: Color.lerp(colorTextLightSolid, other.colorTextLightSolid, t)!,
      colorTextDisabled: Color.lerp(colorTextDisabled, other.colorTextDisabled, t)!,
      colorBgContainerDisabled: Color.lerp(colorBgContainerDisabled, other.colorBgContainerDisabled, t)!,
      colorBorderDisabled: Color.lerp(colorBorderDisabled, other.colorBorderDisabled, t)!,
      colorBgSolid: Color.lerp(colorBgSolid, other.colorBgSolid, t)!,
      fontSize: lerpDouble(fontSize, other.fontSize, t) ?? fontSize,
      lineHeight: lerpDouble(lineHeight, other.lineHeight, t) ?? lineHeight,
      iconSize: lerpDouble(iconSize, other.iconSize, t) ?? iconSize,
      padding: EdgeInsetsGeometry.lerp(padding, other.padding, t) ?? padding,
      borderWidth: lerpDouble(borderWidth, other.borderWidth, t) ?? borderWidth,
      borderRadius: lerpDouble(borderRadius, other.borderRadius, t) ?? borderRadius,
      animationDuration: t < 0.5 ? animationDuration : other.animationDuration,
    );
  }

  static TagTheme defaultTheme() => TagTheme.tolyui();
}
