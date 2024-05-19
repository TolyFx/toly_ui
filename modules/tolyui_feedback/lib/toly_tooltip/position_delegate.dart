import 'dart:async';
import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:tolyui_feedback/toly_tooltip/tooltip_placement.dart';

import '../toly_popover/callback.dart';
import '../toly_popover/toly_popover.dart';

/// A delegate for computing the layout of a tooltip to be displayed above or
/// below a target specified in the global coordinate system.
class PopoverPositionDelegate extends SingleChildLayoutDelegate {
  /// Creates a delegate for computing the layout of a tooltip.
  PopoverPositionDelegate({
    required this.target,
    required this.boxSize,
    this.offsetCalculator,
    this.onSizeFind,
    required this.gap,
    required this.placement,
    required this.onPlacementShift,
  });

  /// The offset of the target the tooltip is positioned near in the global
  /// coordinate system.
  final Offset target;
  final Placement placement;
  final OffsetCalculator? offsetCalculator;

  final ValueChanged<PlacementShift> onPlacementShift;
  final ValueChanged<Size>? onSizeFind;
  final Size boxSize;

  /// The amount of vertical distance between the target and the displayed
  /// tooltip.
  final double gap;
  @override
  Size getSize(BoxConstraints constraints) => constraints.biggest;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  Placement shiftPlacement(
    bool outTop,
    bool outBottom,
    bool outLeft,
    bool outRight,
  ) {
    Placement effectPlacement = placement;

    Placement shiftToVertical() {
      if (outTop) return Placement.bottom;
      return Placement.top;
    }

    if (outLeft && outRight) {
      return shiftToVertical();
    }

    /// TODO: ::边界响应策略:: 可以将转换策略作为函数参数，使用者来自定义。
    // if(placement.isHorizontal&&(outTop||outBottom)){
    //   return shiftToVertical();
    // }
    switch (placement) {
      case Placement.left:
        if (outLeft) return Placement.right;
        if (outBottom) return Placement.leftEnd;
        if (outTop) return Placement.leftStart;
        break;
      case Placement.leftStart:
        if (outBottom) return Placement.leftEnd;
        if (outLeft) return Placement.rightStart;
        break;
      case Placement.leftEnd:
        if (outTop) return Placement.leftStart;
        if (outLeft) return Placement.rightEnd;
        break;
      case Placement.right:
        if (outRight) return Placement.left;
        if (outBottom) return Placement.rightEnd;
        if (outTop) return Placement.rightStart;

        break;
      case Placement.rightStart:
        if (outBottom) return Placement.rightEnd;
        if (outRight) return Placement.leftStart;
        break;
      case Placement.rightEnd:
        if (outBottom) return Placement.rightStart;
        if (outRight) return Placement.leftEnd;
        break;
      default:
        if (outBottom && placement.isBottom || outTop && placement.isTop) {
          return placement.shift;
        }
    }
    return effectPlacement;
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // onSizeFind?.call(childSize);
    if(onSizeFind!=null){
      scheduleMicrotask(() {
        onSizeFind!(childSize);
      });
    }

    bool outBottom =
        target.dy > size.height - (childSize.height + boxSize.height / 2 + gap);
    bool outTop = target.dy < childSize.height + boxSize.height / 2;
    bool outLeft = target.dx < childSize.width + boxSize.width / 2 + gap;
    bool outRight =
        target.dx > size.width - (childSize.width + boxSize.width / 2 + gap);

    Placement effectPlacement =
        shiftPlacement(outTop, outBottom, outLeft, outRight);

    Offset center =
        target.translate(-childSize.width / 2, -childSize.height / 2);
    double halfWidth = (childSize.width - boxSize.width) / 2;
    double halfLeftWidth = (childSize.width + boxSize.width) / 2 + gap;
    double halfHeight = (childSize.height - boxSize.height) / 2;

    double verticalHeight = (childSize.height + boxSize.height) / 2 + gap;

    Offset translation = switch (effectPlacement) {
      Placement.top => Offset(0, -verticalHeight),
      Placement.topStart => Offset(halfWidth, -verticalHeight),
      Placement.topEnd => Offset(-halfWidth, -verticalHeight),
      Placement.bottom => Offset(0, verticalHeight),
      Placement.bottomStart => Offset(halfWidth, verticalHeight),
      Placement.bottomEnd => Offset(-halfWidth, verticalHeight),
      Placement.left => Offset(-halfLeftWidth, 0),
      Placement.leftStart => Offset(-halfLeftWidth, halfHeight),
      Placement.leftEnd => Offset(-halfLeftWidth, -halfHeight),
      Placement.right => Offset(halfLeftWidth, 0),
      Placement.rightStart => Offset(halfLeftWidth, halfHeight),
      Placement.rightEnd => Offset(halfLeftWidth, -halfHeight),
    };
    Offset result = center + translation;

    double dx = 0;
    double endEdgeDx = result.dx + childSize.width - size.width;
    if (endEdgeDx > 0) {
      result = result.translate(-endEdgeDx, 0);
      dx = -endEdgeDx;
    }
    double startEdgeDy = result.dx;
    if (startEdgeDy < 0) {
      result = result.translate(-startEdgeDy, 0);
      dx = -startEdgeDy;
    }

    if (offsetCalculator != null) {
      // effectPlacement,boxSize,childSize,gap
      result += offsetCalculator!(Calculator(
          placement: effectPlacement,
          boxSize: boxSize,
          overlaySize: childSize,
          gap: gap));
    }

    if (effectPlacement != placement || dx != 0) {
      scheduleMicrotask(() {
        onPlacementShift(PlacementShift(effectPlacement, dx));
      });
    }

    return result;
  }

  @override
  bool shouldRelayout(PopoverPositionDelegate oldDelegate) {
    return target != oldDelegate.target ||
        gap != oldDelegate.gap ||
        placement != oldDelegate.placement ||
        boxSize != oldDelegate.boxSize;
  }
}
