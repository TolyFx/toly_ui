import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 轮播图切换效果
enum CarouselEffect {
  /// 滚动效果
  scroll,

  /// 淡入淡出效果
  fade,
}

/// 指示器位置
enum DotPlacement {
  /// 顶部
  top,

  /// 底部
  bottom,

  /// 左侧
  start,

  /// 右侧
  end,
}

/// 轮播图组件
class TolyCarousel extends StatefulWidget {
  /// 子组件列表
  final List<Widget> children;

  /// 是否显示指示器
  final bool dots;

  /// 指示器位置
  final DotPlacement dotPlacement;

  /// 是否显示箭头按钮
  final bool arrows;

  /// 是否自动播放
  final bool autoplay;

  /// 自动播放间隔时间（毫秒）
  final int autoplaySpeed;

  /// 是否显示指示器进度动画
  final bool dotDuration;

  /// 切换效果
  final CarouselEffect effect;

  /// 是否垂直滚动
  final bool vertical;

  /// 初始显示的索引
  final int initialSlide;

  /// 是否无限循环
  final bool infinite;

  /// 切换动画时长
  final Duration duration;

  /// 切换动画曲线
  final Curve curve;

  /// 高度
  final double? height;

  /// 切换回调
  final ValueChanged<int>? onChanged;

  /// 指示器样式
  final Widget Function(int index, bool isActive)? dotBuilder;

  const TolyCarousel({
    super.key,
    required this.children,
    this.dots = true,
    this.dotPlacement = DotPlacement.bottom,
    this.arrows = false,
    this.autoplay = false,
    this.autoplaySpeed = 3000,
    this.dotDuration = false,
    this.effect = CarouselEffect.scroll,
    this.vertical = false,
    this.initialSlide = 0,
    this.infinite = true,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.height,
    this.onChanged,
    this.dotBuilder,
  });

  @override
  State<TolyCarousel> createState() => TolyCarouselState();
}

class TolyCarouselState extends State<TolyCarousel> {
  late PageController _pageController;
  late int _currentIndex;
  Timer? _autoplayTimer;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialSlide;
    final initialPage = widget.infinite ? widget.initialSlide + 10000 : widget.initialSlide;
    _pageController = PageController(
      initialPage: initialPage,
      viewportFraction: 1.0,
    );

    if (widget.autoplay) {
      _startAutoplay();
    }
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TolyCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autoplay != oldWidget.autoplay) {
      if (widget.autoplay) {
        _startAutoplay();
      } else {
        _stopAutoplay();
      }
    }
  }

  void _startAutoplay() {
    _autoplayTimer?.cancel();
    _autoplayTimer = Timer.periodic(
      Duration(milliseconds: widget.autoplaySpeed),
      (_) => _next(),
    );
  }

  void _stopAutoplay() {
    _autoplayTimer?.cancel();
  }

  void _next() {
    if (!mounted) return;
    if (widget.infinite) {
      final currentPage = _pageController.page?.round() ?? 0;
      _pageController.nextPage(
        duration: widget.duration,
        curve: widget.curve,
      );
    } else {
      final nextIndex = _currentIndex + 1;
      if (nextIndex < widget.children.length) {
        goTo(nextIndex);
      }
    }
  }

  void _prev() {
    if (!mounted) return;
    if (widget.infinite) {
      _pageController.previousPage(
        duration: widget.duration,
        curve: widget.curve,
      );
    } else {
      final prevIndex = _currentIndex - 1;
      if (prevIndex >= 0) {
        goTo(prevIndex);
      }
    }
  }

  /// 跳转到指定索引
  void goTo(int index, {bool animate = true}) {
    if (!mounted) return;
    final targetPage = widget.infinite ? index + 10000 : index;
    if (animate) {
      _pageController.animateToPage(
        targetPage,
        duration: widget.duration,
        curve: widget.curve,
      );
    } else {
      _pageController.jumpToPage(targetPage);
    }
  }

  /// 下一页
  void next() => _next();

  /// 上一页
  void prev() => _prev();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: widget.vertical ? Axis.vertical : Axis.horizontal,
            itemCount: widget.infinite ? null : widget.children.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index % widget.children.length;
              });
              widget.onChanged?.call(_currentIndex);
            },
            itemBuilder: (context, index) {
              final realIndex = index % widget.children.length;
              if (widget.effect == CarouselEffect.fade) {
                return AnimatedOpacity(
                  opacity: _currentIndex == realIndex ? 1.0 : 0.0,
                  duration: widget.duration,
                  child: widget.children[realIndex],
                );
              }
              return widget.children[realIndex];
            },
          ),
          if (widget.arrows) _buildArrows(),
          if (widget.dots) _buildDotsOverlay(),
        ],
      ),
    );
  }

  Widget _buildArrows() {
    final canGoPrev = widget.infinite || _currentIndex > 0;
    final canGoNext = widget.infinite || _currentIndex < widget.children.length - 1;

    return Positioned.fill(
      child: IgnorePointer(
        ignoring: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ArrowButton(
              onPressed: canGoPrev ? _prev : null,
              isLeft: true,
              isVertical: widget.vertical,
            ),
            _ArrowButton(
              onPressed: canGoNext ? _next : null,
              isLeft: false,
              isVertical: widget.vertical,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDotsOverlay() {
    Alignment alignment;
    switch (widget.dotPlacement) {
      case DotPlacement.top:
        alignment = Alignment.topCenter;
        break;
      case DotPlacement.bottom:
        alignment = Alignment.bottomCenter;
        break;
      case DotPlacement.start:
        alignment = Alignment.centerLeft;
        break;
      case DotPlacement.end:
        alignment = Alignment.centerRight;
        break;
    }

    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: _buildDots(),
      ),
    );
  }

  Widget _buildDots() {
    final isVertical = widget.dotPlacement == DotPlacement.start ||
        widget.dotPlacement == DotPlacement.end;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Flex(
        direction: isVertical ? Axis.vertical : Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.children.length,
          (index) {
            final isActive = index == _currentIndex;
            if (widget.dotBuilder != null) {
              return GestureDetector(
                onTap: () => goTo(index),
                child: widget.dotBuilder!(index, isActive),
              );
            }
            return GestureDetector(
              onTap: () => goTo(index),
              child: _DotIndicator(
                isActive: isActive,
                isVertical: isVertical,
                showDuration: widget.dotDuration && widget.autoplay,
                duration: Duration(milliseconds: widget.autoplaySpeed),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// 箭头按钮组件
class _ArrowButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLeft;
  final bool isVertical;

  const _ArrowButton({
    required this.onPressed,
    required this.isLeft,
    required this.isVertical,
  });

  @override
  State<_ArrowButton> createState() => _ArrowButtonState();
}

class _ArrowButtonState extends State<_ArrowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.onPressed != null;
    final opacity = isEnabled ? (_isHovered ? 1.0 : 0.4) : 0.0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: opacity,
            child: SizedBox(
              width: 16,
              height: 16,
              child: CustomPaint(
                painter: _ArrowPainter(
                  isLeft: widget.isLeft,
                  isVertical: widget.isVertical,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 箭头绘制
class _ArrowPainter extends CustomPainter {
  final bool isLeft;
  final bool isVertical;

  _ArrowPainter({required this.isLeft, required this.isVertical});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final arrowSize = size.width / math.sqrt2;
    final offset = (size.width - arrowSize) / 2;

    if (isVertical) {
      if (isLeft) {
        // 向上箭头
        path.moveTo(offset, offset + arrowSize);
        path.lineTo(size.width / 2, offset);
        path.lineTo(offset + arrowSize, offset + arrowSize);
      } else {
        // 向下箭头
        path.moveTo(offset, offset);
        path.lineTo(size.width / 2, offset + arrowSize);
        path.lineTo(offset + arrowSize, offset);
      }
    } else {
      if (isLeft) {
        // 向左箭头
        path.moveTo(offset + arrowSize, offset);
        path.lineTo(offset, size.height / 2);
        path.lineTo(offset + arrowSize, offset + arrowSize);
      } else {
        // 向右箭头
        path.moveTo(offset, offset);
        path.lineTo(offset + arrowSize, size.height / 2);
        path.lineTo(offset, offset + arrowSize);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 指示器组件
class _DotIndicator extends StatefulWidget {
  final bool isActive;
  final bool isVertical;
  final bool showDuration;
  final Duration duration;

  const _DotIndicator({
    required this.isActive,
    required this.isVertical,
    required this.showDuration,
    required this.duration,
  });

  @override
  State<_DotIndicator> createState() => _DotIndicatorState();
}

class _DotIndicatorState extends State<_DotIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    if (widget.isActive && widget.showDuration) {
      _controller.forward(from: 0);
    }
  }

  @override
  void didUpdateWidget(_DotIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive && widget.showDuration) {
        _controller.forward(from: 0);
      } else {
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = Colors.white;
    final inactiveColor = Colors.white;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: widget.isVertical ? 3 : (widget.isActive ? 24 : 16),
      height: widget.isVertical ? (widget.isActive ? 24 : 16) : 3,
      margin: EdgeInsets.symmetric(
        horizontal: widget.isVertical ? 0 : 4,
        vertical: widget.isVertical ? 4 : 0,
      ),
      decoration: BoxDecoration(
        color: inactiveColor.withOpacity(widget.isActive ? 1.0 : 0.2),
        borderRadius: BorderRadius.circular(1.5),
      ),
      child: widget.isActive && widget.showDuration
          ? AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(1.5),
                  child: Align(
                    alignment: widget.isVertical ? Alignment.topCenter : Alignment.centerLeft,
                    child: Container(
                      width: widget.isVertical ? 3 : 24 * _controller.value,
                      height: widget.isVertical ? 24 * _controller.value : 3,
                      decoration: BoxDecoration(
                        color: activeColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                  ),
                );
              },
            )
          : null,
    );
  }
}
