import 'package:flutter/material.dart';

/// Tag variant types
enum TagVariant {
  filled,
  solid,
  outlined,
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
class TagTheme {
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
  final double paddingHorizontal;
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
    this.paddingHorizontal = 8.0,
    this.borderWidth = 1.0,
    this.borderRadius = 4.0,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  static TagTheme defaultTheme() {
    return TagTheme(
      defaultBg: const Color(0xFFFAFAFA),
      defaultColor: const Color(0xFF000000),
      solidTextColor: Colors.white,
      colorBorder: const Color(0xFFD9D9D9),
      colorIcon: const Color(0xFF8C8C8C),
      colorTextHeading: const Color(0xFF262626),
      colorPrimary: const Color(0xFF1890FF),
      colorPrimaryHover: const Color(0xFF40A9FF),
      colorPrimaryActive: const Color(0xFF096DD9),
      colorFillSecondary: const Color(0xFFF5F5F5),
      colorTextLightSolid: Colors.white,
      colorTextDisabled: const Color(0xFFBFBFBF),
      colorBgContainerDisabled: const Color(0xFFF5F5F5),
      colorBorderDisabled: const Color(0xFFD9D9D9),
      colorBgSolid: const Color(0xFF595959),
    );
  }
}
