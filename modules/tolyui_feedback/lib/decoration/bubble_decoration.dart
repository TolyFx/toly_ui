import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tolyui_feedback/toly_tooltip/tooltip_placement.dart';

class BubbleMeta {
  final double spineHeight;
  final double angle;

  const BubbleMeta({this.spineHeight = 8, this.angle = 70});
}

class BubbleDecoration extends Decoration {
  final Color? color;
  final Color borderColor;
  final Size boxSize;
  final double shiftX;
  final Placement placement;
  final List<BoxShadow>? shadows;
  final Radius radius;
  final PaintingStyle style;
  final BubbleMeta bubbleMeta;

  const BubbleDecoration({
    this.color,
    required this.boxSize,
    required this.placement,
    this.shadows,
    required this.borderColor,
    required this.shiftX,
    required this.style,
    required this.radius,
    required this.bubbleMeta,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return BubbleBoxPainter(this);
  }
}

class BubbleBoxPainter extends BoxPainter {
  final BubbleDecoration decoration;

  BubbleBoxPainter(this.decoration);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Size? size = configuration.size;
    if (size == null) return;
    Paint paint = Paint()..color = decoration.color ?? Colors.black;
    Path path = buildPath(
        offset.translate(-decoration.shiftX, 0), size.width, size.height);
    path = Path.combine(
        PathOperation.union,
        path,
        Path()
          ..addRRect(
              RRect.fromRectAndRadius(offset & size, decoration.radius)));
    canvas.drawPath(
        path,
        Paint()
          ..style
          ..color = decoration.color ?? Colors.black);
    if (decoration.style == PaintingStyle.stroke) {
      canvas.drawPath(
          path,
          paint
            ..style = PaintingStyle.stroke
            ..color = decoration.borderColor);
    }
    if (decoration.shadows != null && decoration.shadows!.isNotEmpty) {
      drawShadows(canvas, path, decoration.shadows!);
    }
    // canvas.drawRect(offset&size, Paint());
  }

  void drawShadows(Canvas canvas, Path path, List<BoxShadow> shadows) {
    for (final BoxShadow shadow in shadows) {
      final Paint shadowPainter = shadow.toPaint();
      if (shadow.spreadRadius == 0) {
        canvas.drawPath(path.shift(shadow.offset), shadowPainter);
      } else {
        Rect zone = path.getBounds();
        double xScale = (zone.width + shadow.spreadRadius) / zone.width;
        double yScale = (zone.height + shadow.spreadRadius) / zone.height;
        Matrix4 m4 = Matrix4.identity();
        m4.translate(zone.width / 2, zone.height / 2);
        m4.scale(xScale, yScale);
        m4.translate(-zone.width / 2, -zone.height / 2);
        canvas.drawPath(
            path.shift(shadow.offset).transform(m4.storage), shadowPainter);
      }
    }
    Paint whitePaint = Paint()..color = decoration.color ?? Colors.black;
    canvas.drawPath(path, whitePaint);
  }

  Path buildPath(Offset offset, double width, double height) {
    var angleRad = pi / 180 * decoration.bubbleMeta.angle;
    double spineHeight = decoration.bubbleMeta.spineHeight;
    var spineMoveX = spineHeight * tan(angleRad / 2);

    double xb = (width - decoration.boxSize.width) / 2 +
        decoration.boxSize.width / 2 -
        spineMoveX;

    double xbs = decoration.boxSize.width / 2;
    double xbe = width - decoration.boxSize.width / 2 - spineMoveX;

    Offset translation = switch (decoration.placement) {
      Placement.top => Offset(xb, 0),
      Placement.topStart => Offset(xbs, 0),
      Placement.topEnd => Offset(xbe, 0),
      Placement.bottom => Offset(xb, 0),
      Placement.bottomStart => Offset(xbs, 0),
      Placement.bottomEnd => Offset(xbe, 0),
      Placement.left => Offset(
          0,
          (height - decoration.boxSize.height) / 2 +
              decoration.boxSize.height / 2 -
              spineMoveX),
      Placement.leftStart =>
        Offset(0, decoration.boxSize.height / 2 - spineMoveX),
      Placement.leftEnd =>
        Offset(0, height - decoration.boxSize.height / 2 - spineMoveX),
      Placement.right => Offset(
          0,
          (height - decoration.boxSize.height) / 2 +
              decoration.boxSize.height / 2 -
              spineMoveX),
      Placement.rightStart =>
        Offset(0, decoration.boxSize.height / 2 - spineMoveX),
      Placement.rightEnd =>
        Offset(0, height - decoration.boxSize.height / 2 - spineMoveX),
    };

    var spineMoveY = spineHeight;
    if (spineHeight != 0) {
      if (decoration.placement == Placement.bottom ||
          decoration.placement == Placement.bottomStart ||
          decoration.placement == Placement.bottomEnd) {
        return Path()
          ..moveTo(offset.dx + translation.dx, offset.dy + translation.dy)
          ..relativeLineTo(spineMoveX, -spineMoveY)
          ..relativeLineTo(spineMoveX, spineMoveY);
      }
      if (decoration.placement == Placement.top ||
          decoration.placement == Placement.topStart ||
          decoration.placement == Placement.topEnd) {
        return Path()
          ..moveTo(
              offset.dx + translation.dx, offset.dy + translation.dy + height)
          ..relativeLineTo(spineMoveX, spineMoveY)
          ..relativeLineTo(spineMoveX, -spineMoveY);
      }
      if (decoration.placement == Placement.rightStart ||
          decoration.placement == Placement.right ||
          decoration.placement == Placement.rightEnd) {
        return Path()
          ..moveTo(offset.dx + translation.dx, offset.dy + translation.dy)
          ..relativeLineTo(-spineMoveY, spineMoveX)
          ..relativeLineTo(spineMoveY, spineMoveX);
      }
      if (decoration.placement == Placement.leftStart ||
          decoration.placement == Placement.left ||
          decoration.placement == Placement.leftEnd) {
        return Path()
          ..moveTo(
              offset.dx + translation.dx + width, offset.dy + translation.dy)
          ..relativeLineTo(spineMoveY, spineMoveX)
          ..relativeLineTo(-spineMoveY, spineMoveX);
      }
    }
    return Path();
  }
}
