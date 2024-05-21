import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/navigation/drop_menu/menu_display/drop_menu.dart';
import 'package:tolyui/tolyui.dart';

import '../../../debugger/debugger.dart';
import '../../widgets.dart';
import 'menu_display/menu_item_display.dart';

class DropMenuDemo2 extends StatelessWidget {
  const DropMenuDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      children: [
        TolyDropMenu(
            onSelect: onSelect,
            placement: Placement.bottomStart,
            decorationConfig: DecorationConfig(isBubble: false),
            offsetCalculator: boxOffsetCalculator,
            menuItems: [
              ActionMenu(MenuMeta(
                  icon: Icons.add,
                  router: '01', label: '1st menu item')),
              ActionMenu(MenuMeta(
                  icon: Icons.remove,
                  router: '02', label: '2nd menu item')),
              ActionMenu(MenuMeta(
                  icon: Icons.close,

                  router: '03', label: '3rd menu item')),
              const DividerMenu(),
              ActionMenu(MenuMeta(
                  icon: Icons.diamond,

                  router: '04', label: '4ur menu item')),
            ],
            childBuilder: (_, ctrl, __) {
              return DebugDisplayButton(
                info: 'Divider Menu',
                onPressed: ctrl.open,
              );
            }),
        TolyDropMenu(
            onSelect: onSelect,
            menuItems: [
              ActionMenu(MenuMeta(router: '01', label: '1st menu item')),
              ActionMenu(MenuMeta(router: '02', label: '2nd menu item')),
              ActionMenu(MenuMeta(router: '03', label: '3rd menu item'),
                  enable: false),
              const DividerMenu(),
              ActionMenu(MenuMeta(router: '04', label: '4ur menu item')),
            ],
            // width: 140,
            childBuilder: (_, ctrl, __) {
              return DebugDisplayButton(
                info: 'Disable Menu',
                onPressed: ctrl.open,
              );
            }),
      ],
    );
  }

  void onSelect(
    MenuMeta menu,
  ) {
    $message.success(message: '点击了 [${menu.label}] 个菜单');
  }
}

