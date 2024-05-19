// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-19
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';

import 'hover_action_mixin.dart';
import 'menu_item_diaplsy.dart';

class ActionMenuItem extends StatefulWidget {
  final ActionMenuDisplay display;
  final Widget? tail;

  const ActionMenuItem({
    super.key,
    required this.display,
    this.tail,
  });

  @override
  State<ActionMenuItem> createState() => _ActionMenuItemState();
}

class _ActionMenuItemState extends State<ActionMenuItem> with HoverActionMix {
  @override
  Widget build(BuildContext context) {
    bool enable = !widget.display.disable;

    MouseCursor cursor =
        enable ? SystemMouseCursors.click : SystemMouseCursors.forbidden;
    Color backgroundColor = Colors.transparent;
    Color foregroundColor = Color(0xff1f1f1f);
    if (enable) {
      if (hovered) {
        backgroundColor = Color(0xfff5f5f5);
      }
    } else {
      foregroundColor = Color(0xffbfbfbf);
    }

    Widget child = Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: backgroundColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.display.menu.label,
            style: TextStyle(color: foregroundColor),
          ),
          // Spacer(),
          if (widget.tail != null) widget.tail!
        ],
      ),
    );

    if (enable) {
      child = GestureDetector(
        onTap: ()=>widget.display.onSelect!(widget.display.menu),
        child: child,
      );
    }

    return wrap(child, cursor: cursor);
  }
}


class DividerMenuItem extends StatelessWidget{
  final DividerMenuDisplay display;

  const DividerMenuItem({super.key, required this.display});

  @override
  Widget build(BuildContext context) {
    return Divider(height: display.height,);
  }

}