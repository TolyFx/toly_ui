import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

class DropMenuDemo7 extends StatelessWidget{
  const DropMenuDemo7({super.key});

  @override
  Widget build(BuildContext context) {
    Color bgColor = context.isDark? const Color(0xff303133):Colors.white;
    return TolyDropMenu(
      onSelect: onSelect,
      decorationConfig:  DecorationConfig(isBubble: false,backgroundColor: bgColor),
      placement: Placement.topStart,
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
      childBuilder: _childBuilder,
    );
  }

  void onSelect(MenuMeta menu) {
    $message.success(message: '点击了 [${menu.label}] 菜单');
  }

  void _onSecondaryTapDown(TapDownDetails details, PopoverController ctrl) async {
    if (ctrl.isOpen) {
      ctrl.close();
      await Future.delayed(const Duration(milliseconds: 280));
    }
    ctrl.open(position: details.localPosition);
  }

  Widget _childBuilder(_, PopoverController ctrl, __) {
    return GestureDetector(
      onTapDown: (_) => ctrl.close(),
      onSecondaryTapDown: (detail) => _onSecondaryTapDown(detail, ctrl),
      child: Container(
        color: const Color(0xfff7f7f7),
        alignment: Alignment.center,
        height: 180,
        child: const Text('Right Click on here'),
      ),
    );
  }
}
