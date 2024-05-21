import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/navigation/drop_menu/menu_display/drop_menu.dart';
import 'package:tolyui/tolyui.dart';

import '../../../debugger/debugger.dart';
import '../../widgets.dart';
import 'menu_display/menu_item_display.dart';

class DropMenuDemo1 extends StatelessWidget {
  const DropMenuDemo1({super.key});

  @override
  Widget build(BuildContext context) {

    return Wrap(
      spacing: 20,
      children: [
        TolyDropMenu(
          hoverConfig: const HoverConfig(enterPop: true,exitClose: true),
            onSelect: onSelect,
            menuItems: [
              ActionMenu(const MenuMeta(router: '01', label: '1st menu item')),
              ActionMenu(const MenuMeta(router: '02', label: '2nd menu item')),
              ActionMenu(const MenuMeta(router: '03', label: '3rd menu item'),),
              ActionMenu(const MenuMeta(router: '04', label: '4ur menu item')),
            ],
            // width: 140,
            child: DebugDisplayButton(
              info: 'Hover Pop',
              onPressed: (){},
            ),),
        TolyDropMenu(
            placement: Placement.bottomStart,
            offsetCalculator: boxOffsetCalculator,
            decorationConfig: const DecorationConfig(isBubble: false),
            onSelect: onSelect,
            menuItems: [
              ActionMenu(const MenuMeta(router: '01', label: '1st menu item')),
              ActionMenu(const MenuMeta(router: '02', label: '2nd menu item')),
              ActionMenu(const MenuMeta(router: '03', label: '3rd menu item'),),
              ActionMenu(const MenuMeta(router: '04', label: '4ur menu item')),
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

  void onSelect(
    MenuMeta menu,
  ) {
    $message.success(message: '点击了 [${menu.label}] 个菜单');
  }
}

class SubMenuItem extends StatelessWidget {
  const SubMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.transparent;
    Color forgroundColor = const Color(0xff1f1f1f);
    Widget child = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: backgroundColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: WrapCrossAlignment.e,
        children: [
          Text(
            'Sub66',
            style: TextStyle(color: forgroundColor),
          ),
          const Spacer(),
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
      decorationConfig: const DecorationConfig(isBubble: false),
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
