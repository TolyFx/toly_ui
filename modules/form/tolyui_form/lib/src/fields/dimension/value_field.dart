import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'style.dart';

/// 尺寸输入器内部的单字段表面，草稿和焦点仍由宿主持有。
class DimensionValueField extends StatelessWidget {
  const DimensionValueField(
      {required this.controller,
      required this.focusNode,
      required this.label,
      required this.semanticLabel,
      required this.placeholder,
      required this.enabled,
      required this.height,
      required this.style,
      required this.maxDigits,
      this.onChanged,
      this.onSubmitted,
      super.key});

  /// 宿主拥有的原始文本草稿。
  final TextEditingController controller;

  /// 宿主拥有的聚焦与失焦状态。
  final FocusNode focusNode;

  /// 字段内部的短标签。
  final String label;

  /// 字段无障碍名称。
  final String semanticLabel;

  /// 空白输入的占位文字。
  final String placeholder;

  /// 是否允许编辑。
  final bool enabled;

  /// 已按密度解析的高度。
  final double height;

  /// 已从组件传入的局部样式。
  final TolyDimensionInputStyle style;

  /// 数字位数限制，不负责业务数值范围。
  final int maxDigits;

  /// 原始输入变化事件。
  final ValueChanged<String>? onChanged;

  /// 用户按回车确认的原始输入。
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextStyle text =
        TextStyle(fontSize: 12, color: colors.onSurface).merge(style.textStyle);
    return Container(
        height: height,
        padding: style.padding,
        decoration: BoxDecoration(
            color: style.fillColor, borderRadius: style.borderRadius),
        child: Row(children: [
          Text(label,
              style: TextStyle(fontSize: 10, color: colors.onSurfaceVariant)
                  .merge(style.labelStyle)),
          SizedBox(width: style.labelGap),
          Expanded(
              child: Semantics(
                  label: semanticLabel,
                  child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      enabled: enabled,
                      style: text,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(maxDigits)
                      ],
                      cursorColor: style.cursorColor,
                      cursorWidth: style.cursorWidth,
                      cursorHeight: style.cursorHeight,
                      cursorRadius: style.cursorRadius,
                      decoration: InputDecoration(
                          hintText: placeholder,
                          hintStyle: text
                              .copyWith(color: colors.onSurfaceVariant)
                              .merge(style.hintStyle),
                          isCollapsed: true,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero),
                      onChanged: enabled ? onChanged : null,
                      onSubmitted: enabled ? onSubmitted : null))),
        ]));
  }
}
