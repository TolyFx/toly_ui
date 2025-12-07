import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'types.dart';

class TolyTag extends StatefulWidget {
  final String? className;
  final Color? color;
  final TagVariant variant;
  final bool closable;
  final Widget? closeIcon;
  final VoidCallback? onClose;
  final Widget? icon;
  final bool disabled;
  final String? href;
  final VoidCallback? onTap;
  final Widget? child;
  final TagTheme? theme;

  const TolyTag({
    super.key,
    this.className,
    this.color,
    this.variant = TagVariant.filled,
    this.closable = false,
    this.closeIcon,
    this.onClose,
    this.icon,
    this.disabled = false,
    this.href,
    this.onTap,
    this.child,
    this.theme,
  });

  @override
  State<TolyTag> createState() => _TolyTagState();
}

class _TolyTagState extends State<TolyTag> with TickerProviderStateMixin {
  bool _isCloseHovered = false;
  late AnimationController _controller;
  late AnimationController _hoverController;
  late Animation<double> _animation;
  late Animation<double> _hoverAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.theme?.animationDuration ?? const Duration(milliseconds: 200),
      vsync: this,
    );
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _hoverAnimation = CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut);
    _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _handleClose() {
    if (widget.disabled) return;

    widget.onClose?.call();
  }

  Color get textColor {
    final theme = widget.theme ?? Theme.of(context).extension<TagTheme>() ?? TagTheme.defaultTheme();

    if (widget.disabled) {
      return theme.colorTextDisabled;
    }

    if (widget.color != null) {
      if (widget.variant == TagVariant.solid) {
        return theme.solidTextColor;
      } else {
        return widget.color!;
      }
    }

    if (widget.variant == TagVariant.solid) {
      return theme.colorTextLightSolid;
    }

    return theme.defaultColor;
  }

  BoxDecoration _buildDecoration() {
    final theme = widget.theme ?? Theme.of(context).extension<TagTheme>() ?? TagTheme.defaultTheme();

    Color bgColor = theme.defaultBg;
    Color finalBorderColor = theme.colorBorder;

    if (widget.disabled) {
      bgColor = theme.colorBgContainerDisabled;
      finalBorderColor = theme.colorBorderDisabled;
    } else if (widget.color != null) {
      if (widget.variant == TagVariant.solid) {
        bgColor = widget.color!;
        finalBorderColor = widget.color!;
      } else if (widget.variant == TagVariant.outlined || widget.variant == TagVariant.dashed) {
        bgColor = widget.color!.withOpacity(0.05);
        finalBorderColor = widget.color!;
      } else { // filled
        bgColor = widget.color!.withOpacity(0.1);
        finalBorderColor = Colors.transparent;
      }
    } else { // no color provided
      if (widget.variant == TagVariant.solid) {
        bgColor = theme.colorBgSolid;
        finalBorderColor = Colors.transparent;
      } else if (widget.variant == TagVariant.filled) {
        finalBorderColor = Colors.transparent;
      } else if (widget.variant == TagVariant.outlined || widget.variant == TagVariant.dashed) {
        finalBorderColor = theme.colorBorder;
      }
    }

    if (widget.onTap != null && !widget.disabled && _hoverAnimation.value > 0) {
      Color hoverBgColor;
      if (widget.color != null) {
        hoverBgColor = widget.color!.withOpacity(0.2);
      } else {
        hoverBgColor = theme.defaultBg.withOpacity(0.3);
      }
      bgColor = Color.lerp(bgColor, hoverBgColor, _hoverAnimation.value) ?? bgColor;
    }

    return BoxDecoration(
      color: bgColor,
      border: widget.variant == TagVariant.dashed ? null : Border.all(color: finalBorderColor, width: theme.borderWidth),
      borderRadius: BorderRadius.circular(theme.borderRadius),
    );
  }

  @override
  Widget build(BuildContext context) {

    final theme = widget.theme ?? Theme.of(context).extension<TagTheme>() ?? TagTheme.defaultTheme();

    return FadeTransition(
      opacity: _animation,
      child:  AnimatedBuilder(
          animation: _hoverAnimation,
          builder: (context, child) {
            Widget tagContent = Container(
              decoration: _buildDecoration(),
              padding: theme.padding,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    widget.icon!,
                    const SizedBox(width: 4),
                  ],
                  if (widget.child != null)
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: theme.fontSize,
                        leadingDistribution: TextLeadingDistribution.even,
                        // height: 1.0,
                        color: textColor,
                      ),
                      child: widget.child!,
                    ),
                  if (widget.closable) ...[
                    const SizedBox(width: 4),
                    MouseRegion(
                      onEnter: (_) => setState(() => _isCloseHovered = true),
                      onExit: (_) => setState(() => _isCloseHovered = false),
                      child: GestureDetector(
                        onTap: _handleClose,
                        child: widget.closeIcon ??
                            Icon(
                              Icons.close,
                              size: theme.iconSize,
                              color: widget.disabled
                                  ? theme.colorTextDisabled
                                  : _isCloseHovered
                                  ? Colors.red
                                  : theme.colorIcon,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            );

            if (widget.variant == TagVariant.dashed) {
              Color borderColor;
              if (widget.disabled) {
                borderColor = theme.colorBorderDisabled;
              } else {
                borderColor = widget.color ?? theme.colorBorder;
              }

              tagContent = CustomPaint(
                painter: _DashedRectPainter(
                  color: borderColor,
                  strokeWidth: theme.borderWidth,
                  radius: theme.borderRadius,
                  gap: 3,
                ),
                child: tagContent,
              );
            }

            return GestureDetector(
              onTap: widget.disabled ? null : widget.onTap,
              child: tagContent,
            );
          },
        )
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  _DashedRectPainter({
    this.color = Colors.black,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
    this.radius = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), Radius.circular(radius)));

    Path dashPath = Path();
    double dashWidth = 5.0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        double drawLength = min(dashWidth, pathMetric.length - distance);
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + drawLength),
          Offset.zero,
        );
        distance += dashWidth + gap;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(_DashedRectPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.gap != gap ||
      oldDelegate.radius != radius;
}
