import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../decoration/bubble_decoration.dart';
import '../toly_tooltip/position_delegate.dart';
import '../toly_tooltip/toly_tooltip.dart';
import '../toly_tooltip/tooltip_placement.dart';
import 'callback.dart';


class TolyPopover extends StatefulWidget {
  final Widget? child;
  final Widget? overlay;
  final PopoverController? controller;
  final Placement placement;
  final Duration reverseDuration;
  final Duration animDuration;
  final DecorationConfig? decorationConfig;
  final OffsetCalculator? offsetCalculator;
  final double? maxWidth;
  final double? maxHeight;

  final double? gap;
  final OverlayContentBuilder? overlayBuilder;
  final TolyPopoverChildBuilder? builder;
  final OverlayDecorationBuilder? overlayDecorationBuilder;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;

  const TolyPopover({
    super.key,
    this.child,
    this.overlay,
    this.controller,
    this.placement = Placement.top,
    this.overlayBuilder,
    this.offsetCalculator,
    this.maxWidth,
    this.animDuration = const Duration(milliseconds: 250),
    this.reverseDuration = const Duration(milliseconds: 250),
    this.decorationConfig,
    this.maxHeight,
    // this.padding,
    this.gap,
    this.builder,
    this.overlayDecorationBuilder,
    this.onOpen,
    this.onClose,
  });

  @override
  State<TolyPopover> createState() => _TolyPopoverState();
}

class _TolyPopoverState extends State<TolyPopover>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final OverlayPortalController _overlayController = OverlayPortalController(
      debugLabel: kReleaseMode ? null : 'TolyPopover controller');

  bool get _isOpen => _overlayController.isShowing;
  PopoverController? _internalPopController;

  PopoverController get _popController =>
      widget.controller ?? _internalPopController!;

  AnimationController? _backingController;
  ScrollPosition? _scrollPosition;

  AnimationController get _controller {
    return _backingController ??= AnimationController(
      duration: widget.animDuration,
      reverseDuration: widget.reverseDuration,
      vsync: this,
    )..addStatusListener(_handleStatusChanged);
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollPosition?.isScrollingNotifier.removeListener(_handleScroll);
    _scrollPosition = Scrollable.maybeOf(context)?.position;
    _scrollPosition?.isScrollingNotifier.addListener(_handleScroll);
  }

  void _handleScroll() {
    _close();
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalPopController = PopoverController();
    }
    WidgetsBinding.instance.addObserver(this);
    _popController._attach(this);
  }

  @override
  void dispose() {
    if (_isOpen) {
      _close(inDispose: true);
    }
    _popController._detach(this);
    _internalPopController = null;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _close({bool inDispose = false}) {
    _controller.reverse();
  }

  // 监听窗口尺寸变化
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _close();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: _buildTooltipOverlay,
      child: _buildContents(context),
    );
    child = TapRegion(
      groupId: _popController,
      // consumeOutsideTaps: _root._isOpen && widget.consumeOutsideTap,
      onTapOutside: (PointerDownEvent event) {
        _close();
      },
      child: child,
    );
    return child;
  }

  Widget _buildContents(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return widget.builder?.call(context, _popController, widget.child) ??
            widget.child ??
            const SizedBox();
      },
    );
  }

  Widget _buildTooltipOverlay(BuildContext context) {
    final OverlayState overlayState =
        Overlay.of(context, debugRequiredFor: widget);
    final RenderBox box = this.context.findRenderObject()! as RenderBox;
    final Offset target = box.localToGlobal(
      box.size.center(Offset.zero),
      ancestor: overlayState.context.findRenderObject(),
    );
    final Widget overlayChild = _PopOverlay(
      overlay: widget.overlay,
      tapRegionGroup: _popController,
      offsetCalculator: widget.offsetCalculator,
      boxSize: box.size,
      placement: widget.placement,
      overlayDecorationBuilder:
          widget.overlayDecorationBuilder ?? _defaultDecorationBuilder,
      maxWidth: widget.maxWidth,
      maxHeight: widget.maxHeight ?? double.infinity,
      // padding: widget.padding,
      overlayBuilder: widget.overlayBuilder,
      animation:
          CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
      target: target,
      verticalOffset: widget.gap ?? 12,
    );

    return SelectionContainer.maybeOf(context) == null
        ? overlayChild
        : SelectionContainer.disabled(child: overlayChild);
  }

  Decoration _defaultDecorationBuilder(PopoverDecoration decoration) {
    DecorationConfig config = widget.decorationConfig ??
        DecorationConfig(
            backgroundColor: Colors.white,
            style: PaintingStyle.stroke,
            shadows: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 2),
                blurRadius: 6,
                spreadRadius: 0,
              )
            ]);
    return BubbleDecoration(
      shiftX: decoration.shift.dx,
      radius: config.radius,
      shadows: config.shadows,
      boxSize: decoration.boxSize,
      placement: decoration.placement,
      color: config.backgroundColor,
      style: config.style,
    );
  }

  void _open() {
    if (_isOpen) return;
    _controller.forward();
    _overlayController.show();
    widget.onOpen?.call();
  }

  void _handleStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      if (_isOpen) {
        _overlayController.hide();
        widget.onClose?.call();
      }
    }
  }
}

class PopoverController {
  _TolyPopoverState? _state;

  bool get isOpen {
    assert(_state != null);
    return _state!._isOpen;
  }

  void close() {
    assert(_state != null);
    _state!._close();
  }

  void open() {
    assert(_state != null);
    _state!._open();
  }

  void _attach(_TolyPopoverState state) {
    _state = state;
  }

  void _detach(_TolyPopoverState state) {
    if (_state == state) {
      _state = null;
    }
  }
}

class _PopOverlay extends StatefulWidget {
  const _PopOverlay({
    required this.maxHeight,
    required this.boxSize,
    required this.placement,
    this.maxWidth,
    required this.overlay,
    required this.tapRegionGroup,
    required this.offsetCalculator,

    // this.padding,
    required this.animation,
    required this.target,
    required this.verticalOffset,
    required this.overlayBuilder,
    required this.overlayDecorationBuilder,
  });

  final OverlayContentBuilder? overlayBuilder;
  final OffsetCalculator? offsetCalculator;
  final Widget? overlay;
  final OverlayDecorationBuilder overlayDecorationBuilder;
  final Placement placement;
  final double maxHeight;
  final double? maxWidth;

  // final EdgeInsetsGeometry? padding;
  final Animation<double> animation;
  final Offset target;
  final PopoverController tapRegionGroup;
  final Size boxSize;
  final double verticalOffset;

  @override
  State<_PopOverlay> createState() => _PopOverlayState();
}



class _PopOverlayState extends State<_PopOverlay> {
  late Placement effectPlacement = widget.placement;
  double shiftX = 0;

  // Decoration get effectDecoration {
  //   DecorationConfig config = widget.decoration;
  //   if (config.isBubble) {
  //     return BubbleDecoration(
  //         shiftX: shiftX,
  //         radius: config.radius,
  //         boxSize: widget.boxSize,
  //         placement: effectPlacement,
  //         color: config.backgroundColor,
  //         style: config.style);
  //   }
  //   return BoxDecoration(
  //       color: config.backgroundColor,
  //       borderRadius: BorderRadius.all(config.radius),
  //       border: config.style == PaintingStyle.stroke
  //           ? Border.all(color: Color(0xffe4e7ed))
  //           : null);
  // }

  @override
  Widget build(BuildContext context) {
    Widget result = FadeTransition(
      opacity: widget.animation,
      child: TapRegion(
        groupId: widget.tapRegionGroup,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: widget.maxHeight, maxWidth: widget.maxWidth ?? 320),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium!,
            child: Semantics(
              container: true,
              child: Container(
                decoration: widget.overlayDecorationBuilder(PopoverDecoration(
                  placement: effectPlacement,
                  shift: Offset(shiftX, 0),
                  boxSize: widget.boxSize,
                )),
                // padding: widget.padding,
                child: widget.overlayBuilder
                        ?.call(context, widget.tapRegionGroup) ??
                    widget.overlay,
              ),
            ),
          ),
        ),
      ),
    );
    return Positioned.fill(
      bottom: 0.0,
      child: CustomSingleChildLayout(
        delegate: PopoverPositionDelegate(
          offsetCalculator: widget.offsetCalculator,
          onPlacementShift: _onPlacementShift,
          target: widget.target,
          placement: widget.placement,
          gap: widget.verticalOffset,
          boxSize: widget.boxSize,
        ),
        child: result,
      ),
    );
  }

  void _onPlacementShift(PlacementShift shift) {
    effectPlacement = shift.placement;
    shiftX = shift.x;
    setState(() {});
  }
}
