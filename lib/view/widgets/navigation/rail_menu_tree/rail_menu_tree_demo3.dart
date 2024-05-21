import 'package:flutter/material.dart';
import 'package:toly_ui/view/debugger/debugger.dart';
import 'package:tolyui/tolyui.dart';
import 'plcki_menu_tree_data.dart';

class RailMenuTreeDemo3 extends StatefulWidget {
  const RailMenuTreeDemo3({super.key});

  @override
  State<RailMenuTreeDemo3> createState() => _RailMenuTreeDemo3State();
}

class _RailMenuTreeDemo3State extends State<RailMenuTreeDemo3> {
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
    return SizedBox(
      height: 490,
      child: Row(
        children: [
          TolyRailMenuTree(
            leading: DebugLeadingAvatar(
              type: MenuWidthType.large,
            ),
            tail: VersionTail(),
            enableWidthChange: true,
            meta: _menuMeta,
            backgroundColor: backgroundColor,
            activeColor: const Color(0xffe6edf3),
            activeItemBackground: Colors.red,
            expandBackgroundColor: expandBackgroundColor,
            onSelect: _onSelect,
          ),
        ],
      ),
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
    _menuMeta = _menuMeta.select(menu,singleExpand: true);

    setState(() {});
  }
}
