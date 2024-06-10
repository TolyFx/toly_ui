import 'package:flutter/material.dart';
import 'package:toly_ui/view/debugger/debugger.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

import 'plcki_menu_tree_data.dart';

@DisplayNode(
  title: '首尾组件',
  desc: 'leading 和 tail 属性可以设置 TolyRailMenuTree 的首尾组件，树形菜单内容超出时，可在中间区域滚动展示',
)
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
    Color expandBackgroundColor = context.isDark ? Colors.black : Colors.transparent;
    Color backgroundColor = context.isDark ? Color(0xff001529) : Colors.white;
    return SizedBox(
      height: 490,
      child: Align(
        alignment: Alignment.topLeft,
        child: TolyRailMenuTree(
          leading: const DebugLeadingAvatar(),
          tail: const VersionTail(),
          enableWidthChange: true,
          meta: _menuMeta,
          backgroundColor: backgroundColor,
          expandBackgroundColor: expandBackgroundColor,
          onSelect: _onSelect,
        ),
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
    _menuMeta = _menuMeta.select(menu, singleExpand: true);

    setState(() {});
  }
}
