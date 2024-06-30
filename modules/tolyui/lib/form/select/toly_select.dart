// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-26
// Contact Me:  1981462002@qq.com

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

part 'select_target.dart';

class TolySelect extends StatefulWidget {
  final double width;
  final double minWidth;
  final double? maxHeight;
  final bool shrinkWidth;
  final bool shrinkWrapWidthOverlay;

  final List<String> data;
  final int selectIndex;
  final ValueChanged<int> onSelected;
  final double iconSize;
  final double height;
  final MenuMetaBuilder? contentBuilder;
  final DropMenuCellStyle? cellStyle;

  final Color disableColor;

  final double fontSize;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? labelPadding;

  const TolySelect({
    super.key,
    this.data = const [],
    required this.selectIndex,
    required this.onSelected,
    this.disableColor = const Color(0xffcccccc),
    this.iconSize = 24,
    this.padding,
    this.labelPadding,
    this.cellStyle,
    this.height = 30,
    this.width = 200,
    this.minWidth = 120,
    this.fontSize = 14,
    this.maxHeight,
    this.shrinkWrapWidthOverlay = false,
    this.shrinkWidth = false,
    this.contentBuilder,
  });

  @override
  State<TolySelect> createState() => _TolySelectState();
}

class _TolySelectState extends State<TolySelect> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _ctrl;
  late FocusAttachment _nodeAttachment;
  late FocusNode _node;

  bool get focused => _node.hasFocus;
  PopoverController controller = PopoverController();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    animation = Tween<double>(begin: 0, end: pi).animate(_ctrl);
    _node = FocusNode()..addListener(_onFocusChange);
    _nodeAttachment = _node.attach(context);
  }

  void _onFocusChange() {
    if (focused) {
      _ctrl.forward();
      controller.open();
    } else {
      controller.close();
      _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _node.removeListener(_onFocusChange);
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _nodeAttachment.reparent();
    Color bgColor = context.isDark ? const Color(0xff303133) : Colors.white;
    const EdgeInsets targetPadding = EdgeInsets.only(left: 6, right: 2, top: 4, bottom: 4);
    return TolyDropMenu(
        contentBuilder: widget.contentBuilder,
        minOverlayWidth: widget.minWidth,
        maxHeight: widget.maxHeight,
        style: widget.cellStyle,
        shrinkWrapWidthOverlay: widget.shrinkWrapWidthOverlay,
        controller: controller,
        overlayTapRegion: controller,
        placement: Placement.bottomStart,
        offsetCalculator: boxOffsetCalculator,
        decorationConfig: DecorationConfig(isBubble: false, backgroundColor: bgColor),
        onSelect: onSelect,
        menuItems: menus,
        child: TapRegion(
            groupId: controller,
            onTapOutside: (_) => _node.unfocus(),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _changeFocus,
                child: _SelectTarget(
                  constraints: constraints,
                  focused: focused,
                  label: widget.data.isNotEmpty ? widget.data[widget.selectIndex] : "暂无数据",
                  fontSize: widget.fontSize,
                  disableColor: widget.disableColor,
                  animation: animation,
                  shrinkWidth: widget.shrinkWidth,
                  iconSize: widget.iconSize,
                  padding: widget.padding ?? targetPadding,
                  labelPadding: widget.labelPadding,
                ),
              ),
            )));
  }

  void _changeFocus() {
    if (focused) {
      _node.unfocus();
    } else {
      _node.requestFocus();
    }
  }

  void onSelect(MenuMeta value) {
    _node.unfocus();
    widget.onSelected(int.parse(value.router));
  }

  List<MenuDisplay> get menus {
    Iterable<int> indexes = widget.data.asMap().keys;
    return indexes
        .map((index) => ActionMenu(
              active: widget.selectIndex == index,
              MenuMeta(router: '$index', label: widget.data[index]),
            ))
        .toList();
  }

  BoxConstraints? get constraints =>
      widget.shrinkWidth ? null : BoxConstraints.tight(Size(widget.width, widget.height));
}
