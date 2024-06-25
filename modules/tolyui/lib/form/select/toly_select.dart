// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-26
// Contact Me:  1981462002@qq.com

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

class TolySelect extends StatefulWidget {
  final List<String> data;
  final int selectIndex;
  final ValueChanged<int> onSelected;
  final Color disableColor;
  final double iconSize;
  final double height;
  final double width;
  final double fontSize;
  final EdgeInsetsGeometry? padding;

  const TolySelect({
    super.key,
    this.data = const [],
    required this.selectIndex,
    required this.onSelected,
    this.disableColor = const Color(0xffcccccc),
    this.iconSize = 24,
    this.padding,
    this.height = 30,
    this.width = 200,
    this.fontSize = 14,
  });

  @override
  State<TolySelect> createState() => _TolySelectState();
}

class _TolySelectState extends State<TolySelect> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _ctrl;
  late FocusAttachment _nodeAttachment;
  late FocusNode _node;
  bool _focused = false;
  PopoverController controller = PopoverController();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    animation = Tween<double>(begin: 0, end: pi).animate(_ctrl);
    _node = FocusNode()
      ..addListener(() {
        print("====FocusNode#change===========");

        if (_node.hasFocus != _focused) {
          if (!_focused) {
            _ctrl.forward();
            controller.open();
          } else {
            controller.close();
            _ctrl.reverse();
          }
          setState(() {
            _focused = _node.hasFocus;
          });
        }
      });
    _nodeAttachment = _node.attach(context);
  }

  @override
  Widget build(BuildContext context) {
    _nodeAttachment.reparent();
    Color bgColor = context.isDark ? const Color(0xff303133) : Colors.white;

    return TolyDropMenu(
        controller: controller,
        overlayTapRegion: 'toly-select',
        placement: Placement.bottomStart,
        offsetCalculator: boxOffsetCalculator,
        decorationConfig: DecorationConfig(isBubble: false, backgroundColor: bgColor),
        onSelect: onSelect,
        menuItems: widget.data
            .asMap()
            .keys
            .map((index) => ActionMenu(
          active: widget.selectIndex ==index,
                  MenuMeta(router: '$index', label: widget.data[index]),
                ))
            .toList(),
        child: TapRegion(
            groupId: 'toly-select',
            onTapOutside: (_) {
              _node.unfocus();
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                print("====GestureDetector===========");
                // ctrl.open();
                if (_focused) {
                  _node.unfocus();
                } else {
                  _node.requestFocus();
                }
              },
              child: _SelectTarget(
                constraints: BoxConstraints.tight(Size(widget.width, widget.height)),
                focused: _focused,
                label: widget.data.isNotEmpty ? widget.data[widget.selectIndex] : "暂无数据",
                fontSize: widget.fontSize,
                disableColor: widget.disableColor,
                animation: animation,
                iconSize: widget.iconSize,
                padding: widget.padding ?? const EdgeInsets.only(left: 6, right: 2),
              ),
            )));
  }

  void onSelect(MenuMeta value) {
    _node.unfocus();
    widget.onSelected(int.parse(value.router));
  }
}

class _SelectTarget extends StatefulWidget {
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final bool focused;
  final String label;
  final double fontSize;
  final double iconSize;
  final Color disableColor;
  final Animation<double> animation;

  const _SelectTarget({
    super.key,
    this.constraints,
    this.padding,
    required this.focused,
    required this.label,
    required this.fontSize,
    required this.disableColor,
    required this.animation,
    required this.iconSize,
  });

  @override
  State<_SelectTarget> createState() => _SelectTargetState();
}

class _SelectTargetState extends State<_SelectTarget> {
  Color get borderColor {
    if (widget.focused) {
      return Colors.blue;
    }
    return widget.disableColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: widget.constraints,
      padding: widget.padding,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: borderColor,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.label,
            style: TextStyle(height: 1, fontSize: widget.fontSize),
          ),
          AnimatedBuilder(
            animation: widget.animation,
            builder: (_, child) => Transform.rotate(
              angle: widget.animation.value,
              child: child,
            ),
            child: Icon(
              Icons.keyboard_arrow_down,
              size: widget.iconSize,
            ),
          ),
        ],
      ),
    );
  }
}
