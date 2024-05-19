import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tolyui/tolyui.dart';

import '../../../debugger/debugger.dart';
import '../../widgets.dart';
import 'menu_display/action_menu_item.dart';
import 'menu_display/menu_item_diaplsy.dart';

class DropMenuDemo1 extends StatelessWidget {
  const DropMenuDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      children: [
        TolyPopover(
          // overlayDecorationBuilder: decorationBuilder,
          placement: Placement.bottom,
          maxWidth:140,
          overlayBuilder: (_, ctrl) => MenuListPanel(
            menus: [
              ActionMenuDisplay(MenuMeta(router: '01', label: '1st menu item'),onSelect: (m)=>onSelect(m,ctrl)),
              ActionMenuDisplay(MenuMeta(router: '02', label: '2nd menu item'),onSelect: (m)=>onSelect(m,ctrl)),
              ActionMenuDisplay(MenuMeta(router: '03', label: '3rd menu item'),onSelect: null),
              const DividerMenuDisplay(),
              ActionMenuDisplay(MenuMeta(router: '04', label: '4ur menu item'),onSelect: (m)=>onSelect(m,ctrl)),
            ],
            // onSelect: (MenuMeta menu) {
            //   ctrl.close();
            //   $message.success(message: '点击了 [${menu.label}] 个菜单');
            // },
          ),
          builder: (_, ctrl, __) {
            return DebugDisplayButton(
              info: 'DropMenu',
              onPressed: ctrl.open,
            );
          },
        ),
        TolyPopover(
          // overlayDecorationBuilder: decorationBuilder,
          placement: Placement.bottomStart,
          decorationConfig: DecorationConfig(isBubble: false),
          maxWidth:140,
          offsetCalculator: boxOffsetCalculator,
          overlayBuilder: (_, ctrl) => MenuListPanel(
            menus: [
              ActionMenuDisplay(MenuMeta(router: '01', label: '1st menu item'),onSelect: (m)=>onSelect(m,ctrl)),
              ActionMenuDisplay(MenuMeta(router: '02', label: '2nd menu item'),onSelect: null),
              ActionMenuDisplay(MenuMeta(router: '03', label: '3rd menu item'),onSelect: (m)=>onSelect(m,ctrl)),
              const DividerMenuDisplay(),
              ActionMenuDisplay(MenuMeta(router: '04', label: '4ur menu item'),onSelect: (m)=>onSelect(m,ctrl)),
            ],
            // onSelect: (MenuMeta menu) {
            //   ctrl.close();
            //   $message.success(message: '点击了 [${menu.label}] 个菜单');
            // },
          ),
          builder: (_, ctrl, __) {
            return DebugDisplayButton(
              info: 'DropMenu',
              onPressed: ctrl.open,
            );
          },
        ),
      ],
    );
  }

void onSelect (MenuMeta menu,PopoverController controller,) {
  controller.close();
  $message.success(message: '点击了 [${menu.label}] 个菜单');
  }
}


class MenuListPanel extends StatelessWidget {
  final List<MenuDisplay> menus;

  const MenuListPanel({
    super.key,
    required this.menus,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: menus.map(_mapItem).toList(),
      ),
    );
  }

  Widget _mapItem(MenuDisplay menu) {
    return switch(menu){
      ActionMenuDisplay() => ActionMenuItem(display: menu,),
      DividerMenuDisplay() => DividerMenuItem(display: menu,),
    };
    // bool disable = disableList.contains(menu.id);
    // if (menu.id == '02') {
    //   return SubMenuItem();
    // }
    // if (menu.id == '01') {
    //   return ActionMenuItem(
    //     menu: menu,
    //     onTap: disable ? null : () => onSelect(menu),
    //   );
    // }
    // return ActionMenuItem(
    //   menu: menu,
    //   onTap: disable ? null : () => onSelect(menu),
    // );
    // ActionMenuItem(
    //     child: Text('1st menu item'), onTap: () => onSelect(0)),
    // ActionMenuItem(
    // child: Text('2nd menu item'), onTap: () => onSelect(1)),
    // ActionMenuItem(
    // child: Text('3rd menu item'), onTap: () => onSelect(2)),
    // ActionMenuItem(child: Text('4ur menu item'), onTap: null),
  }
}


class SubMenuItem extends StatelessWidget {
  const SubMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.transparent;
    Color forgroundColor = Color(0xff1f1f1f);
    Widget child = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: backgroundColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: WrapCrossAlignment.e,
        children: [
          Text(
            'Sub66',
            style: TextStyle(color: forgroundColor),
          ),
          Spacer(),
          // const SizedBox(width: 20,),
          const Icon(
            Icons.navigate_next,
            size: 18,
          )
        ],
      ),
    );

    return TolyPopover(
      placement: Placement.rightStart,
      maxWidth: 200,
      decorationConfig: DecorationConfig(isBubble: false),
      overlay: const DisplayPanel(),
      builder: (_, ctrl, __) {
        return GestureDetector(onTap: ctrl.open, child: child);
      },
    );
  }
}

class DebugLayoutPrinter extends StatelessWidget {
  final Widget child;

  const DebugLayoutPrinter({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, cts) {
      print(cts);
      return child;
    });
  }
}
