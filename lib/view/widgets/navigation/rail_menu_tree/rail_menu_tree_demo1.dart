import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

import 'plcki_menu_tree_data.dart';

@DisplayNode(
  title: 'TolyUI 默认菜单树样式',
  desc:
      '支持拖拽拉伸，点击选中时条目背景色、指示器动画变化，子菜单面板。\n具有子节点的菜单项，有 icon 标识，点击时会折叠/展开子菜单列表，且具有动画效果。\n下面案例中支持多个菜单项同时展开：',
)
class RailMenuTreeDemo1 extends StatefulWidget {
  const RailMenuTreeDemo1({super.key});

  @override
  State<RailMenuTreeDemo1> createState() => _RailMenuTreeDemo1State();
}

class _RailMenuTreeDemo1State extends State<RailMenuTreeDemo1> {
  late MenuTreeMeta _treeMeta;

  @override
  void initState() {
    super.initState();
    _initTreeMeta();
  }

  @override
  Widget build(BuildContext context) {
    Color expandBackgroundColor = context.isDark ? Colors.black : Colors.transparent;
    Color backgroundColor = context.isDark ? const Color(0xff001529) : Colors.white;
    return SizedBox(
      height: 460,
      child: Align(
        alignment: Alignment.topLeft,
        child: TolyRailMenuTree(
          enableWidthChange: true,
          meta: _treeMeta,
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
    _treeMeta = MenuTreeMeta(
      expandMenus: ['/dashboard'],
      activeMenu: root.find('/dashboard/home'),
      root: root,
    );
  }

  void _onSelect(MenuNode menu) {
    _treeMeta = _treeMeta.select(menu);
    setState(() {});
  }
}
