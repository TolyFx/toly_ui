import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

import 'plcki_menu_tree_data.dart';

@DisplayNode(
  title: '只同时展开一个子面板',
  desc: '将折叠的选中事件触发时，singleExpand 设置为 true，可以在展开子菜单面板时，关闭其他已展开面板:',
)
class RailMenuTreeDemo2 extends StatefulWidget {
  const RailMenuTreeDemo2({super.key});

  @override
  State<RailMenuTreeDemo2> createState() => _RailMenuTreeDemo2State();
}

class _RailMenuTreeDemo2State extends State<RailMenuTreeDemo2> {
  late MenuTreeMeta _menuMeta;

  @override
  void initState() {
    super.initState();
    _initTreeMeta();
  }

  @override
  Widget build(BuildContext context) {
    Color expandBackgroundColor = context.isDark ? Colors.black : Colors.transparent;
    Color backgroundColor = context.isDark ? Color(0xff001529) : Colors.white;
    return SizedBox(
        height: 460,
        child: Align(
          alignment: Alignment.topLeft,
          child: TolyRailMenuTree(
            enableWidthChange: true,
            meta: _menuMeta,
            backgroundColor: backgroundColor,
            expandBackgroundColor: expandBackgroundColor,
            onSelect: _onSelect,
          ),
        ));
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
    _menuMeta = _menuMeta.select(menu, singleExpand: true);
    setState(() {});
  }
}
