import 'package:flutter/material.dart';

/// 默认空状态图片
class DefaultEmptyImage extends StatelessWidget {
  const DefaultEmptyImage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return CustomPaint(
      size: const Size(184, 152),
      painter: _DefaultEmptyPainter(isDark: isDark),
    );
  }
}

/// 简单空状态图片
class SimpleEmptyImage extends StatelessWidget {
  const SimpleEmptyImage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return CustomPaint(
      size: const Size(64, 41),
      painter: _SimpleEmptyPainter(
        borderColor: theme.dividerColor,
        shadowColor: theme.colorScheme.surfaceVariant,
        contentColor: theme.colorScheme.surface,
      ),
    );
  }
}

class _DefaultEmptyPainter extends CustomPainter {
  const _DefaultEmptyPainter({required this.isDark});
  
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // 绘制椭圆阴影
    paint.color = const Color(0xFFF5F5F7).withOpacity(0.8);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.85),
        width: size.width * 0.7,
        height: 25,
      ),
      paint,
    );
    
    // 绘制主体
    paint.color = const Color(0xFFF5F5F7);
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * 0.18,
        size.height * 0.03,
        size.width * 0.64,
        size.height * 0.65,
      ),
      const Radius.circular(4),
    );
    canvas.drawRRect(rect, paint);
    
    // 绘制内容区域
    paint.color = const Color(0xFFAEB8C2);
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.23,
        size.height * 0.08,
        size.width * 0.54,
        size.height * 0.18,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SimpleEmptyPainter extends CustomPainter {
  const _SimpleEmptyPainter({
    required this.borderColor,
    required this.shadowColor,
    required this.contentColor,
  });
  
  final Color borderColor;
  final Color shadowColor;
  final Color contentColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // 绘制阴影椭圆
    paint.color = shadowColor;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.85),
        width: size.width,
        height: 14,
      ),
      paint,
    );
    
    // 绘制边框
    paint
      ..color = contentColor
      ..style = PaintingStyle.fill;
    
    final path = Path()
      ..moveTo(size.width * 0.14, size.height * 0.32)
      ..lineTo(size.width * 0.86, size.height * 0.32)
      ..lineTo(size.width * 0.86, size.height * 0.76)
      ..quadraticBezierTo(
        size.width * 0.86, size.height * 0.85,
        size.width * 0.81, size.height * 0.85,
      )
      ..lineTo(size.width * 0.19, size.height * 0.85)
      ..quadraticBezierTo(
        size.width * 0.14, size.height * 0.85,
        size.width * 0.14, size.height * 0.76,
      )
      ..close();
    
    canvas.drawPath(path, paint);
    
    // 绘制边框线
    paint
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}