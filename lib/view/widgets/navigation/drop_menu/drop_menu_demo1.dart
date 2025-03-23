import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

import '../../../debugger/debugger.dart';

@DisplayNode(
  title: '基础用法',
  desc: '当页面上的操作命令过多时，用此组件可以收纳操作元素。点击或移入触点，会出现一个下拉菜单。可在列表中进行选择，并执行相应的命令。下面是气泡和非气泡模式：',
)
class DropMenuDemo1 extends StatelessWidget {
  const DropMenuDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    Color bgColor = context.isDark ? const Color(0xff303133) : Colors.white;

    return Wrap(
      spacing: 20,
      children: [
        display1(),
        display2(bgColor),
        TolyDropMenu(
            placement: Placement.bottomStart,
            offsetCalculator: boxOffsetCalculator,
            decorationConfig: DecorationConfig(isBubble: false, backgroundColor: bgColor),
            onSelect: onSelect,
            menuItems: [
              ActionMenu(const MenuMeta(route: '01', label: '1st menu item')),
              ActionMenu(const MenuMeta(route: '02', label: '2nd menu item')),
              ActionMenu(
                const MenuMeta(route: '03', label: '3rd menu item'),
              ),
              ActionMenu(const MenuMeta(route: '04', label: '4ur menu item')),
            ],
            childBuilder: (_, ctrl, __) {
              return DebugDisplayButton(
                info: 'Click Pop',
                onPressed: ctrl.open,
              );
            }),
      ],
    );
  }

  void onSelect(MenuMeta menu) {
    $message.success(message: '点击了 [${menu.label}] 个菜单');
  }

  Widget display1() {
    return TolyDropMenu(
      hoverConfig: const HoverConfig(enterPop: true, exitClose: true),
      onSelect: onSelect,
      menuItems: [
        ActionMenu(const MenuMeta(route: '01', label: '1st menu item')),
        ActionMenu(const MenuMeta(route: '02', label: '2nd menu item')),
        ActionMenu(const MenuMeta(route: '03', label: '3rd menu item')),
        ActionMenu(const MenuMeta(route: '04', label: '4ur menu item')),
      ],
      // width: 140,
      child: DebugDisplayButton(
        info: 'Hover Pop',
        onPressed: () {},
      ),
    );
  }

  Widget display2(Color bgColor) {
    return TolyDropMenu(
        placement: Placement.bottomStart,
        offsetCalculator: boxOffsetCalculator,
        decorationConfig: DecorationConfig(isBubble: false, backgroundColor: bgColor),
        onSelect: onSelect,
        menuItems: [
          ActionMenu(const MenuMeta(route: '01', label: '1st menu item')),
          ActionMenu(const MenuMeta(route: '02', label: '2nd menu item')),
          ActionMenu(const MenuMeta(route: '03', label: '3rd menu item')),
          ActionMenu(const MenuMeta(route: '04', label: '4ur menu item')),
        ],
        childBuilder: (_, ctrl, __) {
          return DebugDisplayButton(
            info: 'Click Pop',
            onPressed: ctrl.open,
          );
        });
  }
}
