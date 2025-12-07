import 'package:flutter/material.dart';
import 'checkable_tag.dart';
import 'types.dart';

class TagOption<T> {
  final T value;
  final Widget label;

  const TagOption({
    required this.value,
    required this.label,
  });
}

class TolyTagGroup<T> extends StatefulWidget {
  final List<TagOption<T>> options;
  final T? value;
  final List<T>? values;
  final ValueChanged<T?>? onChange;
  final ValueChanged<List<T>>? onChangeMultiple;
  final bool multiple;
  final bool disabled;
  final double gap;
  final TagTheme? theme;

  const TolyTagGroup({
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
  State<TolyTagGroup<T>> createState() => _TolyTagGroupState<T>();
}

class _TolyTagGroupState<T> extends State<TolyTagGroup<T>> {
  late T? _singleValue;
  late List<T> _multipleValues;

  @override
  void initState() {
    super.initState();
    _singleValue = widget.value;
    _multipleValues = widget.values ?? [];
  }

  @override
  void didUpdateWidget(TolyTagGroup<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _singleValue = widget.value;
    }
    if (widget.values != oldWidget.values) {
      _multipleValues = widget.values ?? [];
    }
  }

  void _handleChange(bool checked, TagOption<T> option) {
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

  bool _isChecked(TagOption<T> option) {
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
