import 'dart:async';

import 'package:flutter/material.dart';

typedef SizeReadCallback = void Function(LoadingOverlayState state, Size size);

class LoadingOverlay extends StatefulWidget {
  final Widget child;
  final Color? color;
  final Completer<bool> completer;
  final VoidCallback close;

  const LoadingOverlay({
    super.key,
    required this.child,
    this.color,
    required this.completer,
    required this.close,
  });

  @override
  State<LoadingOverlay> createState() => LoadingOverlayState();
}

class LoadingOverlayState extends State<LoadingOverlay> with TickerProviderStateMixin {
  late AnimationController _controller;

  static const Duration _animationDuration = Duration(milliseconds: 300);

  Tween<double>? shiftTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _animationDuration,
      reverseDuration: _animationDuration,
      vsync: this,
    )..forward();
    widget.completer.future.then(_whenTaskDone);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      bottom: 0.0,
      child: FadeTransition(
        opacity: _controller,
        child: Material(
          color: widget.color ?? Colors.white.withOpacity(0.7),
          child: Center(child: widget.child),
        ),
      ),
    );
  }

  void _whenTaskDone(bool value) async {
    await _controller.reverse();
    widget.close();
  }
}
