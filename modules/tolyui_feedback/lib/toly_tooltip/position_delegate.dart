import 'dart:async';
import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:tolyui_feedback/toly_tooltip/tooltip_placement.dart';

/// A delegate for computing the layout of a tooltip to be displayed above or
/// below a target specified in the global coordinate system.
class TolyTooltipPositionDelegate extends SingleChildLayoutDelegate {
  /// Creates a delegate for computing the layout of a tooltip.
  TolyTooltipPositionDelegate({
    required this.target,
    required this.boxSize,
    required this.gap,
    required this.placement,
    required this.onPlacementShift,
  });

  /// The offset of the target the tooltip is positioned near in the global
  /// coordinate system.
  final Offset target;
  final TooltipPlacement placement;
  final ValueChanged<PlacementShift> onPlacementShift;
  final Size boxSize;

  /// The amount of vertical distance between the target and the displayed
  /// tooltip.
  final double gap;


  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  TooltipPlacement shiftPlacement(
    bool outTop,
    bool outBottom,
    bool outLeft,
    bool outRight,
  ) {
    TooltipPlacement effectPlacement = placement;

    TooltipPlacement shiftToVertical(){
      if(outTop) return TooltipPlacement.bottom;
      return TooltipPlacement.top;
    }

    if (outLeft && outRight) {
      return shiftToVertical();
    }
    /// TODO: ::边界响应策略:: 可以将转换策略作为函数参数，使用者来自定义。
    // if(placement.isHorizontal&&(outTop||outBottom)){
    //   return shiftToVertical();
    // }
    switch(placement){
      case TooltipPlacement.left:
        if(outLeft) return TooltipPlacement.right;
        if(outBottom) return TooltipPlacement.leftEnd;
        if(outTop) return TooltipPlacement.leftStart;
        break;
      case TooltipPlacement.leftStart:
        if(outBottom) return TooltipPlacement.leftEnd;
        if(outLeft) return TooltipPlacement.rightStart;
        break;
      case TooltipPlacement.leftEnd:
        if(outTop) return TooltipPlacement.leftStart;
        if(outLeft) return TooltipPlacement.rightEnd;
        break;
      case TooltipPlacement.right:
        if(outRight) return TooltipPlacement.left;
        if(outBottom) return TooltipPlacement.rightEnd;
        if(outTop) return TooltipPlacement.rightStart;

        break;
      case TooltipPlacement.rightStart:
        if(outBottom) return TooltipPlacement.rightEnd;
        if(outRight) return TooltipPlacement.leftStart;
        break;
      case TooltipPlacement.rightEnd:
        if(outBottom) return TooltipPlacement.rightStart;
        if(outRight) return TooltipPlacement.leftEnd;
        break;
      default:
        if (outBottom && placement.isBottom ||
            outTop && placement.isTop) {
          return placement.shift;
        }
    }
    return effectPlacement;
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    bool outBottom =
        target.dy > size.height - (childSize.height + boxSize.height / 2 + gap);
    bool outTop = target.dy < childSize.height + boxSize.height / 2;
    bool outLeft = target.dx < childSize.width + boxSize.width / 2 + gap;
    bool outRight =
        target.dx > size.width - (childSize.width + boxSize.width / 2 + gap);

    TooltipPlacement effectPlacement =
        shiftPlacement(outTop, outBottom, outLeft, outRight);

    Offset center =
        target.translate(-childSize.width / 2, -childSize.height / 2);
    double halfWidth = (childSize.width - boxSize.width) / 2;
    double halfLeftWidth = (childSize.width + boxSize.width) / 2 + gap;
    double halfHeight = (childSize.height - boxSize.height) / 2;

    double verticalHeight = (childSize.height + boxSize.height) / 2 + gap;

    Offset translation = switch (effectPlacement) {
      TooltipPlacement.top => Offset(0, -verticalHeight),
      TooltipPlacement.topStart => Offset(halfWidth, -verticalHeight),
      TooltipPlacement.topEnd => Offset(-halfWidth, -verticalHeight),
      TooltipPlacement.bottom => Offset(0, verticalHeight),
      TooltipPlacement.bottomStart => Offset(halfWidth, verticalHeight),
      TooltipPlacement.bottomEnd => Offset(-halfWidth, verticalHeight),
      TooltipPlacement.left => Offset(-halfLeftWidth, 0),
      TooltipPlacement.leftStart => Offset(-halfLeftWidth, halfHeight),
      TooltipPlacement.leftEnd => Offset(-halfLeftWidth, -halfHeight),
      TooltipPlacement.right => Offset(halfLeftWidth, 0),
      TooltipPlacement.rightStart => Offset(halfLeftWidth, halfHeight),
      TooltipPlacement.rightEnd => Offset(halfLeftWidth, -halfHeight),
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

    if (effectPlacement != placement || dx != 0) {
      scheduleMicrotask(() {
        onPlacementShift(PlacementShift(effectPlacement, dx));
      });
    }

    return result;
  }

  @override
  bool shouldRelayout(TolyTooltipPositionDelegate oldDelegate) {
    return target != oldDelegate.target ||
        gap != oldDelegate.gap ||
        placement != oldDelegate.placement ||
        boxSize != oldDelegate.boxSize;
  }
}
