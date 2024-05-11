import 'package:flutter/material.dart';

import '../../../tolyui_message.dart';
import 'message_overlay.dart';

typedef NoticeSizeReadCallback = void Function(
    NoticeOverlayState state, Size size);

class NoticeOverlay extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offsetY;
  final NoticeSizeReadCallback onSizeReady;
  final NoticePosition position;
  final Offset offset;

  const NoticeOverlay({
    super.key,
    required this.child,
    required this.offset,
    required this.position,
    required this.onSizeReady,
    required this.duration,
    required this.offsetY,
  });

  @override
  State<NoticeOverlay> createState() => NoticeOverlayState();
}

class NoticeOverlayState extends State<NoticeOverlay>
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
        child: CustomSingleChildLayout(
            delegate: NoticeLayoutDelegate(
              (size) => widget.onSizeReady(this, size),
              widget.offsetY,
              shiftTween?.animate(_shiftCtrl),
              position: widget.position,
              offset: widget.offset,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 320),
              child: SlideTransition(
                // opacity: _controller,
                position: Tween<Offset>(begin: startOffset, end: Offset.zero)
                    .animate(
                        CurveTween(curve: Curves.ease).animate(_controller)),
                child: widget.child,
              ),
            )));
  }

  Offset get startOffset => switch (widget.position) {
        NoticePosition.topLeft => const Offset(-1, 0),
        NoticePosition.topRight => const Offset(1, 0),
        NoticePosition.bottomLeft => const Offset(-1, 0),
        NoticePosition.bottomRight => const Offset(1, 0),
      };
}

class NoticeLayoutDelegate extends SingleChildLayoutDelegate {
  NoticeLayoutDelegate(
    this.onFetchSize,
    this.offsetY,
    this.shiftY, {
    required this.position,
    required this.offset,
  }) : super(relayout: shiftY);

  final ValueChanged<Size> onFetchSize;
  final double offsetY;
  final Animation<double>? shiftY;
  final NoticePosition position;

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
    double x = (size.width - childSize.width) / 2;
    double dY = offsetY + shift + offset.dy;
    double dX = 0;
    if (position.isBottom) {
      y = size.height - childSize.height;
      dY = -offsetY - shift - offset.dy;
    }
    if (position.isRight) {
      dX = (size.width - childSize.width) / 2 - offset.dx;
    }

    if (position.isLeft) {
      dX = -(size.width - childSize.width) / 2 + offset.dx;
    }

    return Offset(
      x + dX,
      y + dY,
    );
  }

  @override
  bool shouldRelayout(NoticeLayoutDelegate oldDelegate) {
    return oldDelegate.offsetY != offsetY || oldDelegate.offset != offset;
  }
}
