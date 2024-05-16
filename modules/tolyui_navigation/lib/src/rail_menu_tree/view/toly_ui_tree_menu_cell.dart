// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-15
// Contact Me:  1981462002@qq.com

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../tolyui_navigation.dart';

class MenuTreeCellStyle {
  final bool showIndicator;
  final Color activeForegroundColor;
  final Color activeBackgroundColor;
  final Color inactiveBackgroundColor;
  final Color inactiveForegroundColor;
  final Color? hoverForegroundColor;
  final Color? hoverBackgroundColor;
  final double iconSize;
  final double height;

  const MenuTreeCellStyle({
    this.showIndicator = true,
    required this.activeForegroundColor,
    required this.inactiveBackgroundColor,
    required this.inactiveForegroundColor,
    required this.activeBackgroundColor,
    this.hoverForegroundColor,
    this.hoverBackgroundColor,
    this.iconSize = 24,
    this.height = 60,
  });

  factory MenuTreeCellStyle.light() => const MenuTreeCellStyle(
        activeForegroundColor: Color(0xff02589F),
        hoverForegroundColor: Color(0xff02589F),
        hoverBackgroundColor: Colors.transparent,
        activeBackgroundColor: Color(0xffe6f7ff),
        inactiveBackgroundColor: Colors.transparent,
        inactiveForegroundColor: Color(0xff61666d),
      );

  factory MenuTreeCellStyle.dark() => const MenuTreeCellStyle(
        activeForegroundColor: Color(0xff02589F),
        activeBackgroundColor: Color(0xff1890ff),
        inactiveBackgroundColor: Colors.transparent,
        inactiveForegroundColor: Color(0xffa6adb4),
      );
}

class TolyUITreeMenuCell extends StatelessWidget {
  final MenuNode menuNode;
  final DisplayMeta display;
  final MenuTreeCellStyle? style;

  const TolyUITreeMenuCell({
    super.key,
    required this.menuNode,
    required this.display,
    this.style,
  });

  MenuTreeCellStyle get effectStyle =>
      style ??
      (display.isDark ? MenuTreeCellStyle.dark() : MenuTreeCellStyle.light());

  Color? effectForegroundColor(MenuTreeCellStyle style) {
    if (display.selected) {
      return display.isDark ? Colors.white : style.activeForegroundColor;
    }
    if (display.hovered) {
      return display.isDark ? Colors.white : style.hoverForegroundColor;
    }
    return style.inactiveForegroundColor;
  }

  double get anim => display.anima ?? 1;

  Color? backgroundColor(MenuTreeCellStyle style) {
    if (hasChild) return null;
    if (selectOrPlaying) {
      return style.activeBackgroundColor.withOpacity(anim);
    }
    if (display.hovered) {
      return style.hoverBackgroundColor;
    }
    return null;
  }

  bool get selectOrPlaying => (display.selected || display.playing);

  bool get hasChild => menuNode.children.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    MenuTreeCellStyle effectStyle = style ??
        (display.isDark ? MenuTreeCellStyle.dark() : MenuTreeCellStyle.light());

    Color? bgColor = backgroundColor(effectStyle);
    Color? fgColor = effectForegroundColor(effectStyle);

    Widget cell = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: bgColor,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(
                  horizontal: 24.0 + (12 * menuNode.depth), vertical: 12),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (menuNode.data.icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(menuNode.data.icon, size: 18, color: fgColor),
                    ),
                  Text(menuNode.data.label,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: fgColor))
                ],
              ),
            ),
          ),
          if (menuNode.children.isNotEmpty)
            _buildExpandIndicator(display.expanded, fgColor)
        ],
      ),
    );
    if (selectOrPlaying && effectStyle.showIndicator && !hasChild) {
      cell = Stack(
        alignment: Alignment.centerLeft,
        children: [
          cell,
          LineIndicator(progress: anim, color: fgColor),
        ],
      );
    }
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
        child: cell);
  }

  Widget _buildExpandIndicator(bool expanded, Color? color) {
    return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Transform.rotate(
            angle: display.rate * pi,
            child: Icon(CupertinoIcons.chevron_down, size: 16, color: color)));
  }
}

class LineIndicator extends StatelessWidget {
  final double width;
  final double height;
  final double progress;
  final Color? color;

  const LineIndicator({
    super.key,
    this.width = 4,
    required this.progress,
    required this.color,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width + (height - 4) * progress,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          width / 2,
        ),
      ),
    );
  }
}
