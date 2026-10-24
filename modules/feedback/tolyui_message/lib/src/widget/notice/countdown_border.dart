import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';

/// 为自动关闭通知绘制逐渐缩短的外沿，不参与卡片布局或指针命中。
class NoticeCountdownBorder extends StatefulWidget {
  const NoticeCountdownBorder({
    required this.duration,
    required this.color,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    super.key,
  });

  /// 与消息调度器一致的显示时长，零表示常驻。
  final Duration duration;

  /// 随通知语义变化的边线颜色。
  final Color color;

  /// 与通知面板一致的圆角，主题覆盖时同步边线形状。
  final BorderRadius borderRadius;

  /// 保持独立绘制的通知内容。
  final Widget child;

  @override
  State<NoticeCountdownBorder> createState() => _NoticeCountdownBorderState();
}

class _NoticeCountdownBorderState extends State<NoticeCountdownBorder>
    with SingleTickerProviderStateMixin {
  /// 线性计时仅驱动边线重绘，不逐帧重建磨砂内容。
  late final AnimationController _elapsed;

  @override
  void initState() {
    super.initState();
    _elapsed = AnimationController(vsync: this);
    _start();
  }

  /// 显示时长变化时重置边线；常驻通知不运行计时动画。
  void _start() {
    _elapsed.stop();
    _elapsed.value = 0;
    if (widget.duration > Duration.zero) {
      _elapsed.duration = widget.duration;
      _elapsed.forward();
    }
  }

  @override
  void didUpdateWidget(NoticeCountdownBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) _start();
  }

  @override
  void dispose() {
    _elapsed.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.duration <= Duration.zero) return widget.child;
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: NoticeBorderPainter(_elapsed, widget.color,
                    borderRadius: widget.borderRadius),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 沿圆角矩形保留与剩余时间成比例的弧长。
class NoticeBorderPainter extends CustomPainter {
  NoticeBorderPainter(this.elapsed, this.color,
      {this.borderRadius = const BorderRadius.all(Radius.circular(12))})
      : super(repaint: elapsed);

  /// 面板的外沿圆角。
  final BorderRadius borderRadius;

  /// 已经过的时间比例，卡片挂载时为零。
  final Animation<double> elapsed;

  /// 状态色边线，保留玻璃底层的常规亮边。
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final double remaining = (1 - elapsed.value).clamp(0, 1);
    if (remaining <= 0 || size.isEmpty) return;
    const double stroke = 1.5;
    final Path outline = Path()
      ..addRRect(borderRadius.toRRect(Offset.zero & size).deflate(stroke / 2));
    final Paint paint = Paint()
      ..color = color.withValues(alpha: 0.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    for (final PathMetric metric in outline.computeMetrics()) {
      canvas.drawPath(
          metric.extractPath(metric.length * (1 - remaining), metric.length),
          paint);
    }
  }

  @override
  bool shouldRepaint(NoticeBorderPainter oldDelegate) =>
      oldDelegate.elapsed != elapsed ||
      oldDelegate.color != color ||
      oldDelegate.borderRadius != borderRadius;
}
