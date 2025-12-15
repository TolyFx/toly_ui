import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class TolyWatermark extends StatelessWidget {
  final Widget child;
  final String? content;
  final List<String>? contents;
  final String? image;
  final double rotate;
  final double? width;
  final double? height;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final String fontFamily;
  final double gapX;
  final double gapY;
  final double? offsetX;
  final double? offsetY;

  const TolyWatermark({
    super.key,
    required this.child,
    this.content,
    this.contents,
    this.image,
    this.rotate = -22,
    this.width,
    this.height,
    this.color = const Color(0x26000000),
    this.fontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.fontFamily = 'sans-serif',
    this.gapX = 100,
    this.gapY = 100,
    this.offsetX,
    this.offsetY,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _WatermarkPainter(
                  content: content,
                  contents: contents,
                  image: image,
                  rotate: rotate,
                  width: width,
                  height: height,
                  color: color,
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  fontFamily: fontFamily,
                  gapX: gapX,
                  gapY: gapY,
                  offsetX: offsetX ?? gapX / 2,
                  offsetY: offsetY ?? gapY / 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WatermarkPainter extends CustomPainter {
  final String? content;
  final List<String>? contents;
  final String? image;
  final double rotate;
  final double? width;
  final double? height;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final String fontFamily;
  final double gapX;
  final double gapY;
  final double offsetX;
  final double offsetY;

  ui.Image? _image;

  _WatermarkPainter({
    this.content,
    this.contents,
    this.image,
    required this.rotate,
    this.width,
    this.height,
    required this.color,
    required this.fontSize,
    required this.fontWeight,
    required this.fontFamily,
    required this.gapX,
    required this.gapY,
    required this.offsetX,
    required this.offsetY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final textList = contents ?? (content != null ? [content!] : <String>[]);
    if (textList.isEmpty && image == null) return;

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final markSize = _getMarkSize(textList);
    final markWidth = width ?? markSize.width;
    final markHeight = height ?? markSize.height;

    final totalWidth = markWidth + gapX;
    final totalHeight = markHeight + gapY;

    final startX = offsetX - gapX / 2;
    final startY = offsetY - gapY / 2;

    final cols = ((size.width - startX) / totalWidth).ceil() + 1;
    final rows = ((size.height - startY) / totalHeight).ceil() + 1;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        canvas.save();

        final x = startX + col * totalWidth;
        final y = startY + row * totalHeight;

        canvas.translate(x + markWidth / 2, y + markHeight / 2);
        canvas.rotate(rotate * 3.14159 / 180);
        canvas.translate(-markWidth / 2, -markHeight / 2);

        if (image != null && _image != null) {
          _drawImage(canvas, markWidth, markHeight);
        } else {
          _drawText(canvas, textList, markWidth, markHeight);
        }

        canvas.restore();
      }
    }

    canvas.restore();
  }

  Size _getMarkSize(List<String> textList) {
    if (textList.isEmpty) {
      return const Size(120, 64);
    }

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    double maxWidth = 0;
    double totalHeight = 0;
    const lineGap = 4.0;

    for (int i = 0; i < textList.length; i++) {
      textPainter.text = TextSpan(
        text: textList[i],
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontFamily: fontFamily,
        ),
      );
      textPainter.layout();

      maxWidth = maxWidth > textPainter.width ? maxWidth : textPainter.width;
      totalHeight += textPainter.height;
      if (i < textList.length - 1) {
        totalHeight += lineGap;
      }
    }

    return Size(maxWidth, totalHeight);
  }

  void _drawText(Canvas canvas, List<String> textList, double markWidth, double markHeight) {
    const lineGap = 4.0;
    double currentY = 0;

    for (final text in textList) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      final offsetX = (markWidth - textPainter.width) / 2;
      textPainter.paint(canvas, Offset(offsetX, currentY));
      currentY += textPainter.height + lineGap;
    }
  }

  void _drawImage(Canvas canvas, double markWidth, double markHeight) {
    if (_image == null) return;

    final srcRect = Rect.fromLTWH(0, 0, _image!.width.toDouble(), _image!.height.toDouble());
    final dstRect = Rect.fromLTWH(0, 0, markWidth, markHeight);

    canvas.drawImageRect(_image!, srcRect, dstRect, Paint());
  }

  @override
  bool shouldRepaint(covariant _WatermarkPainter oldDelegate) {
    return oldDelegate.content != content ||
        oldDelegate.contents != contents ||
        oldDelegate.image != image ||
        oldDelegate.rotate != rotate ||
        oldDelegate.width != width ||
        oldDelegate.height != height ||
        oldDelegate.color != color ||
        oldDelegate.fontSize != fontSize ||
        oldDelegate.fontWeight != fontWeight ||
        oldDelegate.fontFamily != fontFamily ||
        oldDelegate.gapX != gapX ||
        oldDelegate.gapY != gapY ||
        oldDelegate.offsetX != offsetX ||
        oldDelegate.offsetY != offsetY;
  }
}
