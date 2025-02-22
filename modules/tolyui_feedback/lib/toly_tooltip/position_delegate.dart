import 'dart:async';
import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:tolyui_feedback/toly_tooltip/tooltip_placement.dart';

import '../toly_popover/model/callback.dart';
import '../toly_popover/logic/placement_handler.dart';
import 'algorithm.dart';

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
    this.overflowAlgorithm,
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
  final OverflowAlgorithm? overflowAlgorithm;

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

  /// [areaSize] 容器尺寸
  /// [overlaySize] 浮层尺寸
  /// [boxSize] 目标组件尺寸
  /// [position] 目标组件中心的坐标
  @override
  Offset getPositionForChild(Size areaSize, Size overlaySize) {
    // print("===${areaSize}=====${overlaySize}===${boxSize}==${position}===");

    if (onSizeFind != null) {
      scheduleMicrotask(() {
        onSizeFind!(overlaySize);
      });
    }
    if (clickPosition != null) {
      return clickOffset(overlaySize.height, areaSize.height);
    }

    /// 计算溢出情况
    double y = position.dy;
    double x = position.dx;
    double capacityH = overlaySize.height + boxSize.height / 2 + gap;
    double capacityW = overlaySize.width + boxSize.width / 2 + gap;

    final OverflowEdge edge = OverflowEdge(
      left: x - capacityW < 0,
      top: y - capacityH < 0,
      right: x + capacityW > areaSize.width,
      bottom: y + capacityH > areaSize.height,
    );
    OverflowAlgorithm? algo = overflowAlgorithm ?? defaultOverflowAlgorithm;
    Placement effectPlacement = algo(edge, placement);

    if (edge.overflowAll) {
      return Offset(
        areaSize.width / 2 - overlaySize.width / 2,
        areaSize.height / 2 - overlaySize.height / 2,
      );
    }

    Offset center =
    position.translate(-overlaySize.width / 2, -overlaySize.height / 2);

    double halfWidth = (overlaySize.width - boxSize.width) / 2;
    double halfLeftWidth = (overlaySize.width + boxSize.width) / 2 + gap;
    double halfHeight = (overlaySize.height - boxSize.height) / 2;

    double verticalHeight = (overlaySize.height + boxSize.height) / 2 + gap;

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
    double endEdgeDx = result.dx + overlaySize.width - areaSize.width;
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
      result += offsetCalculator!(Calculator(
          placement: effectPlacement,
          boxSize: boxSize,
          overlaySize: overlaySize,
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

}

