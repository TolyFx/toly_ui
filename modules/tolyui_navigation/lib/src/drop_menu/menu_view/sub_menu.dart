// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-20
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';
import 'package:tolyui_meta/tolyui_meta.dart';
import '../../model/model.dart';
import '../core/drop_menu.dart';
import '../drop_menu.dart';
import '../mixin/hover_action_mixin.dart';
import 'menu_item_display.dart';

class SubMenuItem extends StatefulWidget {
  final SubMenu menu;
  final ValueChanged<MenuMeta>? onSelect;
  final ValueChanged<bool>? onSubMenuEnter;
  final double subMenuGap;
  final DropMenuCellStyle? style;
  final DecorationConfig? decorationConfig;
  final MenuMetaBuilder? leadingBuilder;
  final MenuMetaBuilder? contentBuilder;
  final MenuMetaBuilder? tailBuilder;
  final double? maxHeight;
  final ValueChanged<String>? onCloseSubMeu;

  const SubMenuItem({
    super.key,
    required this.menu,
    required this.style,
    required this.onSubMenuEnter,
    required this.maxHeight,
    required this.onSelect,
    required this.subMenuGap,
    required this.leadingBuilder,
    required this.tailBuilder,
    required this.onCloseSubMeu,
    required this.contentBuilder,
    required this.decorationConfig,
  });

  @override
  State<SubMenuItem> createState() => _SubMenuItemState();
}

class _SubMenuItemState extends State<SubMenuItem> with HoverActionMix {
  DropMenuCellStyle get effectStyle =>
      widget.style ??
      (Theme.of(context).brightness == Brightness.dark
          ? DropMenuCellStyle.dark()
          : DropMenuCellStyle.light());

  @override
  Widget build(BuildContext context) {
    bool enable = !widget.menu.disable;

    MouseCursor cursor =
        enable ? SystemMouseCursors.click : SystemMouseCursors.forbidden;
    Color backgroundColor = effectStyle.backgroundColor;
    Color foregroundColor = effectStyle.foregroundColor;
    if (enable) {
      if (hovered) {
        backgroundColor = effectStyle.hoverBackgroundColor;
      }
    } else {
      foregroundColor = effectStyle.disableColor;
    }

    Widget? leading = widget.leadingBuilder?.call(
      context,
      widget.menu.menu,
      DropMenuDisplayMeta(
        enable: enable,
        hovered: hovered,
        style: effectStyle,
      ),
    );
    MenuMeta menu = widget.menu.menu;
    IconData? icon;
    if (menu is IconMenu) {
      icon = menu.icon;
    }
    if (icon != null && leading == null) {
      leading = Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Icon(
          icon,
          size: 18,
        ),
      );
    }

    Widget? body = widget.contentBuilder?.call(
      context,
      widget.menu.menu,
      DropMenuDisplayMeta(
        enable: enable,
        hovered: hovered,
        style: effectStyle,
      ),
    );

    Widget content = Container(
      alignment: Alignment.centerLeft,
      margin: effectStyle.padding,
      decoration: BoxDecoration(
        borderRadius: effectStyle.borderRadius,
        color: backgroundColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: WrapCrossAlignment.e,
        children: [
          if (leading != null) leading,
          body ??
              Text(
                widget.menu.menu.label,
                style: TextStyle(color: foregroundColor),
              ),
          const Spacer(),
          // const SizedBox(width: 20),
          Icon(
            Icons.navigate_next,
            size: 18,
            color: foregroundColor,
          )
        ],
      ),
    );

    content = wrap(content, cursor: cursor);
    return TolyDropMenu(
      onSelect: widget.onSelect,
      style: widget.style,
      onClose: () {
        widget.onCloseSubMeu?.call(widget.menu.menu.route);
      },
      maxHeight: widget.menu.maxHeight ?? widget.maxHeight,
      leadingBuilder: widget.leadingBuilder,
      tailBuilder: widget.tailBuilder,
      placement: Placement.rightStart,
      subMenuGap: widget.subMenuGap,
      onSubMenuEnter: widget.onSubMenuEnter,
      hoverConfig: const HoverConfig(enterPop: true, exitClose: false),
      decorationConfig: widget.decorationConfig,
      offsetCalculator: (c) =>
          menuOffsetCalculator(c, shift: widget.subMenuGap),
      menuItems: widget.menu.menus,
      childBuilder:
          (BuildContext context, PopoverController controller, Widget? child) {
        return content;
      },
    );
  }
}
