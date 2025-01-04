// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../tolyui_feedback.dart';
import 'position_delegate.dart';
import 'tooltip_placement.dart';

/// Signature for when a tooltip is triggered.
typedef TooltipTriggeredCallback = void Function();

/// A special [MouseRegion] that when nested, only the first [_ExclusiveMouseRegion]
/// to be hit in hit-testing order will be added to the BoxHitTestResult (i.e.,
/// child over parent, last sibling over first sibling).
///
/// The [onEnter] method will be called when a mouse pointer enters this
/// [MouseRegion], and there is no other [_ExclusiveMouseRegion]s obstructing
/// this [_ExclusiveMouseRegion] from receiving the events. This includes the
/// case where the mouse cursor stays within the paint bounds of an outer
/// [_ExclusiveMouseRegion], but moves outside of the bounds of the inner
/// [_ExclusiveMouseRegion] that was initially blocking the outer widget.
///
/// Likewise, [onExit] is called when the a mouse pointer moves out of the paint
/// bounds of this widget, or moves into another [_ExclusiveMouseRegion] that
/// overlaps this widget in hit-testing order.
///
/// This widget doesn't affect [MouseRegion]s that aren't [_ExclusiveMouseRegion]s,
/// or other [HitTestTarget]s in the tree.
class _ExclusiveMouseRegion extends MouseRegion {
  const _ExclusiveMouseRegion({
    super.onEnter,
    super.onExit,
    super.child,
  });

  @override
  _RenderExclusiveMouseRegion createRenderObject(BuildContext context) {
    return _RenderExclusiveMouseRegion(
      onEnter: onEnter,
      onExit: onExit,
    );
  }
}

class _RenderExclusiveMouseRegion extends RenderMouseRegion {
  _RenderExclusiveMouseRegion({
    super.onEnter,
    super.onExit,
  });

  static bool isOutermostMouseRegion = true;
  static bool foundInnermostMouseRegion = false;

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    bool isHit = false;
    final bool outermost = isOutermostMouseRegion;
    isOutermostMouseRegion = false;
    if (size.contains(position)) {
      isHit =
          hitTestChildren(result, position: position) || hitTestSelf(position);
      if ((isHit || behavior == HitTestBehavior.translucent) &&
          !foundInnermostMouseRegion) {
        foundInnermostMouseRegion = true;
        result.add(BoxHitTestEntry(this, position));
      }
    }

    if (outermost) {
      // The outermost region resets the global states.
      isOutermostMouseRegion = true;
      foundInnermostMouseRegion = false;
    }
    return isHit;
  }
}

/// A Material Design tooltip.
///
/// Tooltips provide text labels which help explain the function of a button or
/// other user interface action. Wrap the button in a [TolyTooltip] widget and provide
/// a message which will be shown when the widget is long pressed.
///
/// Many widgets, such as [IconButton], [FloatingActionButton], and
/// [PopupMenuButton] have a `tooltip` property that, when non-null, causes the
/// widget to include a [TolyTooltip] in its build.
///
/// Tooltips improve the accessibility of visual widgets by proving a textual
/// representation of the widget, which, for example, can be vocalized by a
/// screen reader.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=EeEfD5fI-5Q}
///
/// {@tool dartpad}
/// This example show a basic [TolyTooltip] which has a [Text] as child.
/// [message] contains your label to be shown by the tooltip when
/// the child that Tooltip wraps is hovered over on web or desktop. On mobile,
/// the tooltip is shown when the widget is long pressed.
///
/// This tooltip will default to showing above the [Text] instead of below
/// because its ambient [TooltipThemeData.preferBelow] is false.
/// (See the use of [MaterialApp.theme].)
/// Setting that piece of theme data is recommended to avoid having a finger or
/// cursor hide the tooltip. For other ways to set that piece of theme data see:
///
/// * [Theme.data], [ThemeData.tooltipTheme]
/// * [TooltipTheme.data]
///
/// or it can be set directly on each tooltip with [TolyTooltip.preferBelow].
///
/// ** See code in examples/api/lib/material/tooltip/tooltip.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example covers most of the attributes.dart available in Tooltip.
/// `decoration` has been used to give a gradient and borderRadius to Tooltip.
/// `height` has been used to set a specific height of the Tooltip.
/// `preferBelow` is true; the tooltip will prefer showing below [TolyTooltip]'s child widget.
/// However, it may show the tooltip above if there's not enough space
/// below the widget.
/// `textStyle` has been used to set the font size of the 'message'.
/// `showDuration` accepts a Duration to continue showing the message after the long
/// press has been released or the mouse pointer exits the child widget.
/// `waitDuration` accepts a Duration for which a mouse pointer has to hover over the child
/// widget before the tooltip is shown.
///
/// ** See code in examples/api/lib/material/tooltip/tooltip.1.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows a rich [TolyTooltip] that specifies the [richMessage]
/// parameter instead of the [message] parameter (only one of these may be
/// non-null. Any [InlineSpan] can be specified for the [richMessage] attribute,
/// including [WidgetSpan].
///
/// ** See code in examples/api/lib/material/tooltip/tooltip.2.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows how [TolyTooltip] can be shown manually with [TooltipTriggerMode.manual]
/// by calling the [TolyTooltipState.ensureTooltipVisible] function.
///
/// ** See code in examples/api/lib/material/tooltip/tooltip.3.dart **
/// {@end-tool}
///
/// See also:
///
///  * <https://material.io/design/components/tooltips.html>
///  * [TooltipTheme] or [ThemeData.tooltipTheme]
///  * [TooltipVisibility]
class TolyTooltip extends StatefulWidget {
  /// Creates a tooltip.
  ///
  /// By default, tooltips should adhere to the
  /// [Material specification](https://material.io/design/components/tooltips.html#spec).
  /// If the optional constructor parameters are not defined, the values
  /// provided by [TooltipTheme.of] will be used if a [TooltipTheme] is present
  /// or specified in [ThemeData].
  ///
  /// All parameters that are defined in the constructor will
  /// override the default values _and_ the values in [TooltipTheme.of].
  ///
  /// Only one of [message] and  bvc[richMessage] may be non-null.
  ///  \bv,m,
  ///  |
  const TolyTooltip({
    super.key,
    this.message,
    this.richMessage,
    this.height,
    this.padding,
    this.margin,
    this.gap,
    this.excludeFromSemantics,
    this.decorationConfig,
    this.textStyle,
    this.maxWidth,
    this.textAlign,
    this.waitDuration,
    this.showDuration,
    this.exitDuration,
    this.enableTapToDismiss = true,
    this.triggerMode,
    this.enableFeedback,
    this.onTriggered,
    this.placement = Placement.bottom,
    this.child,
  })  : assert((message == null) != (richMessage == null),
            'Either `message` or `richMessage` must be specified'),
        assert(
          richMessage == null || textStyle == null,
          'If `richMessage` is specified, `textStyle` will have no effect. '
          'If you wish to provide a `textStyle` for a rich tooltip, add the '
          '`textStyle` directly to the `richMessage` InlineSpan.',
        );

  /// The text to display in the tooltip.
  ///
  /// Only one of [message] and [richMessage] may be non-null.
  final String? message;

  final Placement placement;

  /// The rich text to display in the tooltip.
  ///
  /// Only one of [message] and [richMessage] may be non-null.
  final InlineSpan? richMessage;

  /// The height of the tooltip's [child].
  ///
  /// If the [child] is null, then this is the tooltip's intrinsic height.
  final double? height;
  final double? maxWidth;

  /// The amount of space by which to inset the tooltip's [child].
  ///
  /// On mobile, defaults to 16.0 logical pixels horizontally and 4.0 vertically.
  /// On desktop, defaults to 8.0 logical pixels horizontally and 4.0 vertically.
  final EdgeInsetsGeometry? padding;

  /// The empty space that surrounds the tooltip.
  ///
  /// Defines the tooltip's outer [Container.margin]. By default, a
  /// long tooltip will span the width of its window. If long enough,
  /// a tooltip might also span the window's height. This property allows
  /// one to define how much space the tooltip must be inset from the edges
  /// of their display window.
  ///
  /// If this property is null, then [TooltipThemeData.margin] is used.
  /// If [TooltipThemeData.margin] is also null, the default margin is
  /// 0.0 logical pixels on all sides.
  final EdgeInsets? margin;

  /// The gap between the widget and the displayed tooltip.
  final double? gap;


  /// Whether the tooltip's [message] or [richMessage] should be excluded from
  /// the semantics tree.
  ///
  /// Defaults to false. A tooltip will add a [Semantics] label that is set to
  /// [TolyTooltip.message] if non-null, or the plain text value of
  /// [TolyTooltip.richMessage] otherwise. Set this property to true if the app is
  /// going to provide its own custom semantics label.
  final bool? excludeFromSemantics;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  final DecorationConfig? decorationConfig;

  /// The style to use for the message of the tooltip.
  ///
  /// If null, the message's [TextStyle] will be determined based on
  /// [ThemeData]. If [ThemeData.brightness] is set to [Brightness.dark],
  /// [TextTheme.bodyMedium] of [ThemeData.textTheme] will be used with
  /// [Colors.white]. Otherwise, if [ThemeData.brightness] is set to
  /// [Brightness.light], [TextTheme.bodyMedium] of [ThemeData.textTheme] will be
  /// used with [Colors.black].
  final TextStyle? textStyle;

  /// How the message of the tooltip is aligned horizontally.
  ///
  /// If this property is null, then [TooltipThemeData.textAlign] is used.
  /// If [TooltipThemeData.textAlign] is also null, the default value is
  /// [TextAlign.start].
  final TextAlign? textAlign;

  /// The length of time that a pointer must hover over a tooltip's widget
  /// before the tooltip will be shown.
  ///
  /// Defaults to 0 milliseconds (tooltips are shown immediately upon hover).
  final Duration? waitDuration;

  /// The length of time that the tooltip will be shown after a long press is
  /// released (if triggerMode is [TooltipTriggerMode.longPress]) or a tap is
  /// released (if triggerMode is [TooltipTriggerMode.tap]). This property
  /// does not affect mouse pointer devices.
  ///
  /// Defaults to 1.5 seconds for long press and tap released
  ///
  /// See also:
  ///
  ///  * [exitDuration], which allows configuring the time untill a pointer
  /// dissapears when hovering.
  final Duration? showDuration;

  /// The length of time that a pointer must have stopped hovering over a
  /// tooltip's widget before the tooltip will be hidden.
  ///
  /// Defaults to 100 milliseconds.
  ///
  /// See also:
  ///
  ///  * [showDuration], which allows configuring the length of time that a
  /// tooltip will be visible after touch events are released.
  final Duration? exitDuration;

  /// Whether the tooltip can be dismissed by tap.
  ///
  /// The default value is true.
  final bool enableTapToDismiss;

  /// The [TooltipTriggerMode] that will show the tooltip.
  ///
  /// If this property is null, then [TooltipThemeData.triggerMode] is used.
  /// If [TooltipThemeData.triggerMode] is also null, the default mode is
  /// [TooltipTriggerMode.longPress].
  ///
  /// This property does not affect mouse devices. Setting [triggerMode] to
  /// [TooltipTriggerMode.manual] will not prevent the tooltip from showing when
  /// the mouse cursor hovers over it.
  final TooltipTriggerMode? triggerMode;

  /// Whether the tooltip should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a
  /// long-press will produce a short vibration, when feedback is enabled.
  ///
  /// When null, the default value is true.
  ///
  /// See also:
  ///
  ///  * [Feedback], for providing platform-specific feedback to certain actions.
  final bool? enableFeedback;

  /// Called when the Tooltip is triggered.
  ///
  /// The tooltip is triggered after a tap when [triggerMode] is [TooltipTriggerMode.tap]
  /// or after a long press when [triggerMode] is [TooltipTriggerMode.longPress].
  final TooltipTriggeredCallback? onTriggered;

  static final List<TolyTooltipState> _openedTooltips = <TolyTooltipState>[];

  /// Dismiss all of the tooltips that are currently shown on the screen,
  /// including those with mouse cursors currently hovering over them.
  ///
  /// This method returns true if it successfully dismisses the tooltips. It
  /// returns false if there is no tooltip shown on the screen.
  static bool dismissAllToolTips() {
    if (_openedTooltips.isNotEmpty) {
      // Avoid concurrent modification.
      final List<TolyTooltipState> openedTooltips = _openedTooltips.toList();
      for (final TolyTooltipState state in openedTooltips) {
        assert(state.mounted);
        state._scheduleDismissTooltip(withDelay: Duration.zero);
      }
      return true;
    }
    return false;
  }

  @override
  State<TolyTooltip> createState() => TolyTooltipState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty(
      'message',
      message,
      showName: message == null,
      defaultValue: message == null ? null : kNoDefaultValue,
    ));
    properties.add(StringProperty(
      'richMessage',
      richMessage?.toPlainText(),
      showName: richMessage == null,
      defaultValue: richMessage == null ? null : kNoDefaultValue,
    ));
    properties.add(DoubleProperty('height', height, defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin,
        defaultValue: null));
    properties.add(
        DoubleProperty('vertical offset', gap, defaultValue: null));
    // properties.add(FlagProperty('position',
    //     value: placement, ifTrue: 'below', ifFalse: 'above', showName: true));
    properties.add(FlagProperty('semantics',
        value: excludeFromSemantics, ifTrue: 'excluded', showName: true));
    properties.add(DiagnosticsProperty<Duration>('wait duration', waitDuration,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Duration>('show duration', showDuration,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Duration>('exit duration', exitDuration,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TooltipTriggerMode>(
        'triggerMode', triggerMode,
        defaultValue: null));
    properties.add(FlagProperty('enableFeedback',
        value: enableFeedback, ifTrue: 'true', showName: true));
    properties.add(DiagnosticsProperty<TextAlign>('textAlign', textAlign,
        defaultValue: null));
  }
}

/// Contains the state for a [TolyTooltip].
///
/// This class can be used to programmatically show the Tooltip, see the
/// [ensureTooltipVisible] method.
class TolyTooltipState extends State<TolyTooltip>
    with SingleTickerProviderStateMixin {
  static const double _defaultVerticalOffset = 24.0;
  static const EdgeInsets _defaultMargin = EdgeInsets.zero;
  static const Duration _fadeInDuration = Duration(milliseconds: 150);
  static const Duration _fadeOutDuration = Duration(milliseconds: 75);
  static const Duration _defaultShowDuration = Duration(milliseconds: 1500);
  static const Duration _defaultHoverExitDuration = Duration(milliseconds: 100);
  static const Duration _defaultWaitDuration = Duration.zero;
  static const bool _defaultExcludeFromSemantics = false;
  static const TooltipTriggerMode _defaultTriggerMode =
      TooltipTriggerMode.longPress;
  static const bool _defaultEnableFeedback = true;
  static const TextAlign _defaultTextAlign = TextAlign.start;

  final OverlayPortalController _overlayController = OverlayPortalController();

  // From InheritedWidgets
  late bool _visible;
  late TooltipThemeData _tooltipTheme;

  Duration get _showDuration =>
      widget.showDuration ?? _tooltipTheme.showDuration ?? _defaultShowDuration;

  Duration get _hoverExitDuration =>
      widget.exitDuration ??
      _tooltipTheme.exitDuration ??
      _defaultHoverExitDuration;

  Duration get _waitDuration =>
      widget.waitDuration ?? _tooltipTheme.waitDuration ?? _defaultWaitDuration;

  TooltipTriggerMode get _triggerMode =>
      widget.triggerMode ?? _tooltipTheme.triggerMode ?? _defaultTriggerMode;

  bool get _enableFeedback =>
      widget.enableFeedback ??
      _tooltipTheme.enableFeedback ??
      _defaultEnableFeedback;

  /// The plain text message for this tooltip.
  ///
  /// This value will either come from [widget.message] or [widget.richMessage].
  String get _tooltipMessage =>
      widget.message ?? widget.richMessage!.toPlainText();

  Timer? _timer;
  AnimationController? _backingController;

  AnimationController get _controller {
    return _backingController ??= AnimationController(
      duration: _fadeInDuration,
      reverseDuration: _fadeOutDuration,
      vsync: this,
    )..addStatusListener(_handleStatusChanged);
  }

  LongPressGestureRecognizer? _longPressRecognizer;
  TapGestureRecognizer? _tapRecognizer;

  // The ids of mouse devices that are keeping the tooltip from being dismissed.
  //
  // Device ids are added to this set in _handleMouseEnter, and removed in
  // _handleMouseExit. The set is cleared in _handleTapToDismiss, typically when
  // a PointerDown event interacts with some other UI component.
  final Set<int> _activeHoveringPointerDevices = <int>{};

  static bool _isTooltipVisible(AnimationStatus status) {
    return switch (status) {
      AnimationStatus.completed ||
      AnimationStatus.forward ||
      AnimationStatus.reverse =>
        true,
      AnimationStatus.dismissed => false,
    };
  }

  AnimationStatus _animationStatus = AnimationStatus.dismissed;

  void _handleStatusChanged(AnimationStatus status) {
    assert(mounted);
    switch ((_isTooltipVisible(_animationStatus), _isTooltipVisible(status))) {
      case (true, false):
        TolyTooltip._openedTooltips.remove(this);
        _overlayController.hide();
      case (false, true):
        _overlayController.show();
        TolyTooltip._openedTooltips.add(this);
        SemanticsService.tooltip(_tooltipMessage);
      case (true, true) || (false, false):
        break;
    }
    _animationStatus = status;
  }

  void _scheduleShowTooltip(
      {required Duration withDelay, Duration? showDuration}) {
    assert(mounted);
    void show() {
      assert(mounted);
      if (!_visible) {
        return;
      }
      _controller.forward();
      _timer?.cancel();
      _timer = showDuration == null
          ? null
          : Timer(showDuration, _controller.reverse);
    }

    assert(
      !(_timer?.isActive ?? false) ||
          _controller.status != AnimationStatus.reverse,
      'timer must not be active when the tooltip is fading out',
    );
    switch (_controller.status) {
      case AnimationStatus.dismissed when withDelay.inMicroseconds > 0:
        _timer ??= Timer(withDelay, show);
      // If the tooltip is already fading in or fully visible, skip the
      // animation and show the tooltip immediately.
      case AnimationStatus.dismissed:
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
      case AnimationStatus.completed:
        show();
    }
  }

  void _scheduleDismissTooltip({required Duration withDelay}) {
    assert(mounted);
    assert(
      !(_timer?.isActive ?? false) ||
          _backingController?.status != AnimationStatus.reverse,
      'timer must not be active when the tooltip is fading out',
    );

    _timer?.cancel();
    _timer = null;
    // Use _backingController instead of _controller to prevent the lazy getter
    // from instaniating an AnimationController unnecessarily.
    switch (_backingController?.status) {
      case null:
      case AnimationStatus.reverse:
      case AnimationStatus.dismissed:
        break;
      // Dismiss when the tooltip is fading in: if there's a dismiss delay we'll
      // allow the fade in animation to continue until the delay timer fires.
      case AnimationStatus.forward:
      case AnimationStatus.completed:
        if (withDelay.inMicroseconds > 0) {
          _timer = Timer(withDelay, _controller.reverse);
        } else {
          _controller.reverse();
        }
    }
  }

  void _handlePointerDown(PointerDownEvent event) {
    assert(mounted);
    // PointerDeviceKinds that don't support hovering.
    const Set<PointerDeviceKind> triggerModeDeviceKinds = <PointerDeviceKind>{
      PointerDeviceKind.invertedStylus,
      PointerDeviceKind.stylus,
      PointerDeviceKind.touch,
      PointerDeviceKind.unknown,
      // MouseRegion only tracks PointerDeviceKind == mouse.
      PointerDeviceKind.trackpad,
    };
    switch (_triggerMode) {
      case TooltipTriggerMode.longPress:
        final LongPressGestureRecognizer recognizer =
            _longPressRecognizer ??= LongPressGestureRecognizer(
          debugOwner: this,
          supportedDevices: triggerModeDeviceKinds,
        );
        recognizer
          ..onLongPressCancel = _handleTapToDismiss
          ..onLongPress = _handleLongPress
          ..onLongPressUp = _handlePressUp
          ..addPointer(event);
      case TooltipTriggerMode.tap:
        final TapGestureRecognizer recognizer = _tapRecognizer ??=
            TapGestureRecognizer(
                debugOwner: this, supportedDevices: triggerModeDeviceKinds);
        recognizer
          ..onTapCancel = _handleTapToDismiss
          ..onTap = _handleTap
          ..addPointer(event);
      case TooltipTriggerMode.manual:
        break;
    }
  }

  // For PointerDownEvents, this method will be called after _handlePointerDown.
  void _handleGlobalPointerEvent(PointerEvent event) {
    assert(mounted);
    if (_tapRecognizer?.primaryPointer == event.pointer ||
        _longPressRecognizer?.primaryPointer == event.pointer) {
      // This is a pointer of interest specified by the trigger mode, since it's
      // picked up by the recognizer.
      //
      // The recognizer will later determine if this is indeed a "trigger"
      // gesture and dismiss the tooltip if that's not the case. However there's
      // still a chance that the PointerEvent was cancelled before the gesture
      // recognizer gets to emit a tap/longPress down, in which case the onCancel
      // callback (_handleTapToDismiss) will not be called.
      return;
    }
    if ((_timer == null && _controller.status == AnimationStatus.dismissed) ||
        event is! PointerDownEvent) {
      return;
    }
    _handleTapToDismiss();
  }

  // The primary pointer is not part of a "trigger" gesture so the tooltip
  // should be dismissed.
  void _handleTapToDismiss() {
    if (!widget.enableTapToDismiss) {
      return;
    }
    _scheduleDismissTooltip(withDelay: Duration.zero);
    _activeHoveringPointerDevices.clear();
  }

  void _handleTap() {
    if (!_visible) {
      return;
    }
    final bool tooltipCreated = _controller.status == AnimationStatus.dismissed;
    if (tooltipCreated && _enableFeedback) {
      assert(_triggerMode == TooltipTriggerMode.tap);
      Feedback.forTap(context);
    }
    widget.onTriggered?.call();
    _scheduleShowTooltip(
      withDelay: Duration.zero,
      // _activeHoveringPointerDevices keep the tooltip visible.
      showDuration:
          _activeHoveringPointerDevices.isEmpty ? _showDuration : null,
    );
  }

  // When a "trigger" gesture is recognized and the pointer down even is a part
  // of it.
  void _handleLongPress() {
    if (!_visible) {
      return;
    }
    final bool tooltipCreated =
        _visible && _controller.status == AnimationStatus.dismissed;
    if (tooltipCreated && _enableFeedback) {
      assert(_triggerMode == TooltipTriggerMode.longPress);
      Feedback.forLongPress(context);
    }
    widget.onTriggered?.call();
    _scheduleShowTooltip(withDelay: Duration.zero);
  }

  void _handlePressUp() {
    if (_activeHoveringPointerDevices.isNotEmpty) {
      return;
    }
    _scheduleDismissTooltip(withDelay: _showDuration);
  }

  // # Current Hovering Behavior:
  // 1. Hovered tooltips don't show more than one at a time, for each mouse
  //    device. For example, a chip with a delete icon typically shouldn't show
  //    both the delete icon tooltip and the chip tooltip at the same time.
  // 2. Hovered tooltips are dismissed when:
  //    i. [dismissAllToolTips] is called, even these tooltips are still hovered
  //    ii. a unrecognized PointerDownEvent occured withint the application
  //    (even these tooltips are still hovered),
  //    iii. The last hovering device leaves the tooltip.
  void _handleMouseEnter(PointerEnterEvent event) {
    // _handleMouseEnter is only called when the mouse starts to hover over this
    // tooltip (including the actual tooltip it shows on the overlay), and this
    // tooltip is the first to be hit in the widget tree's hit testing order.
    // See also _ExclusiveMouseRegion for the exact behavior.
    _activeHoveringPointerDevices.add(event.device);
    final List<TolyTooltipState> openedTooltips =
        TolyTooltip._openedTooltips.toList();
    bool otherTooltipsDismissed = false;
    for (final TolyTooltipState tooltip in openedTooltips) {
      assert(tooltip.mounted);
      final Set<int> hoveringDevices = tooltip._activeHoveringPointerDevices;
      final bool shouldDismiss = tooltip != this &&
          (hoveringDevices.length == 1 &&
              hoveringDevices.single == event.device);
      if (shouldDismiss) {
        otherTooltipsDismissed = true;
        tooltip._scheduleDismissTooltip(withDelay: Duration.zero);
      }
    }
    _scheduleShowTooltip(withDelay: _waitDuration);
  }

  void _handleMouseExit(PointerExitEvent event) {
    if (_activeHoveringPointerDevices.isEmpty) {
      return;
    }
    _activeHoveringPointerDevices.remove(event.device);
    if (_activeHoveringPointerDevices.isEmpty) {
      _scheduleDismissTooltip(withDelay: _hoverExitDuration);
    }
  }

  /// Shows the tooltip if it is not already visible.
  ///
  /// After made visible by this method, The tooltip does not automatically
  /// dismiss after `waitDuration`, until the user dismisses/re-triggers it, or
  /// [TolyTooltip.dismissAllToolTips] is called.
  ///
  /// Returns `false` when the tooltip shouldn't be shown or when the tooltip
  /// was already visible.
  bool ensureTooltipVisible() {
    if (!_visible) {
      return false;
    }

    _timer?.cancel();
    _timer = null;
    switch (_controller.status) {
      case AnimationStatus.dismissed:
      case AnimationStatus.reverse:
        _scheduleShowTooltip(withDelay: Duration.zero);
        return true;
      case AnimationStatus.forward:
      case AnimationStatus.completed:
        return false;
    }
  }

  @override
  void initState() {
    super.initState();
    // Listen to global pointer events so that we can hide a tooltip immediately
    // if some other control is clicked on. Pointer events are dispatched to
    // global routes **after** other routes.
    GestureBinding.instance.pointerRouter
        .addGlobalRoute(_handleGlobalPointerEvent);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _visible = TooltipVisibility.of(context);
    _tooltipTheme = TooltipTheme.of(context);
  }

  // https://material.io/components/tooltips#specs
  double _getDefaultTooltipHeight() {
    return switch (Theme.of(context).platform) {
      TargetPlatform.macOS ||
      TargetPlatform.linux ||
      TargetPlatform.windows =>
        24.0,
      TargetPlatform.android ||
      TargetPlatform.fuchsia ||
      TargetPlatform.iOS =>
        32.0,
    };
  }

  EdgeInsets _getDefaultPadding() {
    return switch (Theme.of(context).platform) {
      TargetPlatform.macOS ||
      TargetPlatform.linux ||
      TargetPlatform.windows =>
        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      TargetPlatform.android ||
      TargetPlatform.fuchsia ||
      TargetPlatform.iOS =>
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    };
  }

  static double _getDefaultFontSize(TargetPlatform platform) {
    return switch (platform) {
      TargetPlatform.macOS ||
      TargetPlatform.linux ||
      TargetPlatform.windows =>
        12.0,
      TargetPlatform.android ||
      TargetPlatform.fuchsia ||
      TargetPlatform.iOS =>
        14.0,
    };
  }

  Widget _buildTooltipOverlay(BuildContext context) {
    final OverlayState overlayState =
        Overlay.of(context, debugRequiredFor: widget);
    final RenderBox box = this.context.findRenderObject()! as RenderBox;
    final Offset target = box.localToGlobal(
      box.size.center(Offset.zero),
      ancestor: overlayState.context.findRenderObject(),
    );

    final (TextStyle defaultTextStyle, BoxDecoration defaultDecoration) =
        switch (Theme.of(context)) {
      ThemeData(
        brightness: Brightness.dark,
        :final TextTheme textTheme,
        :final TargetPlatform platform
      ) =>
        (
          textTheme.bodyMedium!.copyWith(
              color: Colors.black, fontSize: _getDefaultFontSize(platform)),
          BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: const BorderRadius.all(Radius.circular(4))),
        ),
      ThemeData(
        brightness: Brightness.light,
        :final TextTheme textTheme,
        :final TargetPlatform platform
      ) =>
        (
          textTheme.bodyMedium!.copyWith(
              color: Colors.white, fontSize: _getDefaultFontSize(platform)),
          BoxDecoration(
              color: Colors.grey[700]!.withOpacity(0.9),
              borderRadius: const BorderRadius.all(Radius.circular(4))),
        ),
    };

    final TooltipThemeData tooltipTheme = _tooltipTheme;
    final _TooltipOverlay overlayChild = _TooltipOverlay(
      boxSize: box.size,
      placement: widget.placement,
      maxWidth: widget.maxWidth,
      richMessage: widget.richMessage ?? TextSpan(text: widget.message),
      maxHeight: widget.height??double.infinity,
      padding: widget.padding ?? tooltipTheme.padding ?? _getDefaultPadding(),
      margin: widget.margin ?? _defaultMargin,
      onEnter: _handleMouseEnter,
      onExit: _handleMouseExit,
      decoration: widget.decorationConfig ?? DecorationConfig(),
      textStyle: widget.textStyle ?? tooltipTheme.textStyle ?? defaultTextStyle,
      textAlign:
          widget.textAlign ?? tooltipTheme.textAlign ?? _defaultTextAlign,
      animation:
          CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
      target: target,
      verticalOffset: widget.gap ??
          tooltipTheme.verticalOffset ??
          _defaultVerticalOffset,
    );

    return SelectionContainer.maybeOf(context) == null
        ? overlayChild
        : SelectionContainer.disabled(child: overlayChild);
  }

  @override
  void dispose() {
    GestureBinding.instance.pointerRouter
        .removeGlobalRoute(_handleGlobalPointerEvent);
    TolyTooltip._openedTooltips.remove(this);
    // _longPressRecognizer.dispose() and _tapRecognizer.dispose() may call
    // their registered onCancel callbacks if there's a gesture in progress.
    // Remove the onCancel callbacks to prevent the registered callbacks from
    // triggering unnecessary side effects (such as animations).
    _longPressRecognizer?.onLongPressCancel = null;
    _longPressRecognizer?.dispose();
    _tapRecognizer?.onTapCancel = null;
    _tapRecognizer?.dispose();
    _timer?.cancel();
    _backingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // If message is empty then no need to create a tooltip overlay to show
    // the empty black container so just return the wrapped child as is or
    // empty container if child is not specified.
    if (_tooltipMessage.isEmpty) {
      return widget.child ?? const SizedBox.shrink();
    }
    assert(debugCheckHasOverlay(context));
    final bool excludeFromSemantics = widget.excludeFromSemantics ??
        _tooltipTheme.excludeFromSemantics ??
        _defaultExcludeFromSemantics;
    Widget result = Semantics(
      tooltip: excludeFromSemantics ? null : _tooltipMessage,
      child: widget.child,
    );

    // Only check for gestures if tooltip should be visible.
    if (_visible) {
      result = _ExclusiveMouseRegion(
        onEnter: _handleMouseEnter,
        onExit: _handleMouseExit,
        child: Listener(
          onPointerDown: _handlePointerDown,
          behavior: HitTestBehavior.opaque,
          child: result,
        ),
      );
    }
    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: _buildTooltipOverlay,
      child: result,
    );
  }
}

class _TooltipOverlay extends StatefulWidget {
  const _TooltipOverlay({
    required this.maxHeight,
    required this.richMessage,
    required this.boxSize,
    required this.placement,
    this.maxWidth,
    this.padding,
    this.margin,
    required this.decoration,
    this.textStyle,
    this.textAlign,
    required this.animation,
    required this.target,
    required this.verticalOffset,
    this.onEnter,
    this.onExit,
  });

  final InlineSpan richMessage;
  final Placement placement;
  final double maxHeight;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsets? margin;
  final DecorationConfig decoration;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final Animation<double> animation;
  final Offset target;
  final Size boxSize;
  final double verticalOffset;
  final PointerEnterEventListener? onEnter;
  final PointerExitEventListener? onExit;

  @override
  State<_TooltipOverlay> createState() => _TooltipOverlayState();
}

class DecorationConfig {
  final PaintingStyle style;
  final Color backgroundColor;
  final Color? textColor;
  final bool isBubble;
  final Radius radius;
  final List<BoxShadow>? shadows;
  final BubbleMeta bubbleMeta;

  const DecorationConfig({
    this.style = PaintingStyle.fill,
    this.backgroundColor= const Color(0xff303133),
    this.textColor,
    this.shadows,
    this.radius = const Radius.circular(4),
    this.isBubble = true,
    this.bubbleMeta = const BubbleMeta(),
  });
}

class _TooltipOverlayState extends State<_TooltipOverlay> {
  late Placement effectPlacement = widget.placement;
  double shiftX = 0;

  Decoration get effectDecoration {
    DecorationConfig config = widget.decoration;
    if (config.isBubble) {
      return BubbleDecoration(
        borderColor: const Color(0xffe4e7ed),
        shiftX: shiftX,
        radius: config.radius,
        boxSize: widget.boxSize,
        placement: effectPlacement,
        color: config.backgroundColor,
          style: config.style,
        bubbleMeta: config.bubbleMeta,
      );
    }
    return BoxDecoration(
      color: config.backgroundColor,
      borderRadius: BorderRadius.all(config.radius),
      border: config.style==PaintingStyle.stroke?Border.all(
        color: Color(0xffe4e7ed)
      ):null
    );
  }

  TextStyle? get effectTextStyle {
    return  widget.textStyle?.copyWith(color: widget.decoration.textColor);
  }

  @override
  Widget build(BuildContext context) {
    Widget result = FadeTransition(
      opacity: widget.animation,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: widget.maxHeight,
            maxWidth: widget.maxWidth ?? 320),
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.bodyMedium!,
          child: Semantics(
            container: true,
            child: Container(
              // decoration: decoration,
              decoration: effectDecoration,
              // padding: widget.padding,
              // margin: margin,
              child: SingleChildScrollView(
                child: Padding(
                  padding: widget.padding??EdgeInsets.zero,
                  child: Text.rich(
                    widget.richMessage,
                    style: effectTextStyle,
                    textAlign: widget.textAlign,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    if (widget.onEnter != null || widget.onExit != null) {
      result = _ExclusiveMouseRegion(
        onEnter: widget.onEnter,
        onExit: widget.onExit,
        child: result,
      );
    }
    return Positioned.fill(
      bottom: 0.0,
      child: CustomSingleChildLayout(
        delegate: PopoverPositionDelegate(
          clickPosition: null,
          margin: widget.margin,
          onPlacementShift: _onPlacementShift,
          position: widget.target,
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
