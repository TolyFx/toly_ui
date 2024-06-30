// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-19
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';

import '../../model/model.dart';
import '../mixin/hover_action_mixin.dart';
import '../style/drop_menu_style.dart';
import 'menu_item_display.dart';

class DropMenuDisplayMeta {
  final bool enable;
  final bool hovered;
  final DropMenuCellStyle style;

  DropMenuDisplayMeta({
    required this.enable,
    required this.hovered,
    required this.style,
  });
}

typedef MenuMetaBuilder = Widget? Function(
  BuildContext context,
  MenuMeta menu,
  DropMenuDisplayMeta display,
);

class ActionMenuItem extends StatefulWidget {
  final ActionMenu display;
  final MenuMetaBuilder? leadingBuilder;
  final MenuMetaBuilder? tailBuilder;
  final MenuMetaBuilder? contentBuilder;
  final DropMenuCellStyle? style;
  final ValueChanged<MenuMeta>? onSelect;

  const ActionMenuItem({
    super.key,
    required this.display,
    required this.tailBuilder,
    required this.contentBuilder,
    this.style,
    this.onSelect,
    required this.leadingBuilder,
  });

  @override
  State<ActionMenuItem> createState() => _ActionMenuItemState();
}

class _ActionMenuItemState extends State<ActionMenuItem> with HoverActionMix {
  DropMenuCellStyle get effectStyle =>
      widget.style ??
      (Theme.of(context).brightness == Brightness.dark
          ? DropMenuCellStyle.dark()
          : DropMenuCellStyle.light());

  @override
  Widget build(BuildContext context) {
    bool enable = !widget.display.disable;

    MouseCursor cursor =
        enable ? SystemMouseCursors.click : SystemMouseCursors.forbidden;
    Color backgroundColor = effectStyle.backgroundColor;
    Color foregroundColor = effectStyle.foregroundColor;
    if (enable) {
      if(widget.display.active){
        foregroundColor = Theme.of(context).primaryColor;
        backgroundColor = effectStyle.hoverBackgroundColor;
      }else{
        if (hovered) {
          backgroundColor = effectStyle.hoverBackgroundColor;
        }
      }

    } else {
      foregroundColor = effectStyle.disableColor;
    }

    Widget? leading = widget.leadingBuilder?.call(
      context,
      widget.display.menu,
      DropMenuDisplayMeta(
        enable: enable,
        hovered: hovered,
        style: effectStyle,
      ),
    );

    if (widget.display.menu.icon != null && leading == null) {
      leading = Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Icon(
          widget.display.menu.icon!,
          size: 20,
        ),
      );
    }

    Widget? tail = widget.tailBuilder?.call(
      context,
      widget.display.menu,
      DropMenuDisplayMeta(
        enable: enable,
        hovered: hovered,
        style: effectStyle,
      ),
    );

    Widget? content = widget.contentBuilder?.call(
      context,
      widget.display.menu,
      DropMenuDisplayMeta(
        enable: enable,
        hovered: hovered,
        style: effectStyle,
      ),
    );

    TextStyle style = effectStyle.textStyle?? const TextStyle();

    Widget child = Container(
      alignment: Alignment.centerLeft,
      margin: effectStyle.padding,
      decoration: BoxDecoration(
        borderRadius: effectStyle.borderRadius,
        color: backgroundColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) leading,
          content ?? Text(
            widget.display.menu.label,
            style: style.copyWith(color: foregroundColor),
          ),
          // Spacer(),
          if (tail != null) tail
        ],
      ),
    );

    if (enable) {
      child = GestureDetector(
        onTap: () => widget.onSelect!(widget.display.menu),
        child: child,
      );
    }
    return wrap(child, cursor: cursor);
  }
}

class DividerMenuItem extends StatelessWidget {
  final DividerMenu display;

  const DividerMenuItem({super.key, required this.display});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: display.height,
    );
  }
}
