import 'package:flutter/material.dart';
import 'package:toly_ui/components/node_display.dart';
import 'package:tolyui/tolyui.dart';

import '../../widget_display_map.dart';
import 'display_nodes.dart';
import 'plcki_menu_tree_data.dart';

class RailMenuTreeDisplayPage extends StatelessWidget {
  const RailMenuTreeDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          height: 460,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TolyRailMenuTreeDemo1(singleExpand: false,),
              const SizedBox(width: 20),
              TolyRailMenuTreeDemo1(singleExpand: true,),
            ],
          ),
        ),
      ),
    );
  }
}

class TolyRailMenuTreeDemo1 extends StatefulWidget {
  final bool singleExpand;
  const TolyRailMenuTreeDemo1({super.key,  this.singleExpand=false});

  @override
  State<TolyRailMenuTreeDemo1> createState() => _TolyRailMenuTreeDemo1State();
}

class _TolyRailMenuTreeDemo1State extends State<TolyRailMenuTreeDemo1> {
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
      enableWidthChange: true,
      meta: _menuMeta,
      backgroundColor: backgroundColor,
      activeColor: const Color(0xffe6edf3),
      activeItemBackground: Colors.red,
      expandBackgroundColor: expandBackgroundColor,
      onSelect: _onSelect,
    );
  }

  @override
  void reassemble() {
    _initTreeMeta();
    super.reassemble();
  }

  void _initTreeMeta() {
    MenuNode root = MenuNode.fromMap(plckiMenuData);
    _menuMeta = MenuTreeMeta(
      expandMenus: ['/dashboard'],
      activeMenu: root.find('/dashboard/home'),
      root: root,
    );
  }

  void _onSelect(MenuNode menu) {
    _menuMeta = _menuMeta.select(menu, singleExpand: widget.singleExpand);

    setState(() {});
  }
}
