import 'package:flutter/material.dart';

/// 紧凑布尔属性开关。
class TolyToggleField extends StatelessWidget {
  /// 当前值。
  final bool value;

  /// 可选标签。
  final Widget? label;

  /// 是否允许切换。
  final bool enabled;

  /// 值变化回调。
  final ValueChanged<bool>? onChanged;

  const TolyToggleField({
    super.key,
    required this.value,
    this.label,
    this.enabled = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Widget toggle = SizedBox(
      width: 34,
      height: 20,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Switch(
          value: value,
          onChanged: enabled ? onChanged : null,
        ),
      ),
    );
    if (label == null) return toggle;
    return InkWell(
      hoverColor: Colors.transparent,
      onTap:
          enabled && onChanged != null ? () => onChanged!.call(!value) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: <Widget>[
            Expanded(child: label!),
            toggle,
          ],
        ),
      ),
    );
  }
}
