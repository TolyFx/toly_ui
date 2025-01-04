import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DashOutlineShapeBorder extends OutlinedBorder {
  const DashOutlineShapeBorder({
    super.side,
    this.borderRadius = BorderRadius.zero,
    required this.step,
    required this.span,
  });

  /// The radii for each corner.
  final BorderRadiusGeometry borderRadius;
  final double step;
  final double span;

  @override
  ShapeBorder scale(double t) {
    return DashOutlineShapeBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
      step: step * t,
      span: span * t,
    );
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is DashOutlineShapeBorder) {
      return DashOutlineShapeBorder(
        side: BorderSide.lerp(a.side, side, t),
        borderRadius: BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
        step: lerpDouble(a.step, step, t) ?? 0,
        span: lerpDouble(a.span, span, t) ?? 0,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is DashOutlineShapeBorder) {
      return DashOutlineShapeBorder(
        side: BorderSide.lerp(side, b.side, t),
        borderRadius: BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
        step: lerpDouble(step, b.step, t) ?? 0,
        span: lerpDouble(span, b.span, t) ?? 0,
      );
    }
    return super.lerpTo(b, t);
  }

  /// Returns a copy of this RoundedRectangleBorder with the given fields
  /// replaced with the new values.
  @override
  DashOutlineShapeBorder copyWith(
      {BorderSide? side, BorderRadiusGeometry? borderRadius, double? step, double? span}) {
    return DashOutlineShapeBorder(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
      step: step ?? this.step,
      span: span ?? this.span,

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
  void paintInterior(Canvas canvas, Rect rect, Paint paint, {TextDirection? textDirection}) {
    if (borderRadius == BorderRadius.zero) {
      canvas.drawRect(rect, paint);
    } else {
      canvas.drawRRect(borderRadius.resolve(textDirection).toRRect(rect), paint);
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

    DashPainter(step: step, span: span).paint(canvas, path, paint);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is DashOutlineShapeBorder &&
        other.side == side &&
        other.borderRadius == borderRadius &&
        other.step == step;
  }

  @override
  int get hashCode => Object.hash(side, borderRadius, step);

  @override
  String toString() {
    return '${objectRuntimeType(this, 'DashOutlineShapeBorder')}($side, $borderRadius)';
  }
}

// [step] the length of solid line 每段实线长
// [span] the space of each solid line  每段空格线长
class DashPainter {
  const DashPainter({
    this.step = 2,
    this.span = 2,
  });

  final double step;
  final double span;

  void paint(Canvas canvas, Path path, Paint paint) {
    final PathMetrics pms = path.computeMetrics();
    final double partLength = step + span;

    for (PathMetric pm in pms) {
      final int count = pm.length ~/ partLength;
      for (int i = 0; i < count; i++) {
        canvas.drawPath(
          pm.extractPath(partLength * i, partLength * i + step),
          paint,
        );
      }
      final double tail = pm.length % partLength;
      canvas.drawPath(pm.extractPath(pm.length - tail, pm.length), paint);
    }
  }
}
