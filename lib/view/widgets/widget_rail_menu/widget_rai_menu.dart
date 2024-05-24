// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-23
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_menu_manager/ext/ext.dart';
import 'package:toly_ui/navigation/menu/widget_menus.dart';
import 'package:tolyui/tolyui.dart';

import '../../home_page/home_nav_bar.dart';
import 'toly_ui_menu_cell.dart';

class AppNavMenu extends StatefulWidget {
  const AppNavMenu({super.key});

  @override
  State<AppNavMenu> createState() => _AppNavMenuState();
}

class _AppNavMenuState extends State<AppNavMenu> with RouterChangeListenerMixin{
  late MenuTreeMeta _menuMeta;

  @override
  void initState() {
    super.initState();
    _initTreeMeta();
  }

  @override
  Widget build(BuildContext context) {

    Color expandBackgroundColor = context.isDark?Colors.black:Colors.transparent;
    Color backgroundColor = context.isDark?Color(0xff001529):Colors.white;

    return TolyRailMenuTree(
      leading: SizedBox(height: 18,),
      enableWidthChange: true,
      builder: (node,display)=>TolyUIWidgetMenuCell(menuNode: node,display: display,),
      maxWidth: 360,
      width: 240,
      meta: _menuMeta,
      backgroundColor: backgroundColor,
      expandBackgroundColor: expandBackgroundColor,
      onSelect: _onSelect,
    );
  }

  void _initTreeMeta() {
    MenuNode root = MenuNode.fromMap(widgetMenus,extParser: TolyUIMenuMetaExt.fromMap);
    _menuMeta = MenuTreeMeta(
      expandMenus: ['/dashboard'],
      activeMenu: root.find('/dashboard/home'),
      root: root,
    );
  }

  void _onSelect(MenuNode menu) {
    if(menu.isLeaf){
      context.go(menu.id);
    }else{
      _menuMeta = _menuMeta.select(menu, singleExpand: true);
      setState(() {});
    }

  }

  @override
  void reassemble() {
    MenuNode root = MenuNode.fromMap(widgetMenus,extParser: TolyUIMenuMetaExt.fromMap);
    _menuMeta = _menuMeta.copyWith(root: root);
    super.reassemble();
  }

  @override
  void onChangeRoute(String path) {
    _menuMeta = _menuMeta.selectPath(path, singleExpand: true);
    print(path);
    setState(() {});
  }
}