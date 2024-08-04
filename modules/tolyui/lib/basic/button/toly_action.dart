import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

class TolyAction extends StatefulWidget {
  final Widget child;
  final String? tooltip;
  final VoidCallback? onTap;
  final bool selected;
  final Placement toolTipPlacement;
  final ActionStyle? style;

  const TolyAction({
    super.key,
    required this.child,
    this.selected = false,
    this.tooltip,
    this.style,
    this.toolTipPlacement = Placement.bottom,
    required this.onTap,
  });

  @override
  State<TolyAction> createState() => _TolyActionState();
}

class _TolyActionState extends State<TolyAction> with HoverActionMix {
  late ActionStyle effectStyle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateEffectStyle();
  }

  void updateEffectStyle(){
    effectStyle =
        widget.style ?? (context.isDark ? const ActionStyle.dark() : const ActionStyle.light());
  }

  @override
  void didUpdateWidget(TolyAction oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.style!=widget.style){
      updateEffectStyle();
    }
  }

  bool get enable => widget.onTap != null;

  Color? get backgroundColor {
    if (widget.selected) {
      return effectStyle.selectColor;
    }
    if (hovered) {
      return effectStyle.backgroundColor;
    }
    return null;
  }

  Border? get border {
    if (hovered || widget.selected) {
      return effectStyle.border;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;
    child = GestureDetector(
      onTap: !enable ? null : widget.onTap,
      child: Container(
        padding: effectStyle.padding,
        decoration: BoxDecoration(
          borderRadius: effectStyle.borderRadius,
          color: backgroundColor,
          border: border ?? Border.all(color: Colors.transparent),
        ),
        child: child,
      ),
    );
    if (widget.tooltip != null && enable) {
      child = TolyTooltip(
        message: widget.tooltip,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        gap: 12,
        placement: widget.toolTipPlacement,
        decorationConfig: DecorationConfig(
          backgroundColor: context.isDark ? Colors.white : Colors.black,
          bubbleMeta: const BubbleMeta(spineHeight: 6, angle: 80),
        ),
        child: child,
      );
    }

    if (!enable) {
      child = IconTheme(
        data: IconThemeData(color: effectStyle.disableColor),
        child: child,
      );
    }

    return wrap(
      cursor: enable ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      child,
    );
  }
}

class ActionStyle {
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? disableColor;
  final Color? selectColor;
  final BorderRadius? borderRadius;
  final Border? border;

  const ActionStyle({
    this.padding,
    this.backgroundColor,
    this.disableColor,
    this.selectColor,
    this.borderRadius,
    this.border,
  });

  const ActionStyle.light({
    this.padding = const EdgeInsets.all(4),
    this.backgroundColor = const Color(0xffeff3f6),
    this.disableColor = Colors.grey,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.border,
    this.selectColor = const Color(0xffeff3f6),
  });

  const ActionStyle.dark({
    this.padding = const EdgeInsets.all(4),
    this.backgroundColor = const Color(0xff3f4042),
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.border,
    this.disableColor = Colors.grey,
    this.selectColor = const Color(0xff3f4042),
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActionStyle &&
          runtimeType == other.runtimeType &&
          padding == other.padding &&
          backgroundColor == other.backgroundColor &&
          disableColor == other.disableColor &&
          selectColor == other.selectColor &&
          borderRadius == other.borderRadius &&
          border == other.border;

  @override
  int get hashCode =>
      padding.hashCode ^
      backgroundColor.hashCode ^
      disableColor.hashCode ^
      selectColor.hashCode ^
      borderRadius.hashCode ^
      border.hashCode;
}
