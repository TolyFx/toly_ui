// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

const double _kTabHeight = 46.0;
const double _kTextAndIconTabHeight = 72.0;
const double _kStartOffset = 52.0;

typedef EnableValueCallback = bool Function(int index);

class _TabStyle extends AnimatedWidget {
  const _TabStyle({
    required Animation<double> animation,
    required this.isSelected,
    required this.isPrimary,
    required this.labelColor,
    required this.unselectedLabelColor,
    required this.labelStyle,
    required this.unselectedLabelStyle,
    required this.defaults,
    required this.child,
  }) : super(listenable: animation);

  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final bool isSelected;
  final bool isPrimary;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TabBarTheme defaults;
  final Widget child;

  MaterialStateColor _resolveWithLabelColor(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);
    final Animation<double> animation = listenable as Animation<double>;

    // labelStyle.color (and tabBarTheme.labelStyle.color) is not considered
    // as it'll be a breaking change without a possible migration plan. for
    // details: https://github.com/flutter/flutter/pull/109541#issuecomment-1294241417
    Color selectedColor = labelColor
        ?? tabBarTheme.labelColor
        ?? labelStyle?.color
        ?? tabBarTheme.labelStyle?.color
        ?? defaults.labelColor!;

    final Color unselectedColor;

    if (selectedColor is MaterialStateColor) {
      unselectedColor = selectedColor.resolve(const <MaterialState>{});
      selectedColor = selectedColor.resolve(const <MaterialState>{MaterialState.selected});
    } else {
      // unselectedLabelColor and tabBarTheme.unselectedLabelColor are ignored
      // when labelColor is a MaterialStateColor.
      unselectedColor = unselectedLabelColor
          ?? tabBarTheme.unselectedLabelColor
          ?? unselectedLabelStyle?.color
          ?? tabBarTheme.unselectedLabelStyle?.color
          ?? (themeData.useMaterial3
               ? defaults.unselectedLabelColor!
               : selectedColor.withAlpha(0xB2)); // 70% alpha
    }

    return MaterialStateColor.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return Color.lerp(selectedColor, unselectedColor, animation.value)!;
      }
      return Color.lerp(unselectedColor, selectedColor, animation.value)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);
    final Animation<double> animation = listenable as Animation<double>;

    final Set<MaterialState> states = isSelected
      ? const <MaterialState>{MaterialState.selected}
      : const <MaterialState>{};

    // To enable TextStyle.lerp(style1, style2, value), both styles must have
    // the same value of inherit. Force that to be inherit=true here.
    final TextStyle selectedStyle = (labelStyle
      ?? tabBarTheme.labelStyle
      ?? defaults.labelStyle!
    ).copyWith(inherit: true);
    final TextStyle unselectedStyle = (unselectedLabelStyle
      ?? tabBarTheme.unselectedLabelStyle
      ?? labelStyle
      ?? defaults.unselectedLabelStyle!
    ).copyWith(inherit: true);
    final TextStyle textStyle = isSelected
      ? TextStyle.lerp(selectedStyle, unselectedStyle, animation.value)!
      : TextStyle.lerp(unselectedStyle, selectedStyle, animation.value)!;
    final Color color = _resolveWithLabelColor(context).resolve(states);

    return DefaultTextStyle(
      style: textStyle.copyWith(color: color),
      child: IconTheme.merge(
        data: IconThemeData(
          size: 24.0,
          color: color,
        ),
        child: child,
      ),
    );
  }
}

typedef _LayoutCallback = void Function(List<double> xOffsets, TextDirection textDirection, double width);

class _TabLabelBarRenderer extends RenderFlex {
  _TabLabelBarRenderer({
    required super.direction,
    required super.mainAxisSize,
    required super.mainAxisAlignment,
    required super.crossAxisAlignment,
    required TextDirection super.textDirection,
    required super.verticalDirection,
    required this.onPerformLayout,
  });

  _LayoutCallback onPerformLayout;

  @override
  void performLayout() {
    super.performLayout();
    // xOffsets will contain childCount+1 values, giving the offsets of the
    // leading edge of the first tab as the first value, of the leading edge of
    // the each subsequent tab as each subsequent value, and of the trailing
    // edge of the last tab as the last value.
    RenderBox? child = firstChild;
    final List<double> xOffsets = <double>[];
    while (child != null) {
      final FlexParentData childParentData = child.parentData! as FlexParentData;
      xOffsets.add(childParentData.offset.dx);
      assert(child.parentData == childParentData);
      child = childParentData.nextSibling;
    }
    assert(textDirection != null);
    switch (textDirection!) {
      case TextDirection.rtl:
        xOffsets.insert(0, size.width);
      case TextDirection.ltr:
        xOffsets.add(size.width);
    }
    onPerformLayout(xOffsets, textDirection!, size.width);
  }
}

// This class and its renderer class only exist to report the widths of the tabs
// upon layout. The tab widths are only used at paint time (see _IndicatorPainter)
// or in response to input.
class _TabLabelBar extends Flex {
  const _TabLabelBar({
    super.children,
    required this.onPerformLayout,
    required super.mainAxisSize,
  }) : super(
    direction: Axis.horizontal,
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    verticalDirection: VerticalDirection.down,
  );

  final _LayoutCallback onPerformLayout;

  @override
  RenderFlex createRenderObject(BuildContext context) {
    return _TabLabelBarRenderer(
      direction: direction,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: getEffectiveTextDirection(context)!,
      verticalDirection: verticalDirection,
      onPerformLayout: onPerformLayout,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _TabLabelBarRenderer renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.onPerformLayout = onPerformLayout;
  }
}

double _indexChangeProgress(TabController controller) {
  final double controllerValue = controller.animation!.value;
  final double previousIndex = controller.previousIndex.toDouble();
  final double currentIndex = controller.index.toDouble();

  // The controller's offset is changing because the user is dragging the
  // TabBarView's PageView to the left or right.
  if (!controller.indexIsChanging) {
    return clampDouble((currentIndex - controllerValue).abs(), 0.0, 1.0);
  }

  // The TabController animation's value is changing from previousIndex to currentIndex.
  return (controllerValue - currentIndex).abs() / (currentIndex - previousIndex).abs();
}

class _DividerPainter extends CustomPainter {
  _DividerPainter({
    required this.dividerColor,
    required this.dividerHeight,
  });

  final Color dividerColor;
  final double dividerHeight;

  @override
  void paint(Canvas canvas, Size size) {
    if (dividerHeight <= 0.0) {
      return;
    }

    final Paint paint = Paint()
      ..color = dividerColor
      ..strokeWidth = dividerHeight;

    canvas.drawLine(
      Offset(0, size.height - (paint.strokeWidth / 2)),
      Offset(size.width, size.height - (paint.strokeWidth / 2)),
      paint,
    );
  }

  @override
  bool shouldRepaint(_DividerPainter oldDelegate) {
    return oldDelegate.dividerColor != dividerColor
      || oldDelegate.dividerHeight != dividerHeight;
  }
}

class _IndicatorPainter extends CustomPainter {
  _IndicatorPainter({
    required this.controller,
    required this.indicator,
    required this.indicatorSize,
    required this.tabKeys,
    required _IndicatorPainter? old,
    required this.indicatorPadding,
    required this.labelPaddings,
    this.dividerColor,
    this.dividerHeight,
    required this.showDivider,
  }) : super(repaint: controller.animation) {
    // TODO(polina-c): stop duplicating code across disposables
    // https://github.com/flutter/flutter/issues/137435
    if (kFlutterMemoryAllocationsEnabled) {
      FlutterMemoryAllocations.instance.dispatchObjectCreated(
        library: 'package:flutter/material.dart',
        className: '$_IndicatorPainter',
        object: this,
      );
    }
    if (old != null) {
      saveTabOffsets(old._currentTabOffsets, old._currentTextDirection);
    }
  }

  final TabController controller;
  final Decoration indicator;
  final TabBarIndicatorSize indicatorSize;
  final EdgeInsetsGeometry indicatorPadding;
  final List<GlobalKey> tabKeys;
  final List<EdgeInsetsGeometry> labelPaddings;
  final Color? dividerColor;
  final double? dividerHeight;
  final bool showDivider;

  // _currentTabOffsets and _currentTextDirection are set each time TabBar
  // layout is completed. These values can be null when TabBar contains no
  // tabs, since there are nothing to lay out.
  List<double>? _currentTabOffsets;
  TextDirection? _currentTextDirection;

  Rect? _currentRect;
  BoxPainter? _painter;
  bool _needsPaint = false;
  void markNeedsPaint() {
    _needsPaint = true;
  }

  void dispose() {
    if (kFlutterMemoryAllocationsEnabled) {
      FlutterMemoryAllocations.instance.dispatchObjectDisposed(object: this);
    }
    _painter?.dispose();
  }

  void saveTabOffsets(List<double>? tabOffsets, TextDirection? textDirection) {
    _currentTabOffsets = tabOffsets;
    _currentTextDirection = textDirection;
  }

  // _currentTabOffsets[index] is the offset of the start edge of the tab at index, and
  // _currentTabOffsets[_currentTabOffsets.length] is the end edge of the last tab.
  int get maxTabIndex => _currentTabOffsets!.length - 2;

  double centerOf(int tabIndex) {
    assert(_currentTabOffsets != null);
    assert(_currentTabOffsets!.isNotEmpty);
    assert(tabIndex >= 0);
    assert(tabIndex <= maxTabIndex);
    return (_currentTabOffsets![tabIndex] + _currentTabOffsets![tabIndex + 1]) / 2.0;
  }

  Rect indicatorRect(Size tabBarSize, int tabIndex) {
    assert(_currentTabOffsets != null);
    assert(_currentTextDirection != null);
    assert(_currentTabOffsets!.isNotEmpty);
    assert(tabIndex >= 0);
    assert(tabIndex <= maxTabIndex);
    double tabLeft, tabRight;
    (tabLeft, tabRight) = switch (_currentTextDirection!) {
      TextDirection.rtl => (_currentTabOffsets![tabIndex + 1], _currentTabOffsets![tabIndex]),
      TextDirection.ltr => (_currentTabOffsets![tabIndex], _currentTabOffsets![tabIndex + 1]),
    };

    if (indicatorSize == TabBarIndicatorSize.label) {
      final double tabWidth = tabKeys[tabIndex].currentContext!.size!.width;
      final EdgeInsetsGeometry labelPadding = labelPaddings[tabIndex];
      final EdgeInsets insets = labelPadding.resolve(_currentTextDirection);
      final double delta = ((tabRight - tabLeft) - (tabWidth + insets.horizontal)) / 2.0;
      tabLeft += delta + insets.left;
      tabRight = tabLeft + tabWidth;
    }

    final EdgeInsets insets = indicatorPadding.resolve(_currentTextDirection);
    final Rect rect = Rect.fromLTWH(tabLeft, 0.0, tabRight - tabLeft, tabBarSize.height);

    if (!(rect.size >= insets.collapsedSize)) {
      throw FlutterError(
        'indicatorPadding insets should be less than Tab Size\n'
        'Rect Size : ${rect.size}, Insets: $insets',
      );
    }
    return insets.deflateRect(rect);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _needsPaint = false;
    _painter ??= indicator.createBoxPainter(markNeedsPaint);

    final double index = controller.index.toDouble();
    final double value = controller.animation!.value;
    final bool ltr = index > value;
    final int from = (ltr ? value.floor() : value.ceil()).clamp(0, maxTabIndex);
    final int to = (ltr ? from + 1 : from - 1).clamp(0, maxTabIndex);
    final Rect fromRect = indicatorRect(size, from);
    final Rect toRect = indicatorRect(size, to);
    _currentRect = Rect.lerp(fromRect, toRect, (value - from).abs());

    _currentRect = switch (indicatorSize) {
      TabBarIndicatorSize.label => _applyStretchEffect(_currentRect!),
      // Do nothing.
      TabBarIndicatorSize.tab => _currentRect,
    };

    assert(_currentRect != null);

    final ImageConfiguration configuration = ImageConfiguration(
      size: _currentRect!.size,
      textDirection: _currentTextDirection,
    );
    if (showDivider && dividerHeight !> 0) {
      final Paint dividerPaint = Paint()..color = dividerColor!..strokeWidth = dividerHeight!;
      final Offset dividerP1 = Offset(0, size.height - (dividerPaint.strokeWidth / 2));
      final Offset dividerP2 = Offset(size.width, size.height - (dividerPaint.strokeWidth / 2));
      canvas.drawLine(dividerP1, dividerP2, dividerPaint);
    }
    _painter!.paint(canvas, _currentRect!.topLeft, configuration);
  }

  /// Applies the stretch effect to the indicator.
  Rect _applyStretchEffect(Rect rect) {
    // If the tab animation is completed, there is no need to stretch the indicator
    // This only works for the tab change animation via tab index, not when
    // dragging a [TabBarView], but it's still ok, to avoid unnecessary calculations.
    if (controller.animation!.status == AnimationStatus.completed) {
      return rect;
    }

    final double index = controller.index.toDouble();
    final double value = controller.animation!.value;

    // The progress of the animation from 0 to 1.
    late double tabChangeProgress;

    // If we are changing tabs via index, we want to map the progress between 0 and 1.
    if (controller.indexIsChanging) {
      double progressLeft = (index - value).abs();
      final int tabsDelta = (controller.index - controller.previousIndex).abs();
      if (tabsDelta != 0) {
        progressLeft /= tabsDelta;
      }
      tabChangeProgress = 1 - clampDouble(progressLeft, 0.0, 1.0);
    } else {
      // Otherwise, the progress is how close we are to the current tab.
      tabChangeProgress = (index - value).abs();
    }

    // If the animation has finished, there is no need to apply the stretch effect.
    if (tabChangeProgress == 1.0) {
      return rect;
    }

    // The maximum amount of extra width to add to the indicator.
    final double stretchSize = rect.width;

    final double inflationPerSide = stretchSize * _stretchAnimation.transform(tabChangeProgress) / 2;
    final Rect stretchedRect = _inflateRectHorizontally(rect, inflationPerSide);
    return stretchedRect;
  }

  /// The animatable that stretches the indicator horizontally when changing tabs.
  /// Value range is from 0 to 1, so we can multiply it by an stretch factor.
  ///
  /// Animation starts with no stretch, then quickly goes to the max stretch amount
  /// and then goes back to no stretch.
  late final Animatable<double> _stretchAnimation = TweenSequence<double>(
    <TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 1.0),
        weight: 20,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 1.0, end: 0.0),
        weight: 80,
      ),
    ],
  );

  /// Same as [Rect.inflate], but only inflates in the horizontal direction.
  Rect _inflateRectHorizontally(Rect r, double delta) {
    return Rect.fromLTRB(r.left - delta, r.top, r.right + delta, r.bottom);
  }

  @override
  bool shouldRepaint(_IndicatorPainter old) {
    return _needsPaint
        || controller != old.controller
        || indicator != old.indicator
        || tabKeys.length != old.tabKeys.length
        || (!listEquals(_currentTabOffsets, old._currentTabOffsets))
        || _currentTextDirection != old._currentTextDirection;
  }
}

class _ChangeAnimation extends Animation<double> with AnimationWithParentMixin<double> {
  _ChangeAnimation(this.controller);

  final TabController controller;

  @override
  Animation<double> get parent => controller.animation!;

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    if (controller.animation != null) {
      super.removeStatusListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    if (controller.animation != null) {
      super.removeListener(listener);
    }
  }

  @override
  double get value => _indexChangeProgress(controller);
}

class _DragAnimation extends Animation<double> with AnimationWithParentMixin<double> {
  _DragAnimation(this.controller, this.index);

  final TabController controller;
  final int index;

  @override
  Animation<double> get parent => controller.animation!;

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    if (controller.animation != null) {
      super.removeStatusListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    if (controller.animation != null) {
      super.removeListener(listener);
    }
  }

  @override
  double get value {
    assert(!controller.indexIsChanging);
    final double controllerMaxValue = (controller.length - 1).toDouble();
    final double controllerValue = clampDouble(controller.animation!.value, 0.0, controllerMaxValue);
    return clampDouble((controllerValue - index.toDouble()).abs(), 0.0, 1.0);
  }
}

// This class, and TabBarScrollController, only exist to handle the case
// where a scrollable TabBar has a non-zero initialIndex. In that case we can
// only compute the scroll position's initial scroll offset (the "correct"
// pixels value) after the TabBar viewport width and scroll limits are known.
class _TabBarScrollPosition extends ScrollPositionWithSingleContext {
  _TabBarScrollPosition({
    required super.physics,
    required super.context,
    required super.oldPosition,
    required this.tabBar,
  }) : super(
    initialPixels: null,
  );

  final _TolyTabBarState tabBar;

  bool _viewportDimensionWasNonZero = false;

  // The scroll position should be adjusted at least once.
  bool _needsPixelsCorrection = true;

  @override
  bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
    bool result = true;
    if (!_viewportDimensionWasNonZero) {
      _viewportDimensionWasNonZero = viewportDimension != 0.0;
    }
    // If the viewport never had a non-zero dimension, we just want to jump
    // to the initial scroll position to avoid strange scrolling effects in
    // release mode: the viewport temporarily may have a dimension of zero
    // before the actual dimension is calculated. In that scenario, setting
    // the actual dimension would cause a strange scroll effect without this
    // guard because the super call below would start a ballistic scroll activity.
    if (!_viewportDimensionWasNonZero || _needsPixelsCorrection) {
      _needsPixelsCorrection = false;
      correctPixels(tabBar._initialScrollOffset(viewportDimension, minScrollExtent, maxScrollExtent));
      result = false;
    }
    return super.applyContentDimensions(minScrollExtent, maxScrollExtent) && result;
  }

  void markNeedsPixelsCorrection() {
    _needsPixelsCorrection = true;
  }
}

// This class, and TabBarScrollPosition, only exist to handle the case
// where a scrollable TabBar has a non-zero initialIndex.
class _TabBarScrollController extends ScrollController {
  _TabBarScrollController(this.tabBar);

  final _TolyTabBarState tabBar;

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition? oldPosition) {
    return _TabBarScrollPosition(
      physics: physics,
      context: context,
      oldPosition: oldPosition,
      tabBar: tabBar,
    );
  }
}

/// A Material Design primary tab bar.
///
/// Primary tabs are placed at the top of the content pane under a top app bar.
/// They display the main content destinations.
///
/// Typically created as the [AppBar.bottom] part of an [AppBar] and in
/// conjunction with a [TabBarView].
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=POtoEH-5l40}
///
/// If a [TabController] is not provided, then a [DefaultTabController] ancestor
/// must be provided instead. The tab controller's [TabController.length] must
/// equal the length of the [tabs] list and the length of the
/// [TabBarView.children] list.
///
/// Requires one of its ancestors to be a [Material] widget.
///
/// Uses values from [TabBarTheme] if it is set in the current context.
///
/// {@tool dartpad}
/// This sample shows the implementation of [TolyTabBar] and [TabBarView] using a [DefaultTabController].
/// Each [Tab] corresponds to a child of the [TabBarView] in the order they are written.
///
/// ** See code in examples/api/lib/material/tabs/tab_bar.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// [TolyTabBar] can also be implemented by using a [TabController] which provides more options
/// to control the behavior of the [TolyTabBar] and [TabBarView]. This can be used instead of
/// a [DefaultTabController], demonstrated below.
///
/// ** See code in examples/api/lib/material/tabs/tab_bar.1.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample showcases nested Material 3 [TolyTabBar]s. It consists of a primary
/// [TolyTabBar] with nested a secondary [TolyTabBar]. The primary [TolyTabBar] uses a
/// [DefaultTabController] while the secondary [TolyTabBar] uses a [TabController].
///
/// ** See code in examples/api/lib/material/tabs/tab_bar.2.dart **
/// {@end-tool}
///
/// See also:
///
///  * [TabBar.secondary], for a secondary tab bar.
///  * [TabBarView], which displays page views that correspond to each tab.
///  * [TabController], which coordinates tab selection between a [TolyTabBar] and a [TabBarView].
///  * https://m3.material.io/components/tabs/overview, the Material 3
///     tab bar specification.
class TolyTabBar extends StatefulWidget implements PreferredSizeWidget {
  /// Creates a Material Design primary tab bar.
  ///
  /// The length of the [tabs] argument must match the [controller]'s
  /// [TabController.length].
  ///
  /// If a [TabController] is not provided, then there must be a
  /// [DefaultTabController] ancestor.
  ///
  /// The [indicatorWeight] parameter defaults to 2.
  ///
  /// The [indicatorPadding] parameter defaults to [EdgeInsets.zero].
  ///
  /// If [indicator] is not null or provided from [TabBarTheme],
  /// then [indicatorWeight] and [indicatorColor] are ignored.
  const TolyTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.showDivider = true,
    this.showIndicator = true,
    this.padding,
    this.indicatorColor,
    this.automaticIndicatorColorAdjustment = true,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicator,
    this.indicatorSize,
    this.dividerColor,
    this.dividerHeight,
    this.labelColor,
    this.labelStyle,
    this.labelPadding,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.overlayColor,
    this.mouseCursor,
    this.enableFeedback,
    this.onTap,
    this.physics,
    this.splashFactory,
    this.splashBorderRadius,
    this.tabAlignment,
  }) : _isPrimary = true,
       assert(indicator != null || (indicatorWeight > 0.0));

  /// Creates a Material Design secondary tab bar.
  ///
  /// Secondary tabs are used within a content area to further separate related
  /// content and establish hierarchy.
  ///
  /// {@tool dartpad}
  /// This sample showcases nested Material 3 [TolyTabBar]s. It consists of a primary
  /// [TolyTabBar] with nested a secondary [TolyTabBar]. The primary [TolyTabBar] uses a
  /// [DefaultTabController] while the secondary [TolyTabBar] uses a [TabController].
  ///
  /// ** See code in examples/api/lib/material/tabs/tab_bar.2.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [TolyTabBar], for a primary tab bar.
  ///  * [TabBarView], which displays page views that correspond to each tab.
  ///  * [TabController], which coordinates tab selection between a [TolyTabBar] and a [TabBarView].
  ///  * https://m3.material.io/components/tabs/overview, the Material 3
  ///     tab bar specification.
  const TolyTabBar.secondary({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable = false,
    this.showDivider = true,
    this.showIndicator = true,
    this.padding,
    this.indicatorColor,
    this.automaticIndicatorColorAdjustment = true,
    this.indicatorWeight = 2.0,
    this.indicatorPadding = EdgeInsets.zero,
    this.indicator,
    this.indicatorSize,
    this.dividerColor,
    this.dividerHeight,
    this.labelColor,
    this.labelStyle,
    this.labelPadding,
    this.unselectedLabelColor,
    this.unselectedLabelStyle,
    this.dragStartBehavior = DragStartBehavior.start,
    this.overlayColor,
    this.mouseCursor,
    this.enableFeedback,
    this.onTap,
    this.physics,
    this.splashFactory,
    this.splashBorderRadius,
    this.tabAlignment,
  }) : _isPrimary = false,
       assert(indicator != null || (indicatorWeight > 0.0));

  /// Typically a list of two or more [Tab] widgets.
  ///
  /// The length of this list must match the [controller]'s [TabController.length]
  /// and the length of the [TabBarView.children] list.
  final List<Widget> tabs;

  /// This widget's selection and animation state.
  ///
  /// If [TabController] is not provided, then the value of [DefaultTabController.of]
  /// will be used.
  final TabController? controller;

  /// Whether this tab bar can be scrolled horizontally.
  ///
  /// If [isScrollable] is true, then each tab is as wide as needed for its label
  /// and the entire [TolyTabBar] is scrollable. Otherwise each tab gets an equal
  /// share of the available space.
  final bool isScrollable;

  /// The amount of space by which to inset the tab bar.
  ///
  /// When [isScrollable] is false, this will yield the same result as if [TolyTabBar] was wrapped
  /// in a [Padding] widget. When [isScrollable] is true, the scrollable itself is inset,
  /// allowing the padding to scroll with the tab bar, rather than enclosing it.
  final EdgeInsetsGeometry? padding;

  /// The color of the line that appears below the selected tab.
  ///
  /// If this parameter is null, then the value of the Theme's indicatorColor
  /// property is used.
  ///
  /// If [indicator] is specified or provided from [TabBarTheme],
  /// this property is ignored.
  final Color? indicatorColor;

  /// The thickness of the line that appears below the selected tab.
  ///
  /// The value of this parameter must be greater than zero.
  ///
  /// If [ThemeData.useMaterial3] is true and [TolyTabBar] is used to create a
  /// primary tab bar, the default value is 3.0. If the provided value is less
  /// than 3.0, the default value is used.
  ///
  /// If [ThemeData.useMaterial3] is true and [TabBar.secondary] is used to
  /// create a secondary tab bar, the default value is 2.0.
  ///
  /// If [ThemeData.useMaterial3] is false, the default value is 2.0.
  ///
  /// If [indicator] is specified or provided from [TabBarTheme],
  /// this property is ignored.
  final double indicatorWeight;

  /// The padding for the indicator.
  ///
  /// The default value of this property is [EdgeInsets.zero].
  ///
  /// For [isScrollable] tab bars, specifying [kTabLabelPadding] will align
  /// the indicator with the tab's text for [Tab] widgets and all but the
  /// shortest [Tab.text] values.
  final EdgeInsetsGeometry indicatorPadding;

  /// Defines the appearance of the selected tab indicator.
  ///
  /// If [indicator] is specified or provided from [TabBarTheme],
  /// the [indicatorColor] and [indicatorWeight] properties are ignored.
  ///
  /// The default, underline-style, selected tab indicator can be defined with
  /// [UnderlineTabIndicator].
  ///
  /// The indicator's size is based on the tab's bounds. If [indicatorSize]
  /// is [TabBarIndicatorSize.tab] the tab's bounds are as wide as the space
  /// occupied by the tab in the tab bar. If [indicatorSize] is
  /// [TabBarIndicatorSize.label], then the tab's bounds are only as wide as
  /// the tab widget itself.
  ///
  /// See also:
  ///
  ///  * [splashBorderRadius], which defines the clipping radius of the splash
  ///    and is generally used with [BoxDecoration.borderRadius].
  final Decoration? indicator;
  final bool showDivider;
  final bool showIndicator;


  /// Whether this tab bar should automatically adjust the [indicatorColor].
  ///
  /// The default value of this property is true.
  ///
  /// If [automaticIndicatorColorAdjustment] is true,
  /// then the [indicatorColor] will be automatically adjusted to [Colors.white]
  /// when the [indicatorColor] is same as [Material.color] of the [Material]
  /// parent widget.
  final bool automaticIndicatorColorAdjustment;

  /// Defines how the selected tab indicator's size is computed.
  ///
  /// The size of the selected tab indicator is defined relative to the
  /// tab's overall bounds if [indicatorSize] is [TabBarIndicatorSize.tab]
  /// (the default) or relative to the bounds of the tab's widget if
  /// [indicatorSize] is [TabBarIndicatorSize.label].
  ///
  /// The selected tab's location appearance can be refined further with
  /// the [indicatorColor], [indicatorWeight], [indicatorPadding], and
  /// [indicator] properties.
  final TabBarIndicatorSize? indicatorSize;

  /// The color of the divider.
  ///
  /// If null and [ThemeData.useMaterial3] is false, [TabBarTheme.dividerColor]
  /// color is used. If that is null and [ThemeData.useMaterial3] is true,
  /// [ColorScheme.outlineVariant] will be used, otherwise divider will not be drawn.
  final Color? dividerColor;

  /// The height of the divider.
  ///
  /// If null and [ThemeData.useMaterial3] is true, [TabBarTheme.dividerHeight] is used.
  /// If that is also null and [ThemeData.useMaterial3] is true, 1.0 will be used.
  /// Otherwise divider will not be drawn.
  final double? dividerHeight;

  /// The color of selected tab labels.
  ///
  /// If null, then [TabBarTheme.labelColor] is used. If that is also null and
  /// [ThemeData.useMaterial3] is true, [ColorScheme.primary] will be used,
  /// otherwise the color of the [ThemeData.primaryTextTheme]'s
  /// [TextTheme.bodyLarge] text color is used.
  ///
  /// If [labelColor] (or, if null, [TabBarTheme.labelColor]) is a
  /// [MaterialStateColor], then the effective tab color will depend on the
  /// [MaterialState.selected] state, i.e. if the [Tab] is selected or not,
  /// ignoring [unselectedLabelColor] even if it's non-null.
  ///
  /// When this color or the [TabBarTheme.labelColor] is specified, it overrides
  /// the [TextStyle.color] specified for the [labelStyle] or the
  /// [TabBarTheme.labelStyle].
  ///
  /// See also:
  ///
  ///   * [unselectedLabelColor], for color of unselected tab labels.
  final Color? labelColor;

  /// The color of unselected tab labels.
  ///
  /// If [labelColor] (or, if null, [TabBarTheme.labelColor]) is a
  /// [MaterialStateColor], then the unselected tabs are rendered with
  /// that [MaterialStateColor]'s resolved color for unselected state, even if
  /// [unselectedLabelColor] is non-null.
  ///
  /// If null, then [TabBarTheme.unselectedLabelColor] is used. If that is also
  /// null and [ThemeData.useMaterial3] is true, [ColorScheme.onSurfaceVariant]
  /// will be used, otherwise unselected tab labels are rendered with
  /// [labelColor] at 70% opacity.
  ///
  /// When this color or the [TabBarTheme.unselectedLabelColor] is specified, it
  /// overrides the [TextStyle.color] specified for the [unselectedLabelStyle]
  /// or the [TabBarTheme.unselectedLabelStyle].
  ///
  /// See also:
  ///
  ///  * [labelColor], for color of selected tab labels.
  final Color? unselectedLabelColor;

  /// The text style of the selected tab labels.
  ///
  /// The color specified in [labelStyle] and [TabBarTheme.labelStyle] is used
  /// to style the label when [labelColor] or [TabBarTheme.labelColor] are not
  /// specified.
  ///
  /// If [unselectedLabelStyle] is null, then this text style will be used for
  /// both selected and unselected label styles.
  ///
  /// If this property is null, then [TabBarTheme.labelStyle] will be used.
  ///
  /// If that is also null and [ThemeData.useMaterial3] is true, [TextTheme.titleSmall]
  /// will be used, otherwise the text style of the [ThemeData.primaryTextTheme]'s
  /// [TextTheme.bodyLarge] definition is used.
  final TextStyle? labelStyle;

  /// The text style of the unselected tab labels.
  ///
  /// The color specified in [unselectedLabelStyle] and [TabBarTheme.unselectedLabelStyle]
  /// is used to style the label when [unselectedLabelColor] or [TabBarTheme.unselectedLabelColor]
  /// are not specified.
  ///
  /// If this property is null, then [TabBarTheme.unselectedLabelStyle] will be used.
  ///
  /// If that is also null and [ThemeData.useMaterial3] is true, [TextTheme.titleSmall]
  /// will be used, otherwise then the [labelStyle] value is used. If [labelStyle] is null,
  /// the text style of the [ThemeData.primaryTextTheme]'s [TextTheme.bodyLarge]
  /// definition is used.
  final TextStyle? unselectedLabelStyle;

  /// The padding added to each of the tab labels.
  ///
  /// If there are few tabs with both icon and text and few
  /// tabs with only icon or text, this padding is vertically
  /// adjusted to provide uniform padding to all tabs.
  ///
  /// If this property is null, then [kTabLabelPadding] is used.
  final EdgeInsetsGeometry? labelPadding;

  /// Defines the ink response focus, hover, and splash colors.
  ///
  /// If non-null, it is resolved against one of [MaterialState.focused],
  /// [MaterialState.hovered], and [MaterialState.pressed].
  ///
  /// [MaterialState.pressed] triggers a ripple (an ink splash), per
  /// the current Material Design spec.
  ///
  /// If the overlay color is null or resolves to null, then if [ThemeData.useMaterial3] is
  /// false, the default values for [InkResponse.focusColor], [InkResponse.hoverColor], [InkResponse.splashColor],
  /// and [InkResponse.highlightColor] will be used instead. If [ThemeData.useMaterial3]
  /// if true, the default values are:
  /// * selected:
  ///   * pressed - ThemeData.colorScheme.primary(0.1)
  ///   * hovered - ThemeData.colorScheme.primary(0.08)
  ///   * focused - ThemeData.colorScheme.primary(0.1)
  /// * pressed - ThemeData.colorScheme.primary(0.1)
  /// * hovered - ThemeData.colorScheme.onSurface(0.08)
  /// * focused - ThemeData.colorScheme.onSurface(0.1)
  final MaterialStateProperty<Color?>? overlayColor;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@template flutter.material.tabs.mouseCursor}
  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// individual tab widgets.
  ///
  /// If [mouseCursor] is a [MaterialStateProperty<MouseCursor>],
  /// [MaterialStateProperty.resolve] is used for the following [MaterialState]s:
  ///
  ///  * [MaterialState.selected].
  /// {@endtemplate}
  ///
  /// If null, then the value of [TabBarTheme.mouseCursor] is used. If
  /// that is also null, then [MaterialStateMouseCursor.clickable] is used.
  ///
  /// See also:
  ///
  ///  * [MaterialStateMouseCursor], which can be used to create a [MouseCursor]
  ///    that is also a [MaterialStateProperty<MouseCursor>].
  final MouseCursor? mouseCursor;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  ///
  /// For example, on Android a tap will produce a clicking sound and a long-press
  /// will produce a short vibration, when feedback is enabled.
  ///
  /// Defaults to true.
  final bool? enableFeedback;

  /// An optional callback that's called when the [TolyTabBar] is tapped.
  ///
  /// The callback is applied to the index of the tab where the tap occurred.
  ///
  /// This callback has no effect on the default handling of taps. It's for
  /// applications that want to do a little extra work when a tab is tapped,
  /// even if the tap doesn't change the TabController's index. TabBar [onTap]
  /// callbacks should not make changes to the TabController since that would
  /// interfere with the default tap handler.
  final EnableValueCallback? onTap;

  /// How the [TolyTabBar]'s scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics? physics;

  /// Creates the tab bar's [InkWell] splash factory, which defines
  /// the appearance of "ink" splashes that occur in response to taps.
  ///
  /// Use [NoSplash.splashFactory] to defeat ink splash rendering. For example
  /// to defeat both the splash and the hover/pressed overlay, but not the
  /// keyboard focused overlay:
  ///
  /// ```dart
  /// TabBar(
  ///   splashFactory: NoSplash.splashFactory,
  ///   overlayColor: MaterialStateProperty.resolveWith<Color?>(
  ///     (Set<MaterialState> states) {
  ///       return states.contains(MaterialState.focused) ? null : Colors.transparent;
  ///     },
  ///   ),
  ///   tabs: const <Widget>[
  ///     // ...
  ///   ],
  /// )
  /// ```
  final InteractiveInkFeatureFactory? splashFactory;

  /// Defines the clipping radius of splashes that extend outside the bounds of the tab.
  ///
  /// This can be useful to match the [BoxDecoration.borderRadius] provided as [indicator].
  ///
  /// ```dart
  /// TabBar(
  ///   indicator: BoxDecoration(
  ///     borderRadius: BorderRadius.circular(40),
  ///   ),
  ///   splashBorderRadius: BorderRadius.circular(40),
  ///   tabs: const <Widget>[
  ///     // ...
  ///   ],
  /// )
  /// ```
  ///
  /// If this property is null, it is interpreted as [BorderRadius.zero].
  final BorderRadius? splashBorderRadius;

  /// Specifies the horizontal alignment of the tabs within a [TolyTabBar].
  ///
  /// If [TolyTabBar.isScrollable] is false, only [TabAlignment.fill] and
  /// [TabAlignment.center] are supported. Otherwise an exception is thrown.
  ///
  /// If [TolyTabBar.isScrollable] is true, only [TabAlignment.start], [TabAlignment.startOffset],
  /// and [TabAlignment.center] are supported. Otherwise an exception is thrown.
  ///
  /// If this is null, then the value of [TabBarTheme.tabAlignment] is used.
  ///
  /// If [TabBarTheme.tabAlignment] is null and [ThemeData.useMaterial3] is true,
  /// then [TabAlignment.startOffset] is used if [isScrollable] is true,
  /// otherwise [TabAlignment.fill] is used.
  ///
  /// If [TabBarTheme.tabAlignment] is null and [ThemeData.useMaterial3] is false,
  /// then [TabAlignment.center] is used if [isScrollable] is true,
  /// otherwise [TabAlignment.fill] is used.
  final TabAlignment? tabAlignment;

  /// A size whose height depends on if the tabs have both icons and text.
  ///
  /// [AppBar] uses this size to compute its own preferred size.
  @override
  Size get preferredSize {
    double maxHeight = _kTabHeight;
    for (final Widget item in tabs) {
      if (item is PreferredSizeWidget) {
        final double itemHeight = item.preferredSize.height;
        maxHeight = math.max(itemHeight, maxHeight);
      }
    }
    return Size.fromHeight(maxHeight + indicatorWeight);
  }

  /// Returns whether the [TolyTabBar] contains a tab with both text and icon.
  ///
  /// [TolyTabBar] uses this to give uniform padding to all tabs in cases where
  /// there are some tabs with both text and icon and some which contain only
  /// text or icon.
  bool get tabHasTextAndIcon {
    for (final Widget item in tabs) {
      if (item is PreferredSizeWidget) {
        if (item.preferredSize.height == _kTextAndIconTabHeight) {
          return true;
        }
      }
    }
    return false;
  }

  /// Whether this tab bar is a primary tab bar.
  ///
  /// Otherwise, it is a secondary tab bar.
  final bool _isPrimary;

  @override
  State<TolyTabBar> createState() => _TolyTabBarState();
}

class _TolyTabBarState extends State<TolyTabBar> {
  ScrollController? _scrollController;
  TabController? _controller;
  _IndicatorPainter? _indicatorPainter;
  int? _currentIndex;
  late double _tabStripWidth;
  late List<GlobalKey> _tabKeys;
  late List<EdgeInsetsGeometry> _labelPaddings;
  bool _debugHasScheduledValidTabsCountCheck = false;

  @override
  void initState() {
    super.initState();
    // If indicatorSize is TabIndicatorSize.label, _tabKeys[i] is used to find
    // the width of tab widget i. See _IndicatorPainter.indicatorRect().
    _tabKeys = widget.tabs.map((Widget tab) => GlobalKey()).toList();
    _labelPaddings = List<EdgeInsetsGeometry>.filled(widget.tabs.length, EdgeInsets.zero, growable: true);
  }

  TabBarTheme get _defaults {
    if (Theme.of(context).useMaterial3) {
      return widget._isPrimary
        ? _TabsPrimaryDefaultsM3(context, widget.isScrollable)
        : _TabsSecondaryDefaultsM3(context, widget.isScrollable);
    } else {
      return _TabsDefaultsM2(context, widget.isScrollable);
    }
  }

  Decoration _getIndicator(TabBarIndicatorSize indicatorSize) {
    if(!widget.showIndicator) return const BoxDecoration();
    final ThemeData theme = Theme.of(context);
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);

    if (widget.indicator != null) {
      return widget.indicator!;
    }
    if (tabBarTheme.indicator != null) {
      return tabBarTheme.indicator!;
    }

    Color color = widget.indicatorColor ?? tabBarTheme.indicatorColor ?? _defaults.indicatorColor!;
    // ThemeData tries to avoid this by having indicatorColor avoid being the
    // primaryColor. However, it's possible that the tab bar is on a
    // Material that isn't the primaryColor. In that case, if the indicator
    // color ends up matching the material's color, then this overrides it.
    // When that happens, automatic transitions of the theme will likely look
    // ugly as the indicator color suddenly snaps to white at one end, but it's
    // not clear how to avoid that any further.
    //
    // The material's color might be null (if it's a transparency). In that case
    // there's no good way for us to find out what the color is so we don't.
    //
    // TODO(xu-baolin): Remove automatic adjustment to white color indicator
    // with a better long-term solution.
    // https://github.com/flutter/flutter/pull/68171#pullrequestreview-517753917
    if (widget.automaticIndicatorColorAdjustment &&
        color.value == Material.maybeOf(context)?.color?.value) {
      color = Colors.white;
    }

    final double effectiveIndicatorWeight = theme.useMaterial3
      ? math.max(
          widget.indicatorWeight,
          switch (widget._isPrimary) {
            true  => _TabsPrimaryDefaultsM3.indicatorWeight(indicatorSize),
            false => _TabsSecondaryDefaultsM3.indicatorWeight,
          },
        )
      : widget.indicatorWeight;
    // Only Material 3 primary TabBar with label indicatorSize should be rounded.
    final bool primaryWithLabelIndicator = switch (indicatorSize) {
      TabBarIndicatorSize.label  => widget._isPrimary,
      TabBarIndicatorSize.tab    => false,
    };
    final BorderRadius? effectiveBorderRadius = theme.useMaterial3 && primaryWithLabelIndicator
      ? BorderRadius.only(
          topLeft: Radius.circular(effectiveIndicatorWeight),
          topRight: Radius.circular(effectiveIndicatorWeight),
        )
      : null;
    return UnderlineTabIndicator(
      borderRadius: effectiveBorderRadius,
      borderSide: BorderSide(
        // TODO(tahatesser): Make sure this value matches Material 3 Tabs spec
        // when `preferredSize`and `indicatorWeight` are updated to support Material 3
        // https://m3.material.io/components/tabs/specs#149a189f-9039-4195-99da-15c205d20e30,
        // https://github.com/flutter/flutter/issues/116136
        width: effectiveIndicatorWeight,
        color: color,
      ),
    );
  }

  // If the TabBar is rebuilt with a new tab controller, the caller should
  // dispose the old one. In that case the old controller's animation will be
  // null and should not be accessed.
  bool get _controllerIsValid => _controller?.animation != null;

  void _updateTabController() {
    final TabController? newController = widget.controller ?? DefaultTabController.maybeOf(context);
    assert(() {
      if (newController == null) {
        throw FlutterError(
          'No TabController for ${widget.runtimeType}.\n'
          'When creating a ${widget.runtimeType}, you must either provide an explicit '
          'TabController using the "controller" property, or you must ensure that there '
          'is a DefaultTabController above the ${widget.runtimeType}.\n'
          'In this case, there was neither an explicit controller nor a default controller.',
        );
      }
      return true;
    }());

    if (newController == _controller) {
      return;
    }

    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
      _controller!.removeListener(_handleTabControllerTick);
    }
    _controller = newController;
    if (_controller != null) {
      _controller!.animation!.addListener(_handleTabControllerAnimationTick);
      _controller!.addListener(_handleTabControllerTick);
      _currentIndex = _controller!.index;
    }
  }

  void _initIndicatorPainter() {
    final ThemeData theme = Theme.of(context);
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);
    final TabBarIndicatorSize indicatorSize = widget.indicatorSize
      ?? tabBarTheme.indicatorSize
      ?? _defaults.indicatorSize!;

    final _IndicatorPainter? oldPainter = _indicatorPainter;

    _indicatorPainter = !_controllerIsValid ? null : _IndicatorPainter(
      controller: _controller!,
      indicator: _getIndicator(indicatorSize),
      indicatorSize: indicatorSize,
      indicatorPadding: widget.indicatorPadding,
      tabKeys: _tabKeys,
      // Passing old painter so that the constructor can copy some values from it.
      old: oldPainter,
      labelPaddings: _labelPaddings,
      dividerColor: widget.dividerColor ?? tabBarTheme.dividerColor ?? _defaults.dividerColor,
      dividerHeight: widget.dividerHeight ?? tabBarTheme.dividerHeight ?? _defaults.dividerHeight,
      showDivider: theme.useMaterial3 && !widget.isScrollable&& widget.showDivider,
    );

    oldPainter?.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterial(context));
    _updateTabController();
    _initIndicatorPainter();
  }

  @override
  void didUpdateWidget(TolyTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController();
      _initIndicatorPainter();
      // Adjust scroll position.
      if (_scrollController != null && _scrollController!.hasClients) {
        final ScrollPosition position = _scrollController!.position;
        if (position is _TabBarScrollPosition) {
          position.markNeedsPixelsCorrection();
        }
      }
    } else if (widget.indicatorColor != oldWidget.indicatorColor ||
        widget.indicatorWeight != oldWidget.indicatorWeight ||
        widget.indicatorSize != oldWidget.indicatorSize ||
        widget.indicatorPadding != oldWidget.indicatorPadding ||
        widget.indicator != oldWidget.indicator ||
        widget.dividerColor != oldWidget.dividerColor ||
        widget.showIndicator != oldWidget.showIndicator ||
        widget.dividerHeight != oldWidget.dividerHeight) {
      _initIndicatorPainter();
    }

    if (widget.tabs.length > _tabKeys.length) {
      final int delta = widget.tabs.length - _tabKeys.length;
      _tabKeys.addAll(List<GlobalKey>.generate(delta, (int n) => GlobalKey()));
      _labelPaddings.addAll(List<EdgeInsetsGeometry>.filled(delta, EdgeInsets.zero));
    } else if (widget.tabs.length < _tabKeys.length) {
      _tabKeys.removeRange(widget.tabs.length, _tabKeys.length);
      _labelPaddings.removeRange(widget.tabs.length, _tabKeys.length);
    }
  }

  @override
  void dispose() {
    _indicatorPainter!.dispose();
    if (_controllerIsValid) {
      _controller!.animation!.removeListener(_handleTabControllerAnimationTick);
      _controller!.removeListener(_handleTabControllerTick);
    }
    _controller = null;
    _scrollController?.dispose();
    // We don't own the _controller Animation, so it's not disposed here.
    super.dispose();
  }

  int get maxTabIndex => _indicatorPainter!.maxTabIndex;

  double _tabScrollOffset(int index, double viewportWidth, double minExtent, double maxExtent) {
    if (!widget.isScrollable) {
      return 0.0;
    }
    double tabCenter = _indicatorPainter!.centerOf(index);
    double paddingStart;
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        paddingStart = widget.padding?.resolve(TextDirection.rtl).right ?? 0;
        tabCenter = _tabStripWidth - tabCenter;
      case TextDirection.ltr:
        paddingStart = widget.padding?.resolve(TextDirection.ltr).left ?? 0;
    }

    return clampDouble(tabCenter + paddingStart - viewportWidth / 2.0, minExtent, maxExtent);
  }

  double _tabCenteredScrollOffset(int index) {
    final ScrollPosition position = _scrollController!.position;
    return _tabScrollOffset(index, position.viewportDimension, position.minScrollExtent, position.maxScrollExtent);
  }

  double _initialScrollOffset(double viewportWidth, double minExtent, double maxExtent) {
    return _tabScrollOffset(_currentIndex!, viewportWidth, minExtent, maxExtent);
  }

  void _scrollToCurrentIndex() {
    final double offset = _tabCenteredScrollOffset(_currentIndex!);
    _scrollController!.animateTo(offset, duration: kTabScrollDuration, curve: Curves.ease);
  }

  void _scrollToControllerValue() {
    final double? leadingPosition = _currentIndex! > 0 ? _tabCenteredScrollOffset(_currentIndex! - 1) : null;
    final double middlePosition = _tabCenteredScrollOffset(_currentIndex!);
    final double? trailingPosition = _currentIndex! < maxTabIndex ? _tabCenteredScrollOffset(_currentIndex! + 1) : null;

    final double index = _controller!.index.toDouble();
    final double value = _controller!.animation!.value;
    final double offset;
    if (value == index - 1.0) {
      offset = leadingPosition ?? middlePosition;
    } else if (value == index + 1.0) {
      offset = trailingPosition ?? middlePosition;
    } else if (value == index) {
      offset = middlePosition;
    } else if (value < index) {
      offset = leadingPosition == null ? middlePosition : lerpDouble(middlePosition, leadingPosition, index - value)!;
    } else {
      offset = trailingPosition == null ? middlePosition : lerpDouble(middlePosition, trailingPosition, value - index)!;
    }

    _scrollController!.jumpTo(offset);
  }

  void _handleTabControllerAnimationTick() {
    assert(mounted);
    if (!_controller!.indexIsChanging && widget.isScrollable) {
      // Sync the TabBar's scroll position with the TabBarView's PageView.
      _currentIndex = _controller!.index;
      _scrollToControllerValue();
    }
  }

  void _handleTabControllerTick() {
    if (_controller!.index != _currentIndex) {
      _currentIndex = _controller!.index;
      if (widget.isScrollable) {
        _scrollToCurrentIndex();
      }
    }
    setState(() {
      // Rebuild the tabs after a (potentially animated) index change
      // has completed.
    });
  }

  // Called each time layout completes.
  void _saveTabOffsets(List<double> tabOffsets, TextDirection textDirection, double width) {
    _tabStripWidth = width;
    _indicatorPainter?.saveTabOffsets(tabOffsets, textDirection);
  }

  void _handleTap(int index) {
    assert(index >= 0 && index < widget.tabs.length);
    bool enable = widget.onTap?.call(index)??false;
    if(enable){
      _controller!.animateTo(index);
    }
  }

  Widget _buildStyledTab(Widget child, bool isSelected, Animation<double> animation, TabBarTheme defaults) {
    return _TabStyle(
      animation: animation,
      isSelected: isSelected,
      isPrimary: widget._isPrimary,
      labelColor: widget.labelColor,
      unselectedLabelColor: widget.unselectedLabelColor,
      labelStyle: widget.labelStyle,
      unselectedLabelStyle: widget.unselectedLabelStyle,
      defaults: defaults,
      child: child,
    );
  }

  bool _debugScheduleCheckHasValidTabsCount() {
    if (_debugHasScheduledValidTabsCountCheck) {
      return true;
    }
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      _debugHasScheduledValidTabsCountCheck = false;
      if (!mounted) {
        return;
      }
      assert(() {
        if (_controller!.length != widget.tabs.length) {
          throw FlutterError(
            "Controller's length property (${_controller!.length}) does not match the "
            "number of tabs (${widget.tabs.length}) present in TabBar's tabs property.",
          );
        }
        return true;
      }());
    }, debugLabel: 'TabBar.tabsCountCheck');
    _debugHasScheduledValidTabsCountCheck = true;
    return true;
  }

  bool _debugTabAlignmentIsValid(TabAlignment tabAlignment) {
    assert(() {
      if (widget.isScrollable && tabAlignment == TabAlignment.fill) {
        throw FlutterError(
          '$tabAlignment is only valid for non-scrollable tab bars.',
        );
      }
      if (!widget.isScrollable
        && (tabAlignment == TabAlignment.start
          || tabAlignment == TabAlignment.startOffset)) {
        throw FlutterError(
          '$tabAlignment is only valid for scrollable tab bars.',
        );
      }
      return true;
    }());
    return true;
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    assert(_debugScheduleCheckHasValidTabsCount());
    final ThemeData theme = Theme.of(context);
    final TabBarThemeData tabBarTheme = TabBarTheme.of(context);
    final TabAlignment effectiveTabAlignment = widget.tabAlignment ?? tabBarTheme.tabAlignment ?? _defaults.tabAlignment!;
    assert(_debugTabAlignmentIsValid(effectiveTabAlignment));

    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    if (_controller!.length == 0) {
      return Container(
        height: _kTabHeight + widget.indicatorWeight,
      );
    }

    final List<Widget> wrappedTabs = List<Widget>.generate(widget.tabs.length, (int index) {
      const double verticalAdjustment = (_kTextAndIconTabHeight - _kTabHeight)/2.0;
      EdgeInsetsGeometry? adjustedPadding;

      if (widget.tabs[index] is PreferredSizeWidget) {
        final PreferredSizeWidget tab = widget.tabs[index] as PreferredSizeWidget;
        if (widget.tabHasTextAndIcon && tab.preferredSize.height == _kTabHeight) {
          if (widget.labelPadding != null || tabBarTheme.labelPadding != null) {
            adjustedPadding = (widget.labelPadding ?? tabBarTheme.labelPadding!).add(const EdgeInsets.symmetric(vertical: verticalAdjustment));
          }
          else {
            adjustedPadding = const EdgeInsets.symmetric(vertical: verticalAdjustment, horizontal: 16.0);
          }
        }
      }

      _labelPaddings[index] = adjustedPadding ?? widget.labelPadding ?? tabBarTheme.labelPadding ?? kTabLabelPadding;

      return Center(
        heightFactor: 1.0,
        child: Padding(
          padding: _labelPaddings[index],
          child: KeyedSubtree(
            key: _tabKeys[index],
            child: widget.tabs[index],
          ),
        ),
      );
    });

    // If the controller was provided by DefaultTabController and we're part
    // of a Hero (typically the AppBar), then we will not be able to find the
    // controller during a Hero transition. See https://github.com/flutter/flutter/issues/213.
    if (_controller != null) {
      final int previousIndex = _controller!.previousIndex;

      if (_controller!.indexIsChanging) {
        // The user tapped on a tab, the tab controller's animation is running.
        assert(_currentIndex != previousIndex);
        final Animation<double> animation = _ChangeAnimation(_controller!);
        wrappedTabs[_currentIndex!] = _buildStyledTab(wrappedTabs[_currentIndex!], true, animation, _defaults);
        wrappedTabs[previousIndex] = _buildStyledTab(wrappedTabs[previousIndex], false, animation, _defaults);
      } else {
        // The user is dragging the TabBarView's PageView left or right.
        final int tabIndex = _currentIndex!;
        final Animation<double> centerAnimation = _DragAnimation(_controller!, tabIndex);
        wrappedTabs[tabIndex] = _buildStyledTab(wrappedTabs[tabIndex], true, centerAnimation, _defaults);
        if (_currentIndex! > 0) {
          final int tabIndex = _currentIndex! - 1;
          final Animation<double> previousAnimation = ReverseAnimation(_DragAnimation(_controller!, tabIndex));
          wrappedTabs[tabIndex] = _buildStyledTab(wrappedTabs[tabIndex], false, previousAnimation, _defaults);
        }
        if (_currentIndex! < widget.tabs.length - 1) {
          final int tabIndex = _currentIndex! + 1;
          final Animation<double> nextAnimation = ReverseAnimation(_DragAnimation(_controller!, tabIndex));
          wrappedTabs[tabIndex] = _buildStyledTab(wrappedTabs[tabIndex], false, nextAnimation, _defaults);
        }
      }
    }

    // Add the tap handler to each tab. If the tab bar is not scrollable,
    // then give all of the tabs equal flexibility so that they each occupy
    // the same share of the tab bar's overall width.
    final int tabCount = widget.tabs.length;
    for (int index = 0; index < tabCount; index += 1) {
      final Set<MaterialState> selectedState = <MaterialState>{
        if (index == _currentIndex) MaterialState.selected,
      };

      final MouseCursor effectiveMouseCursor = MaterialStateProperty.resolveAs<MouseCursor?>(widget.mouseCursor, selectedState)
        ?? tabBarTheme.mouseCursor?.resolve(selectedState)
        ?? MaterialStateMouseCursor.clickable.resolve(selectedState);

      final MaterialStateProperty<Color?> defaultOverlay = MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          final Set<MaterialState> effectiveStates = selectedState..addAll(states);
          return _defaults.overlayColor?.resolve(effectiveStates);
        },
      );
      wrappedTabs[index] = InkWell(
        mouseCursor: effectiveMouseCursor,
        onTap: () { _handleTap(index); },
        enableFeedback: widget.enableFeedback ?? true,
        overlayColor: widget.overlayColor ?? tabBarTheme.overlayColor ?? defaultOverlay,
        splashFactory: widget.splashFactory ?? tabBarTheme.splashFactory ?? _defaults.splashFactory,
        borderRadius: widget.splashBorderRadius,
        child: Padding(
          padding: EdgeInsets.only(bottom: widget.indicatorWeight),
          child: Stack(
            children: <Widget>[
              wrappedTabs[index],
              Semantics(
                selected: index == _currentIndex,
                label: localizations.tabLabel(tabIndex: index + 1, tabCount: tabCount),
              ),
            ],
          ),
        ),
      );
      if (!widget.isScrollable && effectiveTabAlignment == TabAlignment.fill) {
        wrappedTabs[index] = Expanded(child: wrappedTabs[index]);
      }
    }

    Widget tabBar = CustomPaint(
      painter: _indicatorPainter,
      child: _TabStyle(
        animation: kAlwaysDismissedAnimation,
        isSelected: false,
        isPrimary: widget._isPrimary,
        labelColor: widget.labelColor,
        unselectedLabelColor: widget.unselectedLabelColor,
        labelStyle: widget.labelStyle,
        unselectedLabelStyle: widget.unselectedLabelStyle,
        defaults: _defaults,
        child: _TabLabelBar(
          onPerformLayout: _saveTabOffsets,
          mainAxisSize: effectiveTabAlignment == TabAlignment.fill ? MainAxisSize.max : MainAxisSize.min,
          children: wrappedTabs,
        ),
      ),
    );

    if (widget.isScrollable) {
      final EdgeInsetsGeometry? effectivePadding = effectiveTabAlignment == TabAlignment.startOffset
        ? const EdgeInsetsDirectional.only(start: _kStartOffset).add(widget.padding ?? EdgeInsets.zero)
        : widget.padding;
      _scrollController ??= _TabBarScrollController(this);
      tabBar = ScrollConfiguration(
        // The scrolling tabs should not show an overscroll indicator.
        behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
        child: SingleChildScrollView(
          dragStartBehavior: widget.dragStartBehavior,
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          padding: effectivePadding,
          physics: widget.physics,
          child: tabBar,
        ),
      );
      if (theme.useMaterial3) {
        final AlignmentGeometry effectiveAlignment = switch (effectiveTabAlignment) {
          TabAlignment.center => Alignment.center,
          TabAlignment.start || TabAlignment.startOffset || TabAlignment.fill => AlignmentDirectional.centerStart,
        };

        final Color dividerColor = widget.dividerColor ?? tabBarTheme.dividerColor ?? _defaults.dividerColor!;
        final double dividerHeight = widget.dividerHeight ?? tabBarTheme.dividerHeight ?? _defaults.dividerHeight!;
        final bool showDivider = dividerColor != Colors.transparent && dividerHeight > 0;

        tabBar = Align(
          heightFactor: 1.0,
          widthFactor: showDivider ? null : 1.0,
          alignment: effectiveAlignment,
          child: tabBar,
        );

        if (showDivider&&widget.showDivider) {
          tabBar = CustomPaint(
            painter: _DividerPainter(
              dividerColor: widget.dividerColor ?? tabBarTheme.dividerColor ?? _defaults.dividerColor!,
              dividerHeight: widget.dividerHeight ?? tabBarTheme.dividerHeight ?? _defaults.dividerHeight!,
            ),
            child: tabBar,
          );
        }
      }
    } else if (widget.padding != null) {
      tabBar = Padding(
        padding: widget.padding!,
        child: tabBar,
      );
    }

    return tabBar;
  }
}

/// Displays a single circle with the specified size, border style, border color
/// and background colors.
///
/// Used by [TabPageSelector] to indicate the selected page.
class TabPageSelectorIndicator extends StatelessWidget {
  /// Creates an indicator used by [TabPageSelector].
  const TabPageSelectorIndicator({
    super.key,
    required this.backgroundColor,
    required this.borderColor,
    required this.size,
    this.borderStyle = BorderStyle.solid,
  });

  /// The indicator circle's background color.
  final Color backgroundColor;

  /// The indicator circle's border color.
  final Color borderColor;

  /// The indicator circle's diameter.
  final double size;

  /// The indicator circle's border style.
  ///
  /// Defaults to [BorderStyle.solid] if value is not specified.
  final BorderStyle borderStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, style: borderStyle),
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Uses [TabPageSelectorIndicator] to display a row of small circular
/// indicators, one per tab.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=Q628ue9Cq7U}
///
/// The selected tab's indicator is highlighted. Often used in conjunction with
/// a [TabBarView].
///
/// If a [TabController] is not provided, then there must be a
/// [DefaultTabController] ancestor.
class TabPageSelector extends StatelessWidget {
  /// Creates a compact widget that indicates which tab has been selected.
  const TabPageSelector({
    super.key,
    this.controller,
    this.indicatorSize = 12.0,
    this.color,
    this.selectedColor,
    this.borderStyle,
  }) : assert(indicatorSize > 0.0);

  /// This widget's selection and animation state.
  ///
  /// If [TabController] is not provided, then the value of
  /// [DefaultTabController.of] will be used.
  final TabController? controller;

  /// The indicator circle's diameter (the default value is 12.0).
  final double indicatorSize;

  /// The indicator circle's fill color for unselected pages.
  ///
  /// If this parameter is null, then the indicator is filled with [Colors.transparent].
  final Color? color;

  /// The indicator circle's fill color for selected pages and border color
  /// for all indicator circles.
  ///
  /// If this parameter is null, then the indicator is filled with the theme's
  /// [ColorScheme.secondary].
  final Color? selectedColor;

  /// The indicator circle's border style.
  ///
  /// Defaults to [BorderStyle.solid] if value is not specified.
  final BorderStyle? borderStyle;

  Widget _buildTabIndicator(
    int tabIndex,
    TabController tabController,
    ColorTween selectedColorTween,
    ColorTween previousColorTween,
  ) {
    final Color background;
    if (tabController.indexIsChanging) {
      // The selection's animation is animating from previousValue to value.
      final double t = 1.0 - _indexChangeProgress(tabController);
      if (tabController.index == tabIndex) {
        background = selectedColorTween.lerp(t)!;
      } else if (tabController.previousIndex == tabIndex) {
        background = previousColorTween.lerp(t)!;
      } else {
        background = selectedColorTween.begin!;
      }
    } else {
      // The selection's offset reflects how far the TabBarView has / been dragged
      // to the previous page (-1.0 to 0.0) or the next page (0.0 to 1.0).
      final double offset = tabController.offset;
      if (tabController.index == tabIndex) {
        background = selectedColorTween.lerp(1.0 - offset.abs())!;
      } else if (tabController.index == tabIndex - 1 && offset > 0.0) {
        background = selectedColorTween.lerp(offset)!;
      } else if (tabController.index == tabIndex + 1 && offset < 0.0) {
        background = selectedColorTween.lerp(-offset)!;
      } else {
        background = selectedColorTween.begin!;
      }
    }
    return TabPageSelectorIndicator(
      backgroundColor: background,
      borderColor: selectedColorTween.end!,
      size: indicatorSize,
      borderStyle: borderStyle ?? BorderStyle.solid,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color fixColor = color ?? Colors.transparent;
    final Color fixSelectedColor = selectedColor ?? Theme.of(context).colorScheme.secondary;
    final ColorTween selectedColorTween = ColorTween(begin: fixColor, end: fixSelectedColor);
    final ColorTween previousColorTween = ColorTween(begin: fixSelectedColor, end: fixColor);
    final TabController? tabController = controller ?? DefaultTabController.maybeOf(context);
	  final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    assert(() {
      if (tabController == null) {
        throw FlutterError(
          'No TabController for $runtimeType.\n'
          'When creating a $runtimeType, you must either provide an explicit TabController '
          'using the "controller" property, or you must ensure that there is a '
          'DefaultTabController above the $runtimeType.\n'
          'In this case, there was neither an explicit controller nor a default controller.',
        );
      }
      return true;
    }());
    final Animation<double> animation = CurvedAnimation(
      parent: tabController!.animation!,
      curve: Curves.fastOutSlowIn,
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Semantics(
          label: localizations.tabLabel(tabIndex: tabController.index + 1, tabCount: tabController.length),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List<Widget>.generate(tabController.length, (int tabIndex) {
              return _buildTabIndicator(tabIndex, tabController, selectedColorTween, previousColorTween);
            }).toList(),
          ),
        );
      },
    );
  }
}

// Hand coded defaults based on Material Design 2.
class _TabsDefaultsM2 extends TabBarTheme {
  const _TabsDefaultsM2(this.context, this.isScrollable)
    : super(indicatorSize: TabBarIndicatorSize.tab);

  final BuildContext context;
  final bool isScrollable;

  @override
  Color? get indicatorColor => Theme.of(context).indicatorColor;

  @override
  Color? get labelColor => Theme.of(context).primaryTextTheme.bodyLarge!.color!;

  @override
  TextStyle? get labelStyle => Theme.of(context).primaryTextTheme.bodyLarge;

  @override
  TextStyle? get unselectedLabelStyle => Theme.of(context).primaryTextTheme.bodyLarge;

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;

  @override
  TabAlignment? get tabAlignment => isScrollable ? TabAlignment.start : TabAlignment.fill;

  // static const EdgeInsetsGeometry iconMargin = EdgeInsets.only(bottom: 10);
}

// BEGIN GENERATED TOKEN PROPERTIES - Tabs

// Do not edit by hand. The code between the "BEGIN GENERATED" and
// "END GENERATED" comments are generated from data in the Material
// Design token database by the script:
//   dev/tools/gen_defaults/bin/gen_defaults.dart.

class _TabsPrimaryDefaultsM3 extends TabBarTheme {
  _TabsPrimaryDefaultsM3(this.context, this.isScrollable)
    : super(indicatorSize: TabBarIndicatorSize.label);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;
  final bool isScrollable;

  // This value comes from Divider widget defaults. Token db deprecated 'primary-navigation-tab.divider.color' token.
  @override
  Color? get dividerColor => _colors.outlineVariant;

  // This value comes from Divider widget defaults. Token db deprecated 'primary-navigation-tab.divider.height' token.
  @override
  double? get dividerHeight => 1.0;

  @override
  Color? get indicatorColor => _colors.primary;

  @override
  Color? get labelColor => _colors.primary;

  @override
  TextStyle? get labelStyle => _textTheme.titleSmall;

  @override
  Color? get unselectedLabelColor => _colors.onSurfaceVariant;

  @override
  TextStyle? get unselectedLabelStyle => _textTheme.titleSmall;

  @override
  MaterialStateProperty<Color?> get overlayColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        if (states.contains(MaterialState.pressed)) {
          return _colors.primary.withOpacity(0.1);
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.primary.withOpacity(0.08);
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.primary.withOpacity(0.1);
        }
        return null;
      }
      if (states.contains(MaterialState.pressed)) {
        return _colors.primary.withOpacity(0.1);
      }
      if (states.contains(MaterialState.hovered)) {
        return _colors.onSurface.withOpacity(0.08);
      }
      if (states.contains(MaterialState.focused)) {
        return _colors.onSurface.withOpacity(0.1);
      }
      return null;
    });
  }

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;

  @override
  TabAlignment? get tabAlignment => isScrollable ? TabAlignment.startOffset : TabAlignment.fill;

  static double indicatorWeight(TabBarIndicatorSize indicatorSize) {
    return switch (indicatorSize) {
      TabBarIndicatorSize.label => 3.0,
      TabBarIndicatorSize.tab => 2.0,
    };
  }

  // TODO(davidmartos96): This value doesn't currently exist in
  // https://m3.material.io/components/tabs/specs
  // Update this when the token is available.
  // static const EdgeInsetsGeometry iconMargin = EdgeInsets.only(bottom: 2);
}

class _TabsSecondaryDefaultsM3 extends TabBarTheme {
  _TabsSecondaryDefaultsM3(this.context, this.isScrollable)
    : super(indicatorSize: TabBarIndicatorSize.tab);

  final BuildContext context;
  late final ColorScheme _colors = Theme.of(context).colorScheme;
  late final TextTheme _textTheme = Theme.of(context).textTheme;
  final bool isScrollable;

  // This value comes from Divider widget defaults. Token db deprecated 'secondary-navigation-tab.divider.color' token.
  @override
  Color? get dividerColor => _colors.outlineVariant;

  // This value comes from Divider widget defaults. Token db deprecated 'secondary-navigation-tab.divider.height' token.
  @override
  double? get dividerHeight => 1.0;

  @override
  Color? get indicatorColor => _colors.primary;

  @override
  Color? get labelColor => _colors.onSurface;

  @override
  TextStyle? get labelStyle => _textTheme.titleSmall;

  @override
  Color? get unselectedLabelColor => _colors.onSurfaceVariant;

  @override
  TextStyle? get unselectedLabelStyle => _textTheme.titleSmall;

  @override
  MaterialStateProperty<Color?> get overlayColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        if (states.contains(MaterialState.pressed)) {
          return _colors.onSurface.withOpacity(0.1);
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.onSurface.withOpacity(0.08);
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.onSurface.withOpacity(0.1);
        }
        return null;
      }
      if (states.contains(MaterialState.pressed)) {
        return _colors.onSurface.withOpacity(0.1);
      }
      if (states.contains(MaterialState.hovered)) {
        return _colors.onSurface.withOpacity(0.08);
      }
      if (states.contains(MaterialState.focused)) {
        return _colors.onSurface.withOpacity(0.1);
      }
      return null;
    });
  }

  @override
  InteractiveInkFeatureFactory? get splashFactory => Theme.of(context).splashFactory;

  @override
  TabAlignment? get tabAlignment => isScrollable ? TabAlignment.startOffset : TabAlignment.fill;

  static double indicatorWeight = 2.0;
}

// END GENERATED TOKEN PROPERTIES - Tabs
