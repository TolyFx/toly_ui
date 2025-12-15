import 'package:flutter/material.dart';

/// 缺省页主题配置
class DefaultTheme {
  final double iconSize;
  final Color? iconColor;
  final TextStyle? titleStyle;
  final TextStyle? descriptionStyle;
  final double spacing;

  const DefaultTheme({
    this.iconSize = 80,
    this.iconColor,
    this.titleStyle,
    this.descriptionStyle,
    this.spacing = 16,
  });

  DefaultTheme copyWith({
    double? iconSize,
    Color? iconColor,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    double? spacing,
  }) {
    return DefaultTheme(
      iconSize: iconSize ?? this.iconSize,
      iconColor: iconColor ?? this.iconColor,
      titleStyle: titleStyle ?? this.titleStyle,
      descriptionStyle: descriptionStyle ?? this.descriptionStyle,
      spacing: spacing ?? this.spacing,
    );
  }
}

/// 缺省页主题继承
class DefaultThemeScope extends InheritedWidget {
  final DefaultTheme theme;

  const DefaultThemeScope({
    super.key,
    required this.theme,
    required super.child,
  });

  static DefaultTheme of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DefaultThemeScope>()?.theme ??
        const DefaultTheme();
  }

  @override
  bool updateShouldNotify(DefaultThemeScope oldWidget) {
    return theme != oldWidget.theme;
  }
}
