// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-25
// Contact Me:  1981462002@qq.com

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tolyui/tolyui.dart';

class TolyTabs extends StatefulWidget {
  final List<MenuMeta> tabs;
  final String activeId;
  final ValueChanged<MenuMeta> onSelect;
  final EdgeInsetsGeometry indicatorPadding;

  const TolyTabs({
    super.key,
    required this.tabs,
    required this.activeId,
    required this.onSelect,
    this.indicatorPadding = EdgeInsets.zero,

  });

  @override
  State<TolyTabs> createState() => _TolyTabsState();
}

class _TolyTabsState extends State<TolyTabs> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  ValueNotifier<int?> index =ValueNotifier(null);
  late double _tabStripWidth;
  late List<GlobalKey> _tabKeys;
  late List<EdgeInsetsGeometry> _labelPaddings;

  @override
  void initState() {
    super.initState();
    _tabKeys = widget.tabs.map((MenuMeta tab) => GlobalKey()).toList();
    _labelPaddings = List<EdgeInsetsGeometry>.filled(widget.tabs.length, EdgeInsets.zero, growable: true);
    controller = AnimationController(vsync: this,duration: Duration(milliseconds: 300));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    assert(debugCheckHasMaterial(context));
    _initIndicatorPainter();
  }

  TabIndicatorPainter? _indicatorPainter;

  bool get _controllerIsValid => true;

  void _initIndicatorPainter() {
    Color? dividerColor = Theme.of(context).dividerTheme.color;
    double? space = Theme.of(context).dividerTheme.space;
    final TabIndicatorPainter? oldPainter = _indicatorPainter;
    _indicatorPainter = !_controllerIsValid
        ? null
        : TabIndicatorPainter(
      animation: controller,
      activeIndex: index,
      indicatorPadding: widget.indicatorPadding,
           labelPaddings: _labelPaddings,
            // controller: _controller!,
            tabKeys: _tabKeys,
            indicatorSize: TabBarIndicatorSize.tab,
            // Passing old painter so that the constructor can copy some values from it.
            old: oldPainter,
            dividerColor: dividerColor,
            dividerHeight: space,
            showDivider: true,
          );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      // color: Colors.blue.withOpacity(0.1),
      color: Colors.transparent,
      child: CustomPaint(
        painter: _indicatorPainter,
        child: _TabCellsBar(
          mainAxisSize: MainAxisSize.max,
          onPerformLayout: _saveTabOffsets,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: widget.tabs.asMap().keys.map(_buildItem).toList(),
          // scrollDirection: Axis.horizontal,
          // itemBuilder: _buildItem,
          // itemCount: tabs.length,
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    MenuMeta menu = widget.tabs[index];
    bool active = menu.id == widget.activeId;

    return KeyedSubtree(
      key: _tabKeys[index],
      child: GestureDetector(
        onTap: () {
          widget.onSelect(menu);
          controller.forward(from: 0);
          this.index.value = index;
        },
        child: TolyUITabItem(
          active: active,
          menu: menu,
          isFirst: index == 0,
          isLast: index == widget.tabs.length - 1,
        ),
      ),
    );
  }

  void _saveTabOffsets(
      List<double> xOffsets, TextDirection textDirection, double width) {
    print('====${xOffsets}===${textDirection}=======${width}=======');
    _indicatorPainter?.saveTabOffsets(xOffsets,textDirection);
  }
}

class TolyUITabItem extends StatefulWidget {
  final bool active;
  final MenuMeta menu;
  final bool isFirst;
  final bool isLast;

  const TolyUITabItem({
    super.key,
    required this.active,
    required this.menu,
    required this.isFirst,
    required this.isLast,
  });

  @override
  State<TolyUITabItem> createState() => _TolyUITabItemState();
}

class _TolyUITabItemState extends State<TolyUITabItem> with HoverActionMix {
  @override
  Widget build(BuildContext context) {
    Color? color = widget.active ? Theme.of(context).primaryColor : null;
    FontWeight? fontWeight = widget.active ? FontWeight.bold : null;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Padding(
        padding: EdgeInsets.only(
            left: widget.isFirst ? 0 : 8.0,
            right: widget.isLast ? 0 : 8,
            top: 4,
            bottom: 4 + 8),
        child: Text(
          '${widget.menu.label}',
          style: TextStyle(color: color, fontWeight: fontWeight),
        ),
      ),
    );
  }
}

class TabIndicatorPainter extends CustomPainter {
  final Color? dividerColor;
  final Animation<double> animation;
  final ValueListenable<int?> activeIndex;
  final double? dividerHeight;
  final bool showDivider;
  final List<GlobalKey> tabKeys;
  final List<EdgeInsetsGeometry> labelPaddings;
  final EdgeInsetsGeometry indicatorPadding;

  // final TabController controller;


  TabIndicatorPainter({
    required this.tabKeys,
    required this.indicatorSize,
    required this.animation,
    required this.labelPaddings,
    required this.indicatorPadding,
    required this.activeIndex,
    required TabIndicatorPainter? old,
    this.dividerColor,
    this.dividerHeight,
    required this.showDivider,
  }):super(repaint: Listenable.merge([animation,activeIndex])) {
    if (old != null) {
      saveTabOffsets(old._currentTabOffsets, old._currentTextDirection);
    }
  }

  // _currentTabOffsets and _currentTextDirection are set each time TabBar
  // layout is completed. These values can be null when TabBar contains no
  // tabs, since there are nothing to lay out.
  List<double>? _currentTabOffsets;
  TextDirection? _currentTextDirection;

  void saveTabOffsets(List<double>? tabOffsets, TextDirection? textDirection) {
    _currentTabOffsets = tabOffsets;
    _currentTextDirection = textDirection;
  }

  Rect? _currentRect;



  @override
  void paint(Canvas canvas, Size size) {

    final int index = activeIndex.value??0;
    final double value = animation.value;
    final bool ltr = index > value;
    final int from = (ltr ? value.floor() : value.ceil()).clamp(0, maxTabIndex);
    final int to = (ltr ? from + 1 : from - 1).clamp(0, maxTabIndex);
    print("====${from}=======${to}=====${activeIndex.value}====");

    final Rect fromRect = indicatorRect(size, from);
    final Rect toRect = indicatorRect(size, to);
    _currentRect = Rect.lerp(fromRect, toRect, (value - from).abs());

    _currentRect = switch (indicatorSize) {
      TabBarIndicatorSize.label => _currentRect,
    // Do nothing.
      TabBarIndicatorSize.tab => _currentRect,
    };


    if (showDivider && dividerHeight! > 0) {
      final Paint dividerPaint = Paint()
        ..color = dividerColor!
        ..strokeWidth = dividerHeight!;
      final Offset dividerP1 =
          Offset(0, size.height - (dividerPaint.strokeWidth / 2));
      final Offset dividerP2 =
          Offset(size.width, size.height - (dividerPaint.strokeWidth / 2));
      canvas.drawLine(dividerP1, dividerP2, dividerPaint);
    }

    canvas.drawRect(Rect.fromPoints(_currentRect!.topLeft.translate(0, size.height-3), _currentRect!.bottomRight), Paint()..color=Colors.black);

  }

  int get maxTabIndex => _currentTabOffsets!.length - 2;
  final TabBarIndicatorSize indicatorSize;

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
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

typedef _TabCellLayoutCallback = void Function(
  List<double> xOffsets,
  TextDirection textDirection,
  double width,
);

class _TabCellsBar extends Flex {
  const _TabCellsBar({
    super.children,
    required this.onPerformLayout,
    required super.mainAxisSize,
    super.mainAxisAlignment = MainAxisAlignment.start,
  }) : super(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
        );

  final _TabCellLayoutCallback onPerformLayout;

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
  void updateRenderObject(
      BuildContext context, _TabLabelBarRenderer renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject.onPerformLayout = onPerformLayout;
  }
}

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

  _TabCellLayoutCallback onPerformLayout;

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
      final FlexParentData childParentData =
          child.parentData! as FlexParentData;
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
