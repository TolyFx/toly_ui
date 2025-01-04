import 'dart:async';
import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:tolyui_feedback/toly_tooltip/tooltip_placement.dart';

import '../toly_popover/model/callback.dart';
import '../toly_popover/logic/placement_handler.dart';

/// A delegate for computing the layout of a tooltip to be displayed above or
/// below a target specified in the global coordinate system.
class PopoverPositionDelegate extends SingleChildLayoutDelegate {
  /// Creates a delegate for computing the layout of a tooltip.
  PopoverPositionDelegate({
    required this.position,
    required this.boxSize,
    required this.clickPosition,
    this.offsetCalculator,
    this.onSizeFind,
    required this.gap,
    required this.margin,
    required this.placement,
    required this.onPlacementShift,
  });

  /// The offset of the target the tooltip is positioned near in the global
  /// coordinate system.
  final Offset position;
  final Placement placement;
  final OffsetCalculator? offsetCalculator;
  final Offset? clickPosition;
  final EdgeInsets? margin;

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
        if (outTop) return Placement.rightStart;
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
    // print("===${size}=====${childSize}===${boxSize}==${position}===");

    // return handleOffset(size, childSize);
    // onSizeFind?.call(childSize);
    if (onSizeFind != null) {
      scheduleMicrotask(() {
        onSizeFind!(childSize);
      });
    }
    if (clickPosition != null) {
      return clickOffset(childSize.height, size.height);
    }

    bool outBottom = position.dy >
        size.height - (childSize.height + boxSize.height / 2 + gap);
    bool outTop = position.dy < childSize.height + boxSize.height / 2;
    bool outLeft = position.dx < childSize.width + boxSize.width / 2 + gap;
    bool outRight =
        position.dx > size.width - (childSize.width + boxSize.width / 2 + gap);

    Placement effectPlacement =
        shiftPlacement(outTop, outBottom, outLeft, outRight);

    OverflowMap overflowMap =
        _calcEdgeOverflow(size, boxSize, childSize, position);

    Offset center =
        position.translate(-childSize.width / 2, -childSize.height / 2);

    if (overflowMap[Placement.overflow] == true) {
      return Offset(size.width / 2 - childSize.width / 2,
          size.height / 2 - childSize.height / 2);
    }

    if (placement.isTop && overflowMap[Placement.top] == true) {
      /// 上边界溢出
      effectPlacement = placement.shift;
    }

    if (placement.isBottom && overflowMap[Placement.bottom] == true) {
      /// 上边界溢出
      effectPlacement = placement.shift;
    }

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
      Placement.overflow => Offset.zero,
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
    return position != oldDelegate.position ||
        gap != oldDelegate.gap ||
        placement != oldDelegate.placement ||
        boxSize != oldDelegate.boxSize;
  }

  Offset clickOffset(double childHeight, double areaHeight) {
    Offset offset = clickPosition!.translate(
        position.dx - boxSize.width / 2, position.dy - boxSize.height / 2);

    /// 底部边界检测
    double bottom = offset.dy + childHeight - (areaHeight - gap);
    if (bottom > 0) {
      offset = offset.translate(0, -bottom);
    }
    return offset;
  }

  /// 检测边界溢出
  /// [area] 区域尺寸
  /// [target] 目标尺寸
  /// [center] 目标的中心坐标
  /// [overlay] 浮层尺寸
  OverflowMap _calcEdgeOverflow(
    Size area,
    Size target,
    Size overlay,
    Offset center,
  ) {
    double marginTop = margin?.top ?? 0;
    double marginBottom = margin?.bottom ?? 0;
    double overflowTop =
        target.height / 2 + overlay.height + gap + marginTop - position.dy;
    double overflowBottom = position.dy -
        (area.height -
            (target.height / 2 + overlay.height + gap + marginBottom));

    if (overflowTop > 0 && overflowBottom > 0) {
      return {Placement.overflow: true};
    }

    return {
      Placement.top: overflowTop > 0,
      Placement.bottom: overflowBottom > 0,
    };
  }
}

typedef OverflowMap = Map<Placement, bool>;
