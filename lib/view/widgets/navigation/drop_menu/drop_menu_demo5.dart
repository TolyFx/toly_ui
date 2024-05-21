import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/navigation/drop_menu/menu_display/drop_menu.dart';
import 'package:tolyui/tolyui.dart';

import '../../../debugger/debugger.dart';
import '../../widgets.dart';
import 'menu_display/menu_item_display.dart';

class DropMenuDemo5 extends StatelessWidget{
  const DropMenuDemo5({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyDropMenu(
      onSelect: onSelect,
      decorationConfig: const DecorationConfig(isBubble: false),
      placement: Placement.topEnd,
      menuItems: [
        ActionMenu(const MenuMeta(router: '01', label: '1st menu item')),
        ActionMenu(const MenuMeta(router: '02', label: '2nd menu item')),
        SubMenu(const MenuMeta(router: '03', label: 'export image'), menus: [
          ActionMenu(const MenuMeta(router: 'png', label: 'sub out .png')),
          ActionMenu(const MenuMeta(router: 'jpeg', label: 'sub out .jpeg')),
          ActionMenu(const MenuMeta(router: 'svg', label: 'sub out .svg')),
        ]),
        ActionMenu(const MenuMeta(router: '04', label: '4ur menu item')),
      ],
      // width: 140,
      childBuilder: (_, ctrl, __) => GestureDetector(
        onTapDown: (_) => ctrl.close(),
        onSecondaryTapDown: (detail) => _onSecondaryTapDown(detail, ctrl),
        child: Container(
          color: const Color(0xfff7f7f7),
          alignment: Alignment.center,
          height: 180,
          child: const Text('Right Click on here'),
        ),
      ),
    );
  }

  void onSelect(
    MenuMeta menu,
  ) {
    $message.success(message: '点击了 [${menu.label}] 个菜单');
  }

  void _onSecondaryTapDown(TapDownDetails details, PopoverController ctrl) async {
    if (ctrl.isOpen) {
      ctrl.close();
      Future.delayed(Duration(milliseconds: 260), () {
        ctrl.open(position: details.localPosition);
      });
    } else {
      ctrl.open(position: details.localPosition);
    }
  }
}
