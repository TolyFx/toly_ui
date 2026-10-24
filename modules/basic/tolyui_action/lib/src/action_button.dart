import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

/// 通过状态底色反馈的桌面按钮，无水波纹和默认描边。
class TolyActionButton extends StatefulWidget {
  const TolyActionButton(
      {required this.child,
      required this.onPressed,
      this.tooltip,
      this.selected = false,
      this.height = 30,
      this.padding = const EdgeInsets.symmetric(horizontal: 10),
      this.foregroundColor,
      this.backgroundColor,
      this.hoverColor,
      this.selectedColor,
      this.autofocus = false,
      super.key});

  /// 图标、文字或自定义内容，继承按钮前景色。
  final Widget child;

  /// 空回调表示禁用。
  final VoidCallback? onPressed;

  /// 可选的悬停提示。
  final String? tooltip;

  /// 工具栏的持续选中状态。
  final bool selected;

  /// 适用于密集桌面工具栏的高度。
  final double height;

  /// 按钮内部留白。
  final EdgeInsetsGeometry padding;

  /// 默认文字和图标色。
  final Color? foregroundColor;

  /// 常态背景色，默认透明。
  final Color? backgroundColor;

  /// 悬停背景色。
  final Color? hoverColor;

  /// 激活状态背景色。
  final Color? selectedColor;

  /// 是否在出现时自动获取键盘焦点。
  final bool autofocus;

  @override
  State<TolyActionButton> createState() => _TolyActionButtonState();
}

class _TolyActionButtonState extends State<TolyActionButton> {
  /// 鼠标悬停状态。
  bool _hovered = false;

  /// 键盘导航产生的焦点强调。
  bool _focused = false;

  /// 按压状态在释放和取消时清理。
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null;

  /// 鼠标进入后保持悬停反馈，不受键盘高亮模式影响。
  void _enter(PointerEnterEvent event) => setState(() => _hovered = true);
  void _exit(PointerExitEvent event) => setState(() => _hovered = false);
  void _focus(bool value) => setState(() => _focused = value);
  void _press(TapDownDetails details) => setState(() => _pressed = true);
  void _release(TapUpDetails details) => _cancel();
  void _cancel() => setState(() => _pressed = false);

  Object? _activate(ActivateIntent intent) {
    widget.onPressed?.call();
    return null;
  }

  @override
  void didUpdateWidget(TolyActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_enabled) _pressed = false;
  }

  @override
  Widget build(BuildContext context) {
    final Color accent = Theme.of(context).colorScheme.primary;
    final Color foreground = widget.foregroundColor ??
        (widget.selected ? accent : const Color(0xFF515862));
    final Color base = widget.backgroundColor ?? Colors.transparent;
    final Color hover = widget.hoverColor ?? const Color(0xFFEEF0F3);
    final Color background = !_enabled
        ? base
        : widget.selected
            ? widget.selectedColor ?? accent.withValues(alpha: 0.10)
            : _pressed
                ? Color.alphaBlend(const Color(0x14000000), hover)
                : _hovered
                    ? hover
                    : base;
    Widget result = Semantics(
      button: true,
      enabled: _enabled,
      selected: widget.selected,
      onTap: widget.onPressed,
      child: FocusableActionDetector(
        enabled: _enabled,
        autofocus: widget.autofocus,
        mouseCursor:
            _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onShowFocusHighlight: _focus,
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _activate)
        },
        child: MouseRegion(
          onEnter: _enter,
          onExit: _exit,
          child: GestureDetector(
            excludeFromSemantics: true,
            behavior: HitTestBehavior.opaque,
            onTap: widget.onPressed,
            onTapDown: _enabled ? _press : null,
            onTapUp: _enabled ? _release : null,
            onTapCancel: _cancel,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              height: widget.height,
              padding: widget.padding,
              decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                      color: _focused && _enabled
                          ? accent.withValues(alpha: 0.5)
                          : Colors.transparent)),
              child: Center(
                  widthFactor: 1,
                  child: Opacity(
                      opacity: _enabled ? 1 : 0.36,
                      child: IconTheme(
                          data: IconThemeData(color: foreground, size: 15),
                          child: DefaultTextStyle(
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: foreground,
                                  fontFamily: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.fontFamily),
                              child: widget.child)))),
            ),
          ),
        ),
      ),
    );
    if (widget.tooltip != null) {
      result = Tooltip(
          message: widget.tooltip!,
          waitDuration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
              color: const Color(0xFF30343B),
              borderRadius: BorderRadius.circular(5)),
          child: result);
    }
    return result;
  }
}
