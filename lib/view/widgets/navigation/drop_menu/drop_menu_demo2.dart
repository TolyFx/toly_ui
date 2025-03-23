import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

import '../../../debugger/debugger.dart';

@DisplayNode(
  title: '分割线与不可用菜单项',
  desc: 'DividerMenu 可以展示分割线项，ActionMenu 的 enable 属性配置其是否可用; 菜单元数据 MenuMeta 中的 icon 属性可以配置菜单项图标。',
)
class DropMenuDemo2 extends StatelessWidget {
  const DropMenuDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    Color bgColor = context.isDark ? const Color(0xff303133) : Colors.white;
    return Wrap(
      spacing: 20,
      children: [display1(bgColor), display2(bgColor)],
    );
  }

  void onSelect(MenuMeta menu) {
    $message.success(message: '点击了 [${menu.label}] 个菜单');
  }

  Widget display1(Color bgColor) {
    return TolyDropMenu(
        onSelect: onSelect,
        placement: Placement.bottomStart,
        decorationConfig: DecorationConfig(isBubble: false, backgroundColor: bgColor),
        offsetCalculator: boxOffsetCalculator,
        menuItems: [
          ActionMenu( IconMenu(Icons.add, route: '01', label: '1st menu item')),
          ActionMenu( IconMenu(Icons.remove, route: '02', label: '2nd menu item')),
          ActionMenu( IconMenu(Icons.close, route: '03', label: '3rd menu item')),
          const DividerMenu(),
          ActionMenu( IconMenu( Icons.diamond, route: '04', label: '4ur menu item')),
        ],
        childBuilder: (_, ctrl, __) {
          return DebugDisplayButton(
            info: 'Divider Menu',
            onPressed: ctrl.open,
          );
        });
  }

  Widget display2(Color bgColor) {
    return TolyDropMenu(
        onSelect: onSelect,
        menuItems: [
          ActionMenu(const MenuMeta(route: '01', label: '1st menu item')),
          ActionMenu(const MenuMeta(route: '02', label: '2nd menu item')),
          ActionMenu(const MenuMeta(route: '03', label: '3rd menu item'), enable: false),
          const DividerMenu(),
          ActionMenu(const MenuMeta(route: '04', label: '4ur menu item')),
        ],
        childBuilder: (_, ctrl, __) {
          return DebugDisplayButton(
            info: 'Disable Menu',
            onPressed: ctrl.open,
          );
        });
  }
}
