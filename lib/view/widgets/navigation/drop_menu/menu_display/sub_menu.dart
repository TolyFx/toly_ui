// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-20
// Contact Me:  1981462002@qq.com

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import 'drop_menu.dart';
import 'menu_item_display.dart';

class SubMenuItem extends StatefulWidget {
  final SubMenu menu;
  final ValueChanged<MenuMeta>? onSelect;
  final double subMenuGap;

  const SubMenuItem({super.key, required this.menu, required this.onSelect, required this.subMenuGap});

  @override
  State<SubMenuItem> createState() => _SubMenuItemState();
}

class _SubMenuItemState extends State<SubMenuItem> {
  Timer? exitTimer;

  bool hovered = false;

  // void startTimer( PopoverController controller){
  //   hovered = false;
  //   closeTimer();
  //   exitTimer = Timer(Duration(milliseconds: 200),(){
  //     controller.close();
  //   });
  //   setState(() {
  //
  //   });
  // }

  // void closeTimer(){
  //   exitTimer?.cancel();
  //   exitTimer =null;
  // }

  @override
  void dispose() {
    // closeTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool enable = !widget.menu.disable;

    MouseCursor cursor =
        enable ? SystemMouseCursors.click : SystemMouseCursors.forbidden;
    Color backgroundColor = Colors.transparent;
    Color foregroundColor = Color(0xff1f1f1f);
    if (enable) {
      if (hovered) {
        backgroundColor = Color(0xffe6f7ff);
      }
    } else {
      foregroundColor = Color(0xffbfbfbf);
    }
    Widget content = Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(6),
        color: backgroundColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: WrapCrossAlignment.e,
        children: [
          Text(
            widget.menu.menu.label,
            style: TextStyle(color: foregroundColor),
          ),
          // Spacer(),
          const SizedBox(
            width: 20,
          ),
          Icon(
            Icons.navigate_next,
            size: 18,
            color: foregroundColor,
          )
        ],
      ),
    );

    return TolyDropMenu(
      onSelect: widget.onSelect,
      placement: Placement.rightStart,
      subMenuGap: widget.subMenuGap,
      hoverConfig: const HoverConfig(enterPop: true, exitClose: false),
      decorationConfig: DecorationConfig(isBubble: false),
      offsetCalculator: (c)=>menuOffsetCalculator(c,shift: widget.subMenuGap),
      // onEnter: (){
      //   closeTimer();
      // },
      menuItems: widget.menu.menus,
      childBuilder:
          (BuildContext context, PopoverController controller, Widget? child) {
        return content;
      },
    );
  }
}
