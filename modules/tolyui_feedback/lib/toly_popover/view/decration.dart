
import 'package:flutter/material.dart';

import '../../decoration/bubble_decoration.dart';
import '../../toly_tooltip/toly_tooltip.dart';
import '../model/callback.dart';

Decoration defaultDecorationBuilder(PopoverDecoration decoration) {
  bool isDark = decoration.darkTheme;
  Color backgroundColor = isDark ? const Color(0xff303133) : Colors.white;
  Color borderColor = isDark ? const Color(0xff414243) : const Color(0xffe4e7ed);
  DecorationConfig config = decoration.config ??
      DecorationConfig(backgroundColor: backgroundColor, style: PaintingStyle.stroke, shadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(0, 2),
          blurRadius: 6,
          spreadRadius: 0,
        )
      ]);
  if (!config.isBubble) {
    return BoxDecoration(
      color: config.backgroundColor,
      boxShadow: [
        BoxShadow(
          color: borderColor,
          offset: Offset.zero,
          blurRadius: 0,
          spreadRadius: 0.5,
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(0, 2),
          blurRadius: 6,
          spreadRadius: 0,
        )
      ],
      borderRadius: BorderRadius.all(config.radius),
    );
  }
  return BubbleDecoration(
    shiftX: decoration.shift.dx,
    radius: config.radius,
    shadows: config.shadows,
    boxSize: decoration.boxSize,
    placement: decoration.placement,
    color: config.backgroundColor,
    style: config.style,
    bubbleMeta: config.bubbleMeta,
    borderColor: borderColor,
  );
}
