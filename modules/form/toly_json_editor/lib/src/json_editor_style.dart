import 'package:flutter/material.dart';

/// JSON 编辑器样式配置
class JsonEditorStyle {
  /// 标签样式
  final TextStyle labelStyle;
  
  /// 文本样式
  final TextStyle textStyle;
  
  /// 提示文本样式
  final TextStyle hintStyle;
  
  /// 错误文本样式
  final TextStyle errorStyle;
  
  /// 边框颜色
  final Color borderColor;
  
  /// 焦点边框颜色
  final Color focusBorderColor;
  
  /// 错误颜色
  final Color errorColor;
  
  /// 验证通过颜色
  final Color validColor;
  
  /// 背景颜色
  final Color backgroundColor;
  
  /// 禁用背景颜色
  final Color disabledColor;
  
  /// 光标颜色
  final Color cursorColor;
  
  /// 工具栏图标颜色
  final Color toolbarIconColor;
  
  /// 禁用图标颜色
  final Color disabledIconColor;
  
  /// 语法高亮 - Key 颜色
  final Color keyColor;
  
  /// 语法高亮 - String 颜色
  final Color stringColor;
  
  /// 语法高亮 - Number 颜色
  final Color numberColor;
  
  /// 语法高亮 - Boolean 颜色
  final Color boolColor;
  
  /// 语法高亮 - Null 颜色
  final Color nullColor;
  
  /// 语法高亮 - 括号颜色
  final Color bracketColor;
  
  /// 圆角
  final BorderRadius borderRadius;
  
  /// 内边距
  final EdgeInsets padding;

  const JsonEditorStyle({
    required this.labelStyle,
    required this.textStyle,
    required this.hintStyle,
    required this.errorStyle,
    required this.borderColor,
    required this.focusBorderColor,
    required this.errorColor,
    required this.validColor,
    required this.backgroundColor,
    required this.disabledColor,
    required this.cursorColor,
    required this.toolbarIconColor,
    required this.disabledIconColor,
    required this.keyColor,
    required this.stringColor,
    required this.numberColor,
    required this.boolColor,
    required this.nullColor,
    required this.bracketColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.padding = const EdgeInsets.all(12),
  });

  /// 从主题创建样式
  factory JsonEditorStyle.fromTheme(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    
    return JsonEditorStyle(
      labelStyle: theme.textTheme.labelLarge?.copyWith(
        color: colorScheme.primary,
      ) ?? TextStyle(color: colorScheme.primary),
      textStyle: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 12,
      ),
      hintStyle: TextStyle(
        fontFamily: 'monospace',
        fontSize: 12,
        color: colorScheme.onSurface.withValues(alpha: 0.3),
      ),
      errorStyle: const TextStyle(
        fontSize: 10,
        color: Colors.red,
      ),
      borderColor: colorScheme.outline,
      focusBorderColor: colorScheme.primary,
      errorColor: Colors.red,
      validColor: Colors.green,
      backgroundColor: colorScheme.surface,
      disabledColor: colorScheme.surfaceContainerHighest,
      cursorColor: colorScheme.primary,
      toolbarIconColor: colorScheme.primary,
      disabledIconColor: colorScheme.outline,
      keyColor: isDark ? Colors.lightBlue[300]! : Colors.blue[700]!,
      stringColor: isDark ? Colors.lightGreen[300]! : Colors.green[700]!,
      numberColor: isDark ? Colors.orange[300]! : Colors.orange[800]!,
      boolColor: isDark ? Colors.purple[300]! : Colors.purple[700]!,
      nullColor: isDark ? Colors.grey[400]! : Colors.grey[600]!,
      bracketColor: isDark ? Colors.grey[300]! : Colors.grey[800]!,
    );
  }

  /// 亮色主题
  factory JsonEditorStyle.light() {
    return JsonEditorStyle(
      labelStyle: TextStyle(
        color: Colors.blue[700],
        fontWeight: FontWeight.w500,
      ),
      textStyle: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 12,
        color: Colors.black87,
      ),
      hintStyle: TextStyle(
        fontFamily: 'monospace',
        fontSize: 12,
        color: Colors.grey[400],
      ),
      errorStyle: const TextStyle(
        fontSize: 10,
        color: Colors.red,
      ),
      borderColor: Colors.grey[300]!,
      focusBorderColor: Colors.blue[700]!,
      errorColor: Colors.red,
      validColor: Colors.green,
      backgroundColor: Colors.white,
      disabledColor: Colors.grey[100]!,
      cursorColor: Colors.blue[700]!,
      toolbarIconColor: Colors.blue[700]!,
      disabledIconColor: Colors.grey[400]!,
      keyColor: Colors.blue[700]!,
      stringColor: Colors.green[700]!,
      numberColor: Colors.orange[800]!,
      boolColor: Colors.purple[700]!,
      nullColor: Colors.grey[600]!,
      bracketColor: Colors.grey[800]!,
    );
  }

  /// 暗色主题
  factory JsonEditorStyle.dark() {
    return JsonEditorStyle(
      labelStyle: TextStyle(
        color: Colors.lightBlue[300],
        fontWeight: FontWeight.w500,
      ),
      textStyle: const TextStyle(
        fontFamily: 'monospace',
        fontSize: 12,
        color: Colors.white70,
      ),
      hintStyle: TextStyle(
        fontFamily: 'monospace',
        fontSize: 12,
        color: Colors.grey[600],
      ),
      errorStyle: const TextStyle(
        fontSize: 10,
        color: Colors.red,
      ),
      borderColor: Colors.grey[700]!,
      focusBorderColor: Colors.lightBlue[300]!,
      errorColor: Colors.red,
      validColor: Colors.green,
      backgroundColor: Colors.grey[900]!,
      disabledColor: Colors.grey[800]!,
      cursorColor: Colors.lightBlue[300]!,
      toolbarIconColor: Colors.lightBlue[300]!,
      disabledIconColor: Colors.grey[600]!,
      keyColor: Colors.lightBlue[300]!,
      stringColor: Colors.lightGreen[300]!,
      numberColor: Colors.orange[300]!,
      boolColor: Colors.purple[300]!,
      nullColor: Colors.grey[400]!,
      bracketColor: Colors.grey[300]!,
    );
  }

  /// 复制并修改部分属性
  JsonEditorStyle copyWith({
    TextStyle? labelStyle,
    TextStyle? textStyle,
    TextStyle? hintStyle,
    TextStyle? errorStyle,
    Color? borderColor,
    Color? focusBorderColor,
    Color? errorColor,
    Color? validColor,
    Color? backgroundColor,
    Color? disabledColor,
    Color? cursorColor,
    Color? toolbarIconColor,
    Color? disabledIconColor,
    Color? keyColor,
    Color? stringColor,
    Color? numberColor,
    Color? boolColor,
    Color? nullColor,
    Color? bracketColor,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
  }) {
    return JsonEditorStyle(
      labelStyle: labelStyle ?? this.labelStyle,
      textStyle: textStyle ?? this.textStyle,
      hintStyle: hintStyle ?? this.hintStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      borderColor: borderColor ?? this.borderColor,
      focusBorderColor: focusBorderColor ?? this.focusBorderColor,
      errorColor: errorColor ?? this.errorColor,
      validColor: validColor ?? this.validColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      disabledColor: disabledColor ?? this.disabledColor,
      cursorColor: cursorColor ?? this.cursorColor,
      toolbarIconColor: toolbarIconColor ?? this.toolbarIconColor,
      disabledIconColor: disabledIconColor ?? this.disabledIconColor,
      keyColor: keyColor ?? this.keyColor,
      stringColor: stringColor ?? this.stringColor,
      numberColor: numberColor ?? this.numberColor,
      boolColor: boolColor ?? this.boolColor,
      nullColor: nullColor ?? this.nullColor,
      bracketColor: bracketColor ?? this.bracketColor,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
    );
  }
}
