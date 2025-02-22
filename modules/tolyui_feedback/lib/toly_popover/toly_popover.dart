import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../toly_tooltip/position_delegate.dart';
import '../toly_tooltip/toly_tooltip.dart';
import '../toly_tooltip/tooltip_placement.dart';
import 'model/callback.dart';
import 'view/decration.dart';

part 'logic/controller.dart';

part 'view/_pop_overlay.dart';

part 'logic/hide_mixin.dart';

Offset boxOffsetCalculator(Calculator calculator) =>
    menuOffsetCalculator(calculator, shift: 6);

Offset menuOffsetCalculator(Calculator calculator, {double shift = 0}) {
  return switch (calculator.placement) {
    Placement.top => Offset(0, calculator.gap - shift),
    Placement.topStart => Offset(0, calculator.gap - shift),
    Placement.topEnd => Offset(0, calculator.gap - shift),
    Placement.bottom => Offset(0, -calculator.gap + shift),
    Placement.bottomStart => Offset(0, -calculator.gap + shift),
    Placement.bottomEnd => Offset(0, -calculator.gap + shift),
    Placement.leftStart => Offset(calculator.gap - shift, 0),
    Placement.left => Offset(calculator.gap - shift, 0),
    Placement.leftEnd => Offset(calculator.gap - shift, 0),
    Placement.rightStart => Offset(-calculator.gap + shift, 0),
    Placement.right => Offset(-calculator.gap + shift, 0),
    Placement.rightEnd => Offset(-calculator.gap + shift, 0),
  };
}

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
  final bool barrierDismissible;
  final EdgeInsets? margin;

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
    this.margin,
    this.placement = Placement.top,
    this.overlayBuilder,
    this.offsetCalculator,
    this.maxWidth,
    this.animDuration = const Duration(milliseconds: 250),
    this.reverseDuration = const Duration(milliseconds: 250),
    this.decorationConfig,
    this.maxHeight,
    this.barrierDismissible = true,
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
    with TickerProviderStateMixin, WidgetsBindingObserver, PopHideMixin {

  final OverlayPortalController _overlayController = OverlayPortalController(
    debugLabel: kReleaseMode ? null : 'TolyPopover controller',
  );

  Offset? _clickPosition;

  bool get _isOpen => _overlayController.isShowing;

  PopoverController? _internalPopController;

  PopoverController get _popCtrl =>
      widget.controller ?? _internalPopController!;

  AnimationController? _backingController;

  AnimationController get _controller {
    return _backingController ??= AnimationController(
      duration: widget.animDuration ,
      reverseDuration: widget.reverseDuration,
      vsync: this,
    )..addStatusListener(_handleStatusChanged);

  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internalPopController = PopoverController();
    }
    _popCtrl._attach(this);
  }

  @override
  void dispose() {
    if (_isOpen) {
      _close(inDispose: true);
    }
    _popCtrl._detach(this);
    _internalPopController = null;
    _backingController?.dispose();
    _backingController = null;
    super.dispose();
  }

  void _close({bool inDispose = false}) {
    if(!_overlayController.isShowing) return;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: _buildTooltipOverlay,
      child: Builder(
        builder: (BuildContext context) {
          Widget? child = widget.builder?.call(context, _popCtrl, widget.child);
          return child ?? widget.child ?? const SizedBox();
        },
      ),
    );

    if (widget.barrierDismissible) {
      child = TapRegion(
        groupId: _popCtrl,
        onTapOutside: (PointerDownEvent event) => _close(),
        child: child,
      );
    }
    return NotificationListener<ScrollNotification>(
        onNotification: (v){
          print("=================onNotification==================");
          return true;
        },
        child: child);
  }

  Widget _buildTooltipOverlay(BuildContext context) {
    final OverlayState overlayState =
        Overlay.of(context, debugRequiredFor: widget);
    final RenderBox box = this.context.findRenderObject()! as RenderBox;
    Offset target = box.localToGlobal(
      box.size.center(Offset.zero),
      ancestor: overlayState.context.findRenderObject(),
    );
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    final Widget overlayChild = _PopOverlay(
      overlay: widget.overlay,
      config: widget.decorationConfig,
      tapRegionGroup: _popCtrl,
      isDark: isDark,
      margin: widget.margin,
      clickPosition: _clickPosition,
      offsetCalculator: widget.offsetCalculator,
      boxSize: box.size,
      placement: widget.placement,
      overlayDecorationBuilder:
          widget.overlayDecorationBuilder ?? defaultDecorationBuilder,
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

  void _open({Offset? position}) {
    if (_isOpen) return;
    recordScrollPosition();
    _clickPosition = position;
    _controller.forward();
    _overlayController.show();
    widget.onOpen?.call();
  }

  void _handleStatusChanged(AnimationStatus status) {
    if (status.isDismissed) {
      if (_isOpen) {
        _overlayController.hide();
        widget.onClose?.call();
      }
    }
  }

  @override
  void onHide() {
    _close();
  }
}
