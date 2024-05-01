import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DashOutlineShapeBorder extends OutlinedBorder {
  const DashOutlineShapeBorder({
    super.side,
    this.borderRadius = BorderRadius.zero,
    required this.dashGap,
  });

  /// The radii for each corner.
  final BorderRadiusGeometry borderRadius;
  final double dashGap;

  @override
  ShapeBorder scale(double t) {
    return DashOutlineShapeBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
      dashGap: dashGap * t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is DashOutlineShapeBorder) {
      return DashOutlineShapeBorder(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius:
        BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
        dashGap: lerpDouble(a.dashGap, dashGap, t) ?? 0,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is DashOutlineShapeBorder) {
      return DashOutlineShapeBorder(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius:
        BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
        dashGap: lerpDouble(dashGap, b.dashGap, t) ?? 0,
      );
    }
    return super.lerpTo(b, t);
  }

  /// Returns a copy of this RoundedRectangleBorder with the given fields
  /// replaced with the new values.
  @override
  DashOutlineShapeBorder copyWith(
      {BorderSide? side, BorderRadiusGeometry? borderRadius, double? dashGap}) {
    return DashOutlineShapeBorder(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
      dashGap: dashGap ?? this.dashGap,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final RRect borderRect = borderRadius.resolve(textDirection).toRRect(rect);
    final RRect adjustedRect = borderRect.deflate(side.strokeInset);
    return Path()..addRRect(adjustedRect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  void paintInterior(Canvas canvas, Rect rect, Paint paint,
      {TextDirection? textDirection}) {
    if (borderRadius == BorderRadius.zero) {
      canvas.drawRect(rect, paint);
    } else {
      canvas.drawRRect(
          borderRadius.resolve(textDirection).toRRect(rect), paint);
    }
  }

  @override
  bool get preferPaintInterior => true;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = side.width
      ..color = side.color;
    Path path = getOuterPath(rect);

    const DashPainter(step: 2).paint(canvas, path, paint);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is DashOutlineShapeBorder &&
        other.side == side &&
        other.borderRadius == borderRadius &&
        other.dashGap == dashGap;
  }

  @override
  int get hashCode => Object.hash(side, borderRadius,dashGap);

  @override
  String toString() {
    return '${objectRuntimeType(this, 'DashOutlineShapeBorder')}($side, $borderRadius)';
  }
}

// [step] the length of solid line 每段实线长
// [span] the space of each solid line  每段空格线长
// [pointCount] the point count of dash line  点划线的点数
// [pointWidth] the point width of dash line  点划线的点划长

class DashPainter {
  const DashPainter({
    this.step = 2,
    this.span = 2,
    this.pointCount = 0,
    this.pointWidth,
  });

  final double step;
  final double span;
  final int pointCount;
  final double? pointWidth;

  void paint(Canvas canvas, Path path, Paint paint) {
    final PathMetrics pms = path.computeMetrics();
    final double pointLineLength = pointWidth ?? paint.strokeWidth;
    final double partLength =
        step + span * (pointCount + 1) + pointCount * pointLineLength;

    pms.forEach((PathMetric pm) {
      final int count = pm.length ~/ partLength;
      for (int i = 0; i < count; i++) {
        canvas.drawPath(
          pm.extractPath(partLength * i, partLength * i + step),
          paint,
        );
        for (int j = 1; j <= pointCount; j++) {
          final start =
              partLength * i + step + span * j + pointLineLength * (j - 1);
          canvas.drawPath(
            pm.extractPath(start, start + pointLineLength),
            paint,
          );
        }
      }
      final double tail = pm.length % partLength;
      canvas.drawPath(pm.extractPath(pm.length - tail, pm.length), paint);
    });
  }
}
