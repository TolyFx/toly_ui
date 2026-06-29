// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-02
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';

class TolyAlphaSlider extends StatelessWidget {
  final Color color;
  final double alpha;
  final ValueChanged<double> onChanged;

  const TolyAlphaSlider({
    super.key,
    required this.color,
    required this.alpha,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onPanDown: (d) => _onPan(d.localPosition.dx, constraints.maxWidth),
          onPanUpdate: (d) => _onPan(d.localPosition.dx, constraints.maxWidth),
          child: CustomPaint(
            size: Size(constraints.maxWidth, 24),
            painter: _AlphaSliderPainter(color, alpha),
          ),
        );
      },
    );
  }

  void _onPan(double dx, double width) {
    onChanged((dx / width).clamp(0.0, 1.0));
  }
}

class _AlphaSliderPainter extends CustomPainter {
  final Color color;
  final double alpha;

  static const double _radius = 7.0;

  _AlphaSliderPainter(this.color, this.alpha);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.height / 2));

    // Draw checkerboard clip
    canvas.save();
    canvas.clipRRect(rrect);
    _drawCheckerboard(canvas, rect);

    // Draw alpha gradient
    final Gradient gradient = LinearGradient(colors: [color.withValues(alpha: 0.0), color.withValues(alpha: 1.0)]);
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
    canvas.restore();

    // Border
    canvas.drawRRect(rrect, Paint()..style = PaintingStyle.stroke..color = Colors.grey.shade400..strokeWidth = 0.5);

    // Thumb — clamp within bounds so it's never clipped
    final double x = (alpha * size.width).clamp(_radius, size.width - _radius);
    canvas.drawCircle(Offset(x, size.height / 2), _radius, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(x, size.height / 2), _radius,
        Paint()..style = PaintingStyle.stroke..color = Colors.grey.shade700..strokeWidth = 1.5);
  }

  void _drawCheckerboard(Canvas canvas, Rect rect) {
    const double tileSize = 6;
    for (double y = 0; y < rect.height; y += tileSize) {
      for (double x = 0; x < rect.width; x += tileSize) {
        final bool isWhite = ((x ~/ tileSize + y ~/ tileSize)) % 2 == 0;
        canvas.drawRect(Rect.fromLTWH(x, y, tileSize, tileSize),
            Paint()..color = isWhite ? const Color(0xFFD0D0D0) : Colors.white);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _AlphaSliderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.alpha != alpha;
}
