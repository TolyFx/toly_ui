import 'package:flutter/material.dart';

/// 树形连接线绘制器
class TreeLinePainter extends CustomPainter {
  final int level;
  final double indent;
  final Color color;
  final double strokeWidth;
  final bool isLast;
  final bool hasChildren;
  final bool isExpanded;
  final List<bool> ancestorLines;

  TreeLinePainter({
    required this.level,
    required this.indent,
    required this.color,
    required this.strokeWidth,
    required this.isLast,
    required this.hasChildren,
    required this.isExpanded,
    required this.ancestorLines,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (level == 0) return;
    const double lineOffset = 16.0;
    const double hLineWidth = 6;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final centerY = size.height / 2;
    final currentX = level * indent + lineOffset;
    final parentX = (level - 1) * indent + lineOffset;

    // 横线长度变量
    final horizontalLineLength = indent - lineOffset + hLineWidth;
    final horizontalLineStartX = parentX;
    final horizontalLineEndX = parentX + horizontalLineLength;

    // 绘制祖先级别的垂直线
    for (int i = 0; i < level - 1; i++) {
      if (i < ancestorLines.length && ancestorLines[i]) {
        final x = i * indent + lineOffset;
        canvas.drawLine(
          Offset(x, 0),
          Offset(x, size.height),
          paint,
        );
      }
    }

    // 绘制父级到当前节点的垂直线（上半部分）
    canvas.drawLine(
      Offset(parentX, 0),
      Offset(parentX, centerY),
      paint,
    );

    // 绘制水平线（从父级到当前节点）
    canvas.drawLine(
      Offset(horizontalLineStartX, centerY),
      Offset(horizontalLineEndX, centerY),
      paint,
    );

    // 如果当前节点有子节点且已展开，绘制向下的线
    if (hasChildren && isExpanded) {
      // canvas.drawLine(
      //   Offset(currentX, centerY),
      //   Offset(currentX, size.height),
      //   paint,
      // );
    }

    // 如果不是最后一个节点，绘制父级的向下连接线
    if (!isLast) {
      canvas.drawLine(
        Offset(parentX, centerY),
        Offset(parentX, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
