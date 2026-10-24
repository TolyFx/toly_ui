import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 类型动作组件内部使用的鼠标、焦点与键盘操作区。
class TypeActionTarget extends StatefulWidget {
  /// 当前操作是否允许执行。
  final bool enabled;

  /// 无障碍操作名称，不自动显示悬浮提示。
  final String label;

  /// 主色交互反馈。
  final Color accent;

  /// 触发当前区域的操作。
  final VoidCallback onPressed;

  /// 当前区域展示内容。
  final Widget child;

  const TypeActionTarget({
    super.key,
    required this.enabled,
    required this.label,
    required this.accent,
    required this.onPressed,
    required this.child,
  });

  @override
  State<TypeActionTarget> createState() => _TypeActionTargetState();
}

class _TypeActionTargetState extends State<TypeActionTarget> {
  /// 鼠标是否在操作区内。
  bool _hovered = false;

  /// 是否显示键盘焦点反馈。
  bool _focused = false;

  void _hoverChanged(bool hovered) => setState(() => _hovered = hovered);
  void _focusChanged(bool focused) => setState(() => _focused = focused);

  Object? _activate(ActivateIntent intent) {
    if (widget.enabled) widget.onPressed();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Color foreground = widget.enabled
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(context).disabledColor;
    return FocusableActionDetector(
      enabled: widget.enabled,
      mouseCursor:
          widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onShowFocusHighlight: _focusChanged,
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: _activate),
      },
      child: MouseRegion(
        onEnter: (PointerEnterEvent event) => _hoverChanged(true),
        onExit: (PointerExitEvent event) => _hoverChanged(false),
        child: Semantics(
          button: true,
          enabled: widget.enabled,
          label: widget.label,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.enabled ? widget.onPressed : null,
            child: ColoredBox(
              color: widget.enabled && (_hovered || _focused)
                  ? widget.accent.withValues(alpha: _focused ? 0.10 : 0.06)
                  : Colors.transparent,
              child: IconTheme.merge(
                data: IconThemeData(size: 14, color: foreground),
                child: DefaultTextStyle.merge(
                  style: TextStyle(color: foreground),
                  child: Center(child: widget.child),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
