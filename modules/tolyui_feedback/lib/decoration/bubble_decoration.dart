import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tolyui_feedback/toly_tooltip/tooltip_placement.dart';

class BubbleDecoration extends Decoration {
  final Color? color;
  final Size boxSize;
  final double shiftX;
  final TooltipPlacement placement;
  final PaintingStyle style;

  const BubbleDecoration({
    this.color,
    required this.boxSize,
    required this.placement,
    required this.shiftX,
    required this.style,
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
    Paint paint = Paint()
      ..color = decoration.color ?? Colors.black;
    Path path = _drawTop(
        offset.translate(-decoration.shiftX, 0), size.width, size.height);
    path = Path.combine(
        PathOperation.union,
        path,
        Path()
          ..addRRect(
              RRect.fromRectAndRadius(offset & size, Radius.circular(4))));
    canvas.drawPath(
        path,
        Paint()
          ..style
          ..color = decoration.color ?? Colors.black);
    if(decoration.style==PaintingStyle.stroke){
      canvas.drawPath(
          path,
          paint..style = PaintingStyle.stroke..color=const Color(0xffe4e7ed));
    }

    // canvas.drawRect(offset&size, Paint());
  }

  Path _drawTop(Offset offset, double width, double height) {
    var angleRad = pi / 180 * 70;
    double spineHeight = 8;
    var spineMoveX = spineHeight * tan(angleRad / 2);

    double xb = (width - decoration.boxSize.width) / 2 +
        decoration.boxSize.width / 2 -
        spineMoveX;

    double xbs = decoration.boxSize.width / 2;
    double xbe = width - decoration.boxSize.width / 2 - spineMoveX;

    double x = (width - decoration.boxSize.width) / 2 +
        decoration.boxSize.width / 2 -
        spineMoveX;

    Offset translation = switch (decoration.placement) {
      TooltipPlacement.top => Offset(xb, 0),
      TooltipPlacement.topStart => Offset(xbs, 0),
      TooltipPlacement.topEnd => Offset(xbe, 0),
      TooltipPlacement.bottom => Offset(xb, 0),
      TooltipPlacement.bottomStart => Offset(xbs, 0),
      TooltipPlacement.bottomEnd => Offset(xbe, 0),
      TooltipPlacement.left => Offset(
          0,
          (height - decoration.boxSize.height) / 2 +
              decoration.boxSize.height / 2 -
              spineMoveX),
      TooltipPlacement.leftStart =>
        Offset(0, decoration.boxSize.height / 2 - spineMoveX),
      TooltipPlacement.leftEnd =>
        Offset(0, height - decoration.boxSize.height / 2 - spineMoveX),
      TooltipPlacement.right => Offset(
          0,
          (height - decoration.boxSize.height) / 2 +
              decoration.boxSize.height / 2 -
              spineMoveX),
      TooltipPlacement.rightStart =>
        Offset(0, decoration.boxSize.height / 2 - spineMoveX),
      TooltipPlacement.rightEnd =>
        Offset(0, height - decoration.boxSize.height / 2 - spineMoveX),
    };

    var spineMoveY = spineHeight;
    if (spineHeight != 0) {
      if (decoration.placement == TooltipPlacement.bottom ||
          decoration.placement == TooltipPlacement.bottomStart ||
          decoration.placement == TooltipPlacement.bottomEnd) {
        return Path()
          ..moveTo(offset.dx + translation.dx, offset.dy + translation.dy)
          ..relativeLineTo(spineMoveX, -spineMoveY)
          ..relativeLineTo(spineMoveX, spineMoveY);
      }
      if (decoration.placement == TooltipPlacement.top ||
          decoration.placement == TooltipPlacement.topStart ||
          decoration.placement == TooltipPlacement.topEnd) {
        return Path()
          ..moveTo(
              offset.dx + translation.dx, offset.dy + translation.dy + height)
          ..relativeLineTo(spineMoveX, spineMoveY)
          ..relativeLineTo(spineMoveX, -spineMoveY);
      }
      if (decoration.placement == TooltipPlacement.rightStart ||
          decoration.placement == TooltipPlacement.right ||
          decoration.placement == TooltipPlacement.rightEnd) {
        return Path()
          ..moveTo(offset.dx + translation.dx, offset.dy + translation.dy)
          ..relativeLineTo(-spineMoveY, spineMoveX)
          ..relativeLineTo(spineMoveY, spineMoveX);
      }
      if (decoration.placement == TooltipPlacement.leftStart ||
          decoration.placement == TooltipPlacement.left ||
          decoration.placement == TooltipPlacement.leftEnd) {
        return Path()
          ..moveTo(
              offset.dx + translation.dx + width, offset.dy + translation.dy)
          ..relativeLineTo(spineMoveY, spineMoveX)
          ..relativeLineTo(-spineMoveY, spineMoveX);
      }
    }

    ///       return Path()
    //         ..moveTo(
    //             !formBottom ? offset : width - offset - spineHeight, lineHeight)
    //         ..relativeLineTo(spineMoveX, spineMoveY)
    //         ..relativeLineTo(spineMoveX, -spineMoveY);

    return Path();
  }
}
