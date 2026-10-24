import 'package:flutter/material.dart';

/// 尺寸输入器的局部样式，未覆盖项沿用表单主题。
@immutable
class TolyDimensionInputStyle {
  const TolyDimensionInputStyle({
    this.height,
    this.fieldWidth,
    this.fieldGap = 6,
    this.labelGap = 4,
    this.lockGap = 4,
    this.lockWidth = 24,
    this.lockIconSize = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 6),
    this.borderRadius,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.fillColor,
    this.disabledFillColor,
    this.activeColor,
    this.inactiveColor,
    this.cursorColor,
    this.cursorWidth = 1,
    this.cursorHeight,
    this.cursorRadius,
    this.selectionColor,
  })  : assert(height == null || height > 0),
        assert(fieldWidth == null || fieldWidth > 0),
        assert(fieldGap >= 0 && labelGap >= 0 && lockGap >= 0),
        assert(lockWidth > 0 && lockIconSize > 0),
        assert(cursorWidth > 0),
        assert(cursorHeight == null || cursorHeight > 0);

  /// 控件高度，空时由表单密度决定。
  final double? height;

  /// 单个字段固定宽度；空时两个字段均分可用宽度。
  final double? fieldWidth;

  /// 两个字段的间距。
  final double fieldGap;

  /// 字段前缀与数值的间距。
  final double labelGap;

  /// 高度字段与比例动作的间距。
  final double lockGap;

  /// 比例动作区宽度。
  final double lockWidth;

  /// 比例图标尺寸。
  final double lockIconSize;

  /// 每个字段内部的留白。
  final EdgeInsetsGeometry padding;

  /// 字段及动作反馈区域的圆角。
  final BorderRadius? borderRadius;

  /// 数值文字样式。
  final TextStyle? textStyle;

  /// W/H标签样式。
  final TextStyle? labelStyle;

  /// 空值占位样式。
  final TextStyle? hintStyle;

  /// 字段背景色。
  final Color? fillColor;

  /// 禁用时的字段背景色。
  final Color? disabledFillColor;

  /// 比例锁定色及键盘、鼠标反馈色。
  final Color? activeColor;

  /// 比例解锁图标颜色。
  final Color? inactiveColor;

  /// 插入光标颜色。
  final Color? cursorColor;

  /// 插入光标粗细。
  final double cursorWidth;

  /// 插入光标高度，空时随字体计算。
  final double? cursorHeight;

  /// 插入光标圆角。
  final Radius? cursorRadius;

  /// 文字选中背景，空时继承当前文字选区主题。
  final Color? selectionColor;
}
