// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-25
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';
import 'package:tolyui_navigation/src/tabs/flutter_tab_bar.dart';

import '../../tolyui_navigation.dart';

class TolyTabs extends StatefulWidget {
  final Widget? leading;
  final Widget? tail;
  final List<MenuMeta> tabs;
  final String activeId;
  final TabCellBuilder? cellBuilder;
  final bool showDivider;
  final bool showIndicator;
  final bool closeable;
  final TabAlignment alignment;
  final TabBarIndicatorSize indicatorSize;
  final double? indicatorWeight;
  final double? dividerHeight;
  final EdgeInsetsGeometry? indicatorPadding;
  final EdgeInsetsGeometry? labelPadding;
  final ValueChanged<MenuMeta> onSelect;

  const TolyTabs({
    super.key,
    required this.tabs,
    required this.activeId,
    this.showDivider = true,
    this.dividerHeight,
    this.showIndicator = true,
    this.closeable = false,
    this.cellBuilder,
    this.indicatorSize = TabBarIndicatorSize.label,
    this.tail,
    this.leading,
    this.indicatorPadding,
    this.indicatorWeight,
    this.alignment = TabAlignment.start,
    this.labelPadding = const EdgeInsets.only(left: 10, right: 10, bottom: 12),
    required this.onSelect,
  });

  @override
  State<TolyTabs> createState() => _TolyTabsState();
}

class _TolyTabsState extends State<TolyTabs> with TickerProviderStateMixin {
  TabController? controller;
  bool _noMatch = false;

  @override
  void initState() {
    super.initState();
    initController(0);
    _updateActive();
  }

  void initController(int initialIndex) {
    if (controller != null) {
      controller?.dispose();
      controller = null;
    }
    controller = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: initialIndex,
    );
  }

  @override
  void didUpdateWidget(covariant TolyTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabs.length != widget.tabs.length) {
      int activeIndex = widget.tabs.indexWhere((e) => e.id == widget.activeId);
      _noMatch = activeIndex == -1;
      if(!_noMatch){
        initController(activeIndex);
      }
    }
    
    if(widget.activeId!=oldWidget.activeId){
      _updateActive();
    }
  }

  void _updateActive(){
    int activeIndex = widget.tabs.indexWhere((e) => e.id == widget.activeId);

    _noMatch = activeIndex == -1;
    print("======_updateActive==${activeIndex}====${_noMatch}=====");

    if(!_noMatch){
      controller?.animateTo(activeIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool showIndicator = !_noMatch&&widget.showIndicator;
    print("======build======${showIndicator}=====");

    bool showExt = widget.leading != null || widget.tail != null;
    Widget tab = TolyTabBar(
        showIndicator: !_noMatch&&widget.showIndicator,
        showDivider: widget.showDivider && !showExt,
        labelPadding: widget.labelPadding,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabAlignment: widget.alignment,
        indicatorSize: widget.indicatorSize,
        indicatorWeight: widget.indicatorWeight ?? 2.0,
        indicatorPadding: widget.indicatorPadding ?? EdgeInsets.zero,
        isScrollable: true,
        dividerHeight: widget.dividerHeight,
        splashFactory: NoSplash.splashFactory,
        controller: controller,
        onTap: (int index) {
          MenuMeta meta = widget.tabs[index];
          if (meta.enable) {
            widget.onSelect(widget.tabs[index]);
          }
          return meta.enable;
        },
        tabs: widget.tabs
            .map((e) => TabCellItem(
                  active: widget.activeId == e.id,
                  menu: e,
                  builder: widget.cellBuilder,
                ))
            .toList());
    if (widget.leading != null || widget.tail != null) {
      tab = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (widget.leading != null) widget.leading!,
              Expanded(child: tab),
              if (widget.tail != null) widget.tail!,
            ],
          ),
          if(widget.showIndicator)
          Divider(),
        ],
      );
    }
    return tab;
  }
}

class TabCellMeta {
  final bool active;
  final bool hovered;

  TabCellMeta({
    required this.active,
    required this.hovered,
  });
}

typedef TabCellBuilder = Widget Function(MenuMeta menu, TabCellMeta meta);

class TabCellItem extends StatefulWidget {
  final bool active;
  final MenuMeta menu;
  final TabCellBuilder? builder;

  const TabCellItem({
    super.key,
    required this.active,
    required this.menu,
    required this.builder,
  });

  @override
  State<TabCellItem> createState() => _TabCellItemState();
}

class _TabCellItemState extends State<TabCellItem> with HoverActionMix {
  @override
  Widget build(BuildContext context) {
    TabCellMeta meta = TabCellMeta(active: widget.active, hovered: hovered);
    Widget child = widget.builder?.call(widget.menu, meta) ??
        TolyUITabCell(menu: widget.menu, meta: meta);

    MouseCursor cursor = widget.menu.enable
        ? SystemMouseCursors.click
        : SystemMouseCursors.forbidden;
    return wrap(child, cursor: cursor);
  }
}

class TolyUITabCell extends StatelessWidget {
  final MenuMeta menu;
  final TabCellMeta meta;

  const TolyUITabCell({
    super.key,
    required this.menu,
    required this.meta,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness==Brightness.dark;
    Color? color;
    // FontWeight? fontWeight = widget.active ? FontWeight.bold : null;
    if (meta.active || meta.hovered) {
      color = Theme.of(context).primaryColor;
    }else{
      color = isDark?Colors.white:Color(0xff43474e);
    }
    if (!menu.enable) {
      color = Color(0xff8c8c8c);
    }
    Widget child = Text(
      menu.label,
      style: TextStyle(
        // fontWeight: fontWeight,
        color: color,
      ),
    );

    if (menu.icon != null) {
      child = Wrap(
        spacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [Icon(menu.icon, color: color, size: 18), child],
      );
    }
    return child;
  }
}
