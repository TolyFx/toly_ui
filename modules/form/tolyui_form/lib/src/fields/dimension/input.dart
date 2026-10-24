import 'package:flutter/material.dart';

import '../../theme/form_theme.dart';
import '../type_action_target.dart';
import 'style.dart';
import 'value_field.dart';

export 'style.dart';

/// 受控的W/H尺寸输入器，只负责表单外观和交互，不计算媒体比例。
class TolyDimensionInput extends StatelessWidget {
  const TolyDimensionInput(
      {required this.widthController,
      required this.heightController,
      required this.widthFocusNode,
      required this.heightFocusNode,
      required this.locked,
      this.onLockChanged,
      this.onWidthChanged,
      this.onHeightChanged,
      this.onWidthSubmitted,
      this.onHeightSubmitted,
      this.enabled = true,
      this.showLock = true,
      this.widthLabel = 'W',
      this.heightLabel = 'H',
      this.widthSemanticLabel = '宽度',
      this.heightSemanticLabel = '高度',
      this.lockSemanticLabel = '锁定比例',
      this.placeholder = '—',
      this.maxDigits = 5,
      this.density = TolyFormDensity.compact,
      this.style = const TolyDimensionInputStyle(),
      this.widthFieldKey,
      this.heightFieldKey,
      this.lockKey,
      super.key})
      : assert(maxDigits > 0);

  /// 宿主创建、同步和销毁的宽度草稿。
  final TextEditingController widthController;

  /// 宿主创建、同步和销毁的高度草稿。
  final TextEditingController heightController;

  /// 宿主可监听宽度失焦以提交业务参数。
  final FocusNode widthFocusNode;

  /// 宿主可监听高度失焦以提交业务参数。
  final FocusNode heightFocusNode;

  /// 当前比例锁定状态，组件不会自动修改宽高。
  final bool locked;

  /// 比例动作请求的新值，初始化及恢复不会触发。
  final ValueChanged<bool>? onLockChanged;

  /// 宽度原始草稿变化，不等同于业务提交。
  final ValueChanged<String>? onWidthChanged;

  /// 高度原始草稿变化，不等同于业务提交。
  final ValueChanged<String>? onHeightChanged;

  /// 宽度回车确认，不额外合成失焦事件。
  final ValueChanged<String>? onWidthSubmitted;

  /// 高度回车确认，不额外合成失焦事件。
  final ValueChanged<String>? onHeightSubmitted;

  /// 同时禁用输入、焦点和比例动作。
  final bool enabled;

  /// 是否展示比例动作区。
  final bool showLock;

  /// 宽度短标签。
  final String widthLabel;

  /// 高度短标签。
  final String heightLabel;

  /// 宽度无障碍名称，可由宿主补充单位。
  final String widthSemanticLabel;

  /// 高度无障碍名称，可由宿主补充单位。
  final String heightSemanticLabel;

  /// 比例动作的无障碍名称，不生成Tooltip。
  final String lockSemanticLabel;

  /// 两个字段的空值占位。
  final String placeholder;

  /// 数字长度限制，合法范围由业务决定。
  final int maxDigits;

  /// 视觉密度，默认高度来自表单主题。
  final TolyFormDensity density;

  /// 可覆盖高度、宽度、文字、颜色、光标与选区。
  final TolyDimensionInputStyle style;

  /// 宿主定位宽度表面与其输入框。
  final Key? widthFieldKey;

  /// 宿主定位高度表面与其输入框。
  final Key? heightFieldKey;

  /// 宿主定位比例操作区。
  final Key? lockKey;

  @override
  Widget build(BuildContext context) {
    final TolyFormThemeData form = TolyFormThemeData.of(context);
    final Color active = style.activeColor ?? form.focusBorderColor;
    final double height = style.height ?? form.heightOf(density);
    final TolyDimensionInputStyle field = TolyDimensionInputStyle(
        labelGap: style.labelGap,
        padding: style.padding,
        borderRadius: style.borderRadius ?? form.borderRadius,
        textStyle: style.textStyle,
        labelStyle: style.labelStyle,
        hintStyle: style.hintStyle,
        fillColor: enabled
            ? style.fillColor ?? form.fillColor
            : style.disabledFillColor ?? form.disabledFillColor,
        cursorColor: style.cursorColor ?? active,
        cursorWidth: style.cursorWidth,
        cursorHeight: style.cursorHeight,
        cursorRadius: style.cursorRadius);
    final Widget row = Row(
        mainAxisSize:
            style.fieldWidth == null ? MainAxisSize.max : MainAxisSize.min,
        children: [
          _sized(DimensionValueField(
              key: widthFieldKey,
              controller: widthController,
              focusNode: widthFocusNode,
              label: widthLabel,
              semanticLabel: widthSemanticLabel,
              placeholder: placeholder,
              enabled: enabled,
              height: height,
              style: field,
              maxDigits: maxDigits,
              onChanged: onWidthChanged,
              onSubmitted: onWidthSubmitted)),
          SizedBox(width: style.fieldGap),
          _sized(DimensionValueField(
              key: heightFieldKey,
              controller: heightController,
              focusNode: heightFocusNode,
              label: heightLabel,
              semanticLabel: heightSemanticLabel,
              placeholder: placeholder,
              enabled: enabled,
              height: height,
              style: field,
              maxDigits: maxDigits,
              onChanged: onHeightChanged,
              onSubmitted: onHeightSubmitted)),
          if (showLock) ...[
            SizedBox(width: style.lockGap),
            SizedBox(
                key: lockKey,
                width: style.lockWidth,
                height: height,
                child: Semantics(
                    toggled: locked,
                    child: ClipRRect(
                        borderRadius: style.borderRadius ?? form.borderRadius,
                        child: TypeActionTarget(
                            enabled: enabled && onLockChanged != null,
                            label: lockSemanticLabel,
                            accent: active,
                            onPressed: _toggle,
                            child: Icon(
                                locked
                                    ? Icons.link_rounded
                                    : Icons.link_off_rounded,
                                size: style.lockIconSize,
                                color: locked
                                    ? active
                                    : style.inactiveColor ??
                                        Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant))))),
          ],
        ]);
    final TextSelectionThemeData selection = TextSelectionTheme.of(context);
    return TextSelectionTheme(
        data: selection.copyWith(
            cursorColor: style.cursorColor ?? active,
            selectionColor: style.selectionColor ??
                selection.selectionColor ??
                active.withValues(alpha: .2),
            selectionHandleColor: active),
        child: row);
  }

  Widget _sized(Widget child) => style.fieldWidth == null
      ? Expanded(child: child)
      : SizedBox(width: style.fieldWidth, child: child);

  void _toggle() {
    if (enabled) onLockChanged?.call(!locked);
  }
}
