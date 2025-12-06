import 'package:flutter/material.dart';
import 'checkable_tag.dart';
import 'types.dart';

class CheckableTagOption<T> {
  final T value;
  final Widget label;

  const CheckableTagOption({
    required this.value,
    required this.label,
  });
}

class CheckableTagGroup<T> extends StatefulWidget {
  final List<CheckableTagOption<T>> options;
  final T? value;
  final List<T>? values;
  final ValueChanged<T?>? onChange;
  final ValueChanged<List<T>>? onChangeMultiple;
  final bool multiple;
  final bool disabled;
  final double gap;
  final TagTheme? theme;

  const CheckableTagGroup({
    Key? key,
    required this.options,
    this.value,
    this.values,
    this.onChange,
    this.onChangeMultiple,
    this.multiple = false,
    this.disabled = false,
    this.gap = 8.0,
    this.theme,
  }) : super(key: key);

  @override
  State<CheckableTagGroup<T>> createState() => _CheckableTagGroupState<T>();
}

class _CheckableTagGroupState<T> extends State<CheckableTagGroup<T>> {
  late T? _singleValue;
  late List<T> _multipleValues;

  @override
  void initState() {
    super.initState();
    _singleValue = widget.value;
    _multipleValues = widget.values ?? [];
  }

  @override
  void didUpdateWidget(CheckableTagGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _singleValue = widget.value;
    }
    if (widget.values != oldWidget.values) {
      _multipleValues = widget.values ?? [];
    }
  }

  void _handleChange(bool checked, CheckableTagOption<T> option) {
    if (widget.multiple) {
      final newValues = List<T>.from(_multipleValues);
      if (checked) {
        newValues.add(option.value);
      } else {
        newValues.remove(option.value);
      }
      setState(() => _multipleValues = newValues);
      widget.onChangeMultiple?.call(newValues);
    } else {
      final newValue = checked ? option.value : null;
      setState(() => _singleValue = newValue);
      widget.onChange?.call(newValue);
    }
  }

  bool _isChecked(CheckableTagOption<T> option) {
    if (widget.multiple) {
      return _multipleValues.contains(option.value);
    }
    return _singleValue == option.value;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: widget.gap,
      runSpacing: widget.gap,
      children: widget.options.map((option) {
        return CheckableTag(
          checked: _isChecked(option),
          onChange: (checked) => _handleChange(checked, option),
          disabled: widget.disabled,
          theme: widget.theme,
          child: option.label,
        );
      }).toList(),
    );
  }
}
