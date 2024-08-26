import 'package:flutter/material.dart';

import 'slot.dart';

class SlotBuilder extends Slot {

  final SlotWidgetBuilder builder;

  SlotBuilder({
    required this.builder,
    super.onTap,
    super.padding = const EdgeInsets.symmetric(horizontal: 8),
    super.backgroundColor = const Color(0xfffafafa),
  });

  bool get enableHover => onTap != null;

  @override
  Widget build(BuildContext context, SlotMeta meta) {
    return SlotDecoration(
      slot: this,
      height: meta.height,
      unFocusedColor: meta.unFocusedColor,
      slotType: meta.slotType,
    );
  }
}

class SlotDecoration extends StatefulWidget {
  final SlotBuilder slot;
  final double height;
  final Color unFocusedColor;
  final SlotType slotType;

  const SlotDecoration({
    super.key,
    required this.slot,
    required this.height,
    required this.unFocusedColor,
    required this.slotType,
  });

  @override
  State<SlotDecoration> createState() => _SlotDecorationState();
}

class _SlotDecorationState extends State<SlotDecoration> {
  bool _hover = false;

  Border get border {
    if (_hover) {
      return Border.all(color: Colors.blue, width: 1);
    }
    BorderSide side = BorderSide(color: widget.unFocusedColor);
    return switch (widget.slotType) {
      SlotType.leading => Border(top: side, left: side, bottom: side),
      SlotType.tailing => Border(top: side, right: side, bottom: side),
    };
  }

  BorderRadius get borderRadius {
    return switch (widget.slotType) {
      SlotType.leading => const BorderRadius.only(
          topLeft: Radius.circular(4),
          bottomLeft: Radius.circular(4),
        ),
      SlotType.tailing => const BorderRadius.only(
          topRight: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      padding: widget.slot.padding,
      decoration: BoxDecoration(
        color: widget.slot.backgroundColor,
        borderRadius: borderRadius,
        border: border,
      ),
      child: Center(child: widget.slot.builder(context, _hover)),
    );

    if (!widget.slot.enableHover) return child;

    return GestureDetector(
      onTap: widget.slot.onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() {
            _hover = true;
          });
        },
        onExit: (_) {
          setState(() {
            _hover = false;
          });
        },
        child: child,
      ),
    );
  }
}
