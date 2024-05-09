import 'package:flutter/material.dart';

import '../tolyui_feedback.dart';
import 'toly_popover.dart';

typedef TolyPopoverChildBuilder = Widget Function(
  BuildContext context,
  PopoverController controller,
  Widget? child,
);
typedef OverlayContentBuilder = Widget Function(
  BuildContext context,
  PopoverController controller,
);

typedef OverlayDecorationBuilder = Decoration Function(
  PopoverDecoration decoration,
);

typedef OffsetCalculator = Offset Function(Calculator calculator);

class Calculator {
  final Placement placement;
  final Size boxSize;
  final Size overlaySize;
  final double gap;

  Calculator({
    required this.placement,
    required this.boxSize,
    required this.overlaySize,
    required this.gap,
  });
}

class PopoverDecoration {
  final Placement placement;
  final Offset shift;
  final Size boxSize;

  PopoverDecoration({
    required this.placement,
    required this.shift,
    required this.boxSize,
  });
}
