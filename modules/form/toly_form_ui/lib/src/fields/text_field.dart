import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/form_theme.dart';

/// 文本字段提交回调。
typedef TolyTextSubmit = void Function(String value);

/// 紧凑、可控且支持 Esc 撤销的文本字段。
class TolyTextField extends StatefulWidget {
  /// 外部文本值。
  final String value;

  /// 占位文本。
  final String? placeholder;

  /// 前缀组件。
  final Widget? prefix;

  /// 后缀组件。
  final Widget? suffix;

  /// 错误提示；非空时显示错误状态。
  final String? errorText;

  /// 是否允许输入。
  final bool enabled;

  /// 是否为只读状态。
  final bool readOnly;

  /// 是否在首次构建后自动聚焦。
  final bool autofocus;

  /// 聚焦时是否自动全选文本。
  final bool selectAllOnFocus;

  /// 最大行数。
  final int maxLines;

  /// 视觉密度。
  final TolyFormDensity density;

  /// 文本对齐方式。
  final TextAlign textAlign;

  /// 键盘类型。
  final TextInputType? keyboardType;

  /// 输入格式化器。
  final List<TextInputFormatter>? inputFormatters;

  /// 实时变化回调。
  final ValueChanged<String>? onChanged;

  /// Enter 或失焦提交回调。
  final TolyTextSubmit? onSubmitted;

  const TolyTextField({
    super.key,
    required this.value,
    this.placeholder,
    this.prefix,
    this.suffix,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.selectAllOnFocus = false,
    this.maxLines = 1,
    this.density = TolyFormDensity.compact,
    this.textAlign = TextAlign.start,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<TolyTextField> createState() => _TolyTextFieldState();
}

class _TolyTextFieldState extends State<TolyTextField> {
  /// 当前输入控制器。
  late final TextEditingController _controller;

  /// 当前输入焦点。
  late final FocusNode _focusNode;

  /// 本次聚焦开始时的值，用于 Esc 撤销。
  String _focusOrigin = '';

  /// 指针是否悬停在字段上。
  bool _hovered = false;

  /// 当前视觉变化是否允许动画；焦点切换必须立即完成。
  bool _animateVisualChange = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _focusNode = FocusNode()..addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(TolyTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      final TextSelection previousSelection = _controller.selection;
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(
          offset: previousSelection.extentOffset.clamp(0, widget.value.length),
        ),
      );
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TolyFormThemeData theme = TolyFormThemeData.of(context);
    final Color borderColor = _borderColor(theme);
    final double height = widget.maxLines == 1
        ? theme.heightOf(widget.density)
        : theme.heightOf(widget.density) * widget.maxLines;
    return MouseRegion(
      cursor:
          widget.enabled ? SystemMouseCursors.text : SystemMouseCursors.basic,
      onEnter: _handlePointerEnter,
      onExit: _handlePointerExit,
      child: AnimatedContainer(
        key: const ValueKey<String>('toly-compact-input-frame'),
        duration:
            _animateVisualChange ? theme.animationDuration : Duration.zero,
        height: height,
        decoration: BoxDecoration(
          color: _fillColor(theme),
          borderRadius: theme.borderRadius,
          border: Border.all(color: borderColor),
        ),
        child: Focus(
          onKeyEvent: _handleKeyEvent,
          child: TextField(
            key: const ValueKey<String>('toly-compact-input-editor'),
            controller: _controller,
            focusNode: _focusNode,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            autofocus: widget.autofocus,
            maxLines: widget.maxLines,
            textAlign: widget.textAlign,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            cursorColor: theme.focusBorderColor,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: widget.placeholder,
              prefixIcon: widget.prefix == null
                  ? null
                  : SizedBox(width: 28, child: widget.prefix),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 28,
                maxWidth: 28,
              ),
              suffixIcon: widget.suffix == null
                  ? null
                  : SizedBox(width: 28, child: widget.suffix),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 28,
                maxWidth: 28,
              ),
              isCollapsed: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              border: InputBorder.none,
            ),
            onChanged: widget.onChanged,
            onSubmitted: _submit,
          ),
        ),
      ),
    );
  }

  Color _borderColor(TolyFormThemeData theme) {
    if (widget.errorText != null) return theme.errorColor;
    if (_focusNode.hasFocus) return theme.focusBorderColor;
    if (_hovered && widget.enabled) return theme.hoverBorderColor;
    return theme.borderColor;
  }

  Color _fillColor(TolyFormThemeData theme) {
    if (!widget.enabled) return theme.disabledFillColor;
    if (_focusNode.hasFocus) return theme.focusFillColor;
    if (_hovered) return theme.hoverFillColor;
    return theme.fillColor;
  }

  void _handlePointerEnter(PointerEnterEvent event) {
    if (widget.enabled) {
      _animateVisualChange = true;
      setState(() => _hovered = true);
    }
  }

  void _handlePointerExit(PointerExitEvent event) {
    if (_hovered) {
      _animateVisualChange = true;
      setState(() => _hovered = false);
    }
  }

  void _handleFocusChanged() {
    _animateVisualChange = false;
    if (_focusNode.hasFocus) {
      _focusOrigin = _controller.text;
      if (widget.selectAllOnFocus) {
        _controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _controller.text.length,
        );
      }
    } else {
      _submit(_controller.text);
    }
    setState(() {});
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.escape) {
      return KeyEventResult.ignored;
    }
    _controller.text = _focusOrigin;
    widget.onChanged?.call(_focusOrigin);
    _focusNode.unfocus();
    return KeyEventResult.handled;
  }

  void _submit(String value) {
    widget.onSubmitted?.call(value);
  }
}
