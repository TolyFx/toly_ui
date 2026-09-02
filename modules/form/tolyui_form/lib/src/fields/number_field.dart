import 'package:flutter/material.dart';

import '../theme/form_theme.dart';
import 'text_field.dart';

/// 数字字段数值回调。
typedef TolyNumberChanged = void Function(double value);

/// 支持键盘输入、步进和 Figma 式标签拖拽的数字字段。
class TolyNumberField extends StatefulWidget {
  /// 当前数值。
  final double value;

  /// 字段内短标签，例如 X、Y、W。
  final String? label;

  /// 数值单位。
  final String? unit;

  /// 每次步进或每像素拖拽对应的增量。
  final double step;

  /// 可选最小值。
  final double? minimum;

  /// 可选最大值。
  final double? maximum;

  /// 小数位数。
  final int fractionDigits;

  /// 是否允许编辑。
  final bool enabled;

  /// 视觉密度。
  final TolyFormDensity density;

  /// 数值变化回调。
  final TolyNumberChanged? onChanged;

  /// 数值提交回调。
  final TolyNumberChanged? onSubmitted;

  const TolyNumberField({
    super.key,
    required this.value,
    this.label,
    this.unit,
    this.step = 1,
    this.minimum,
    this.maximum,
    this.fractionDigits = 2,
    this.enabled = true,
    this.density = TolyFormDensity.compact,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<TolyNumberField> createState() => _TolyNumberFieldState();
}

class _TolyNumberFieldState extends State<TolyNumberField> {
  /// 拖拽开始时的数值。
  double _dragOrigin = 0;

  /// 当前拖拽累计的水平距离。
  double _dragDistance = 0;

  @override
  Widget build(BuildContext context) {
    return TolyTextField(
      value: _format(widget.value),
      enabled: widget.enabled,
      density: widget.density,
      prefix: widget.label == null ? null : _buildScrubLabel(context),
      suffix: widget.unit == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(right: 7),
              child: Text(
                widget.unit!,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
      onSubmitted: _submitRaw,
    );
  }

  /// 构建可水平拖拽调值的字段标签。
  Widget _buildScrubLabel(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _handlePointerDown,
        onPointerMove: _handlePointerMove,
        onPointerUp: _handlePointerUp,
        onPointerCancel: _handlePointerCancel,
        child: Center(
          child: Text(
            widget.label!,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ),
    );
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (!widget.enabled) return;
    _dragOrigin = widget.value;
    _dragDistance = 0;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (!widget.enabled) return;
    _dragDistance += event.delta.dx;
    widget.onChanged?.call(_clamp(_dragOrigin + _dragDistance * widget.step));
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (!widget.enabled) return;
    widget.onSubmitted?.call(
      _clamp(_dragOrigin + _dragDistance * widget.step),
    );
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _dragDistance = 0;
  }

  void _submitRaw(String raw) {
    final double? parsed = double.tryParse(raw.trim());
    if (parsed == null) return;
    final double value = _clamp(parsed);
    widget.onChanged?.call(value);
    widget.onSubmitted?.call(value);
  }

  double _clamp(double value) {
    final double lower = widget.minimum ?? double.negativeInfinity;
    final double upper = widget.maximum ?? double.infinity;
    return value.clamp(lower, upper).toDouble();
  }

  String _format(double value) {
    final double rounded = value.roundToDouble();
    if ((value - rounded).abs() < 0.000001) return rounded.toInt().toString();
    return value.toStringAsFixed(widget.fractionDigits);
  }
}
