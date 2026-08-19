import 'package:flutter/material.dart';

import '../theme/form_theme.dart';

/// 单个选择项。
class TolySelectOption<T> {
  /// 选项值。
  final T value;

  /// 展示标签。
  final String label;

  /// 可选前置图标。
  final IconData? icon;

  const TolySelectOption({
    required this.value,
    required this.label,
    this.icon,
  });
}

/// 紧凑桌面下拉选择字段。
class TolySelectField<T> extends StatelessWidget {
  /// 当前值。
  final T? value;

  /// 可选项。
  final List<TolySelectOption<T>> options;

  /// 占位提示。
  final String? placeholder;

  /// 是否允许选择。
  final bool enabled;

  /// 视觉密度。
  final TolyFormDensity density;

  /// 选择变化回调。
  final ValueChanged<T?>? onChanged;

  const TolySelectField({
    super.key,
    required this.value,
    required this.options,
    this.placeholder,
    this.enabled = true,
    this.density = TolyFormDensity.compact,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final TolyFormThemeData theme = TolyFormThemeData.of(context);
    return SizedBox(
      height: theme.heightOf(density),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(
          filled: true,
          fillColor: enabled ? theme.fillColor : theme.disabledFillColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          enabledBorder: OutlineInputBorder(
            borderRadius: theme.borderRadius,
            borderSide: BorderSide(color: theme.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: theme.borderRadius,
            borderSide: BorderSide(color: theme.focusBorderColor),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: theme.borderRadius,
            borderSide: BorderSide(color: theme.borderColor),
          ),
        ),
        hint: placeholder == null ? null : Text(placeholder!),
        items: options.map(_buildOption).toList(growable: false),
        onChanged: enabled ? onChanged : null,
      ),
    );
  }

  DropdownMenuItem<T> _buildOption(TolySelectOption<T> option) {
    return DropdownMenuItem<T>(
      value: option.value,
      child: Row(
        children: <Widget>[
          if (option.icon != null) ...<Widget>[
            Icon(option.icon, size: 15),
            const SizedBox(width: 6),
          ],
          Expanded(child: Text(option.label, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
