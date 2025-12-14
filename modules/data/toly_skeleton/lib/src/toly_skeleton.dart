import 'package:flutter/material.dart';

class TolySkeleton extends StatelessWidget {
  final bool loading;
  final bool active;
  final bool avatar;
  final bool title;
  final int paragraphRows;
  final Widget? child;

  const TolySkeleton({
    super.key,
    this.loading = true,
    this.active = false,
    this.avatar = false,
    this.title = true,
    this.paragraphRows = 3,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!loading && child != null) return child!;

    final hasAvatar = avatar;
    final hasTitle = title;
    final hasParagraph = paragraphRows > 0;

    double? titleWidth;
    if (!hasAvatar && hasParagraph) {
      titleWidth = 0.38;
    } else if (hasAvatar && hasParagraph) {
      titleWidth = 0.5;
    }

    double? paragraphLastWidth;
    if (!hasAvatar || !hasTitle) {
      paragraphLastWidth = 0.61;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (avatar) ...[
          _SkeletonAvatar(active: active),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title)
                _SkeletonElement(
                  widthFactor: titleWidth,
                  height: 16,
                  active: active,
                ),
              if (title && paragraphRows > 0) const SizedBox(height: 16),
              ...List.generate(paragraphRows, (i) {
                return Padding(
                  padding: EdgeInsets.only(bottom: i < paragraphRows - 1 ? 16 : 0),
                  child: _SkeletonElement(
                    widthFactor: i == paragraphRows - 1 ? paragraphLastWidth : null,
                    height: 16,
                    active: active,
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkeletonAvatar extends StatelessWidget {
  final bool active;
  final double size;

  const _SkeletonAvatar({this.active = false, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return _SkeletonElement(
      width: size,
      height: size,
      shape: BoxShape.circle,
      active: active,
    );
  }
}

class SkeletonButton extends StatelessWidget {
  final bool active;
  final double? width;
  final double height;
  final bool block;

  const SkeletonButton({
    super.key,
    this.active = false,
    this.width,
    this.height = 32,
    this.block = false,
  });

  @override
  Widget build(BuildContext context) {
    return _SkeletonElement(
      width: block ? double.infinity : (width ?? 64),
      height: height,
      active: active,
    );
  }
}

class SkeletonAvatar extends StatelessWidget {
  final bool active;
  final double size;
  final bool circle;

  const SkeletonAvatar({
    super.key,
    this.active = false,
    this.size = 40,
    this.circle = true,
  });

  @override
  Widget build(BuildContext context) {
    return _SkeletonElement(
      width: size,
      height: size,
      shape: circle ? BoxShape.circle : BoxShape.rectangle,
      active: active,
    );
  }
}

class SkeletonInput extends StatelessWidget {
  final bool active;
  final double? width;
  final double height;
  final bool block;

  const SkeletonInput({
    super.key,
    this.active = false,
    this.width,
    this.height = 32,
    this.block = false,
  });

  @override
  Widget build(BuildContext context) {
    return _SkeletonElement(
      width: block ? double.infinity : (width ?? 160),
      height: height,
      active: active,
    );
  }
}

class SkeletonImage extends StatelessWidget {
  final bool active;
  final double width;
  final double height;

  const SkeletonImage({
    super.key,
    this.active = false,
    this.width = 96,
    this.height = 96,
  });

  @override
  Widget build(BuildContext context) {
    return _SkeletonElement(
      width: width,
      height: height,
      active: active,
      child: Icon(Icons.image_outlined, size: 40, color: Colors.grey.shade400),
    );
  }
}

class _SkeletonElement extends StatefulWidget {
  final double? width;
  final double? widthFactor;
  final double? height;
  final BoxShape shape;
  final bool active;
  final Widget? child;

  const _SkeletonElement({
    this.width,
    this.widthFactor,
    this.height,
    this.shape = BoxShape.rectangle,
    this.active = false,
    this.child,
  });

  @override
  State<_SkeletonElement> createState() => _SkeletonElementState();
}

class _SkeletonElementState extends State<_SkeletonElement>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    if (widget.active) _controller.repeat();
  }

  @override
  void didUpdateWidget(_SkeletonElement oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active != oldWidget.active) {
      widget.active ? _controller.repeat() : _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.shape == BoxShape.circle
        ? BorderRadius.circular((widget.width ?? widget.height ?? 0) / 2)
        : BorderRadius.circular(4);

    Widget content = Container(
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        shape: widget.shape,
        borderRadius: widget.shape == BoxShape.rectangle ? borderRadius : null,
      ),
      child: widget.active
          ? AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    shape: widget.shape,
                    borderRadius: widget.shape == BoxShape.rectangle ? borderRadius : null,
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [
                        (_controller.value - 0.3).clamp(0.0, 1.0),
                        _controller.value,
                        (_controller.value + 0.3).clamp(0.0, 1.0),
                      ],
                      colors: const [
                        Color(0xFFF0F0F0),
                        Color(0xFFF5F5F5),
                        Color(0xFFF0F0F0),
                      ],
                    ),
                  ),
                  child: child,
                );
              },
              child: widget.child,
            )
          : widget.child,
    );

    if (widget.widthFactor != null) {
      return FractionallySizedBox(
        widthFactor: widget.widthFactor,
        alignment: Alignment.centerLeft,
        child: content,
      );
    }

    return content;
  }
}
