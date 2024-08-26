import 'package:flutter/material.dart';
import 'slot.dart';

class ButtonSlot extends Slot {
  final Widget child;

  ButtonSlot({
    required this.child,
    super.onTap,
    super.padding = const EdgeInsets.symmetric(horizontal: 8),
  });

  @override
  Widget build(BuildContext context, SlotMeta meta) {
    return  ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: padding,
            shadowColor: Colors.transparent,
            minimumSize: Size(32, meta.height),
            shape: RoundedRectangleBorder(borderRadius: meta.borderRadius)),
        onPressed: onTap,
        child: child,
    );
  }
}
