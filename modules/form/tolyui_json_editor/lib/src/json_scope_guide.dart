/// 绘制 JSON 括号区块在编辑器中的纵向作用域引导线。

library;

import 'package:flutter/material.dart';

import 'json_fold_layout.dart';

/// 根据折叠后的可见行关系绘制括号作用域引导线。
class JsonScopeGuide extends StatelessWidget {
  /// 当前 JSON 折叠布局。
  final JsonFoldLayout foldLayout;

  /// 正文使用的等宽文本样式。
  final TextStyle textStyle;

  /// 正文相对编辑器左侧的起点。
  final double contentLeft;

  /// 第一行相对编辑器顶部的起点。
  final double contentTop;

  /// 单行文本高度。
  final double lineHeight;

  /// 引导线颜色。
  final Color color;

  const JsonScopeGuide({
    super.key,
    required this.foldLayout,
    required this.textStyle,
    required this.contentLeft,
    required this.contentTop,
    required this.lineHeight,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _JsonScopeGuidePainter(
        foldLayout: foldLayout,
        textStyle: textStyle,
        contentLeft: contentLeft,
        contentTop: contentTop,
        lineHeight: lineHeight,
        color: color,
      ),
    );
  }
}

/// 将源码区间映射到当前可见行坐标后完成绘制。
class _JsonScopeGuidePainter extends CustomPainter {
  /// 当前 JSON 折叠布局。
  final JsonFoldLayout foldLayout;

  /// 正文使用的等宽文本样式。
  final TextStyle textStyle;

  /// 正文相对编辑器左侧的起点。
  final double contentLeft;

  /// 第一行相对编辑器顶部的起点。
  final double contentTop;

  /// 单行文本高度。
  final double lineHeight;

  /// 引导线颜色。
  final Color color;

  const _JsonScopeGuidePainter({
    required this.foldLayout,
    required this.textStyle,
    required this.contentLeft,
    required this.contentTop,
    required this.lineHeight,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final List<JsonFoldLine> visibleLines = foldLayout.visibleLines;
    final Map<int, int> visibleIndexes = {};
    for (int index = 0; index < visibleLines.length; index++) {
      visibleIndexes[visibleLines[index].sourceIndex] = index;
    }
    final Paint guidePaint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    for (final MapEntry<int, int> range in foldLayout.foldRanges.entries) {
      if (foldLayout.collapsedLines.contains(range.key)) continue;
      final int? startVisibleIndex = visibleIndexes[range.key];
      final int? endVisibleIndex = visibleIndexes[range.value];
      if (startVisibleIndex == null || endVisibleIndex == null) continue;
      final int indentColumn = _indentColumn(
        foldLayout.sourceLines[range.key],
      );
      if (indentColumn == 0) continue;
      final double x =
          contentLeft + _measureIndent(indentColumn) - _spaceWidth / 2;
      final double startY =
          contentTop + (startVisibleIndex + 1) * lineHeight - 2;
      final double endY = contentTop + endVisibleIndex * lineHeight + 2;
      if (endY > startY) {
        canvas.drawLine(Offset(x, startY), Offset(x, endY), guidePaint);
      }
    }
  }

  /// 获取区块所属缩进列；零缩进代表最外层，不绘制引导线。
  int _indentColumn(String line) {
    final RegExpMatch? indentation = RegExp(r'^\s*').firstMatch(line);
    return indentation?.group(0)?.length ?? 0;
  }

  /// 直接度量真实缩进空格，避免字体回退时 `M` 字宽造成偏移。
  double _measureIndent(int column) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: ' ' * column, style: textStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    return painter.width;
  }

  /// 单个缩进空格在当前字体中的实际宽度。
  double get _spaceWidth {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: ' ', style: textStyle),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    return painter.width;
  }

  @override
  bool shouldRepaint(_JsonScopeGuidePainter oldDelegate) {
    return oldDelegate.foldLayout != foldLayout ||
        oldDelegate.textStyle != textStyle ||
        oldDelegate.contentLeft != contentLeft ||
        oldDelegate.contentTop != contentTop ||
        oldDelegate.lineHeight != lineHeight ||
        oldDelegate.color != color;
  }
}
