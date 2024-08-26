import 'package:flutter/material.dart';

enum SlotType { leading, tailing }

typedef SlotWidgetBuilder = Widget Function(BuildContext context, bool hover);

class SlotMeta {
  final double height;
  final Color unFocusedColor;
  final SlotType slotType;
  final Radius radius;

  SlotMeta({
    required this.height,
    required this.unFocusedColor,
    required this.slotType,
    required this.radius,
  });


  BorderRadius get borderRadius {
    return switch (slotType) {
      SlotType.leading => BorderRadius.only(topLeft: radius, bottomLeft: radius),
      SlotType.tailing => BorderRadius.only(topRight: radius, bottomRight: radius),
    };
  }

}

abstract class Slot {
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;

  Slot({
    this.onTap,
    required this.padding,
    this.backgroundColor,
  });

  Widget build(BuildContext context, SlotMeta meta);

  BorderRadius borderRadius(SlotMeta meta) {
    Radius radius = meta.radius;
    return switch (meta.slotType) {
      SlotType.leading => BorderRadius.only(topLeft: radius, bottomLeft: radius),
      SlotType.tailing => BorderRadius.only(topRight: radius, bottomRight: radius),
    };
  }
}
