import 'package:flutter/material.dart';

import '../../../tolyui_message.dart';

typedef SizeReadCallback = void Function(MessageOverlayState state, Size size);

class MessageOverlay extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double startY;
  final double endY;
  final SizeReadCallback onSizeReady;
  final MessagePosition position;
  final Offset offset;

  const MessageOverlay({
    super.key,
    required this.child,
    required this.offset,
    required this.position,
    required this.onSizeReady,
    required this.startY,
    required this.duration,
    required this.endY,
  });

  @override
  State<MessageOverlay> createState() => MessageOverlayState();
}

class MessageOverlayState extends State<MessageOverlay>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _shiftCtrl;

  double shiftY = 0;

  Tween<double>? shiftTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      reverseDuration: widget.duration,
      vsync: this,
    )..forward();
    _shiftCtrl = AnimationController(
      duration: widget.duration,
      reverseDuration: widget.duration,
      vsync: this,
    );

    Tween(begin: widget.startY, end: widget.endY);
  }

  TickerFuture close() => _controller.reverse();

  @override
  void dispose() {
    _shiftCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  void shift(double y) {
    shiftTween = Tween(begin: shiftY, end: shiftY + y);
    shiftY += y;
    _shiftCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        bottom: 0.0,
        child: FadeTransition(
          opacity: _controller,
          child: CustomSingleChildLayout(
            delegate: MessageLayoutDelegate(
                  (size) => widget.onSizeReady(this, size),
              Tween(begin: widget.startY, end: widget.endY)
                  .animate(_controller),
              shiftTween?.animate(_shiftCtrl),
              position: widget.position,
              offset: widget.offset,
            ),
            child: Material(
                color: Colors.transparent,
                child: widget.child),
          ),
        ));
  }
}

class MessageLayoutDelegate extends SingleChildLayoutDelegate {
  MessageLayoutDelegate(
      this.onFetchSize,
      this.offsetY,
      this.shiftY, {
        required this.position,
        required this.offset,
      }) : super(relayout: Listenable.merge([offsetY, shiftY]));

  final ValueChanged<Size> onFetchSize;
  final Animation<double> offsetY;
  final Animation<double>? shiftY;
  final MessagePosition position;

  final Offset offset;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    onFetchSize.call(childSize);
    double shift = 0;
    if (shiftY != null) {
      shift = shiftY!.value;
    }
    double y = 0;
    double dY = offsetY.value + shift + offset.dy;
    if (position == MessagePosition.bottom) {
      y = size.height - childSize.height;
      dY = -offsetY.value - shift - offset.dy;
    }

    return Offset(
      (size.width - childSize.width) / 2 + offset.dx,
      y + dY,
    );
  }

  @override
  bool shouldRelayout(MessageLayoutDelegate oldDelegate) {
    return oldDelegate.offsetY != offsetY || oldDelegate.offset != offset;
  }
}