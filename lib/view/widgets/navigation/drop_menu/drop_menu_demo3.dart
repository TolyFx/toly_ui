import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

import '../../../debugger/debugger.dart';

@DisplayNode(
  title: '子菜单',
  desc: '通过 SubMenu 提供子菜单的元数据，可通过 TolyDropMenu#subMenuGap 参数，调节弹出子面板的间距。',
)
class DropMenuDemo3 extends StatelessWidget {
  const DropMenuDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      children: [
        display(context),
        display(context, gap: 6),
      ],
    );
  }

  Widget display(BuildContext context, {double gap = 0}) {
    Color bgColor = context.isDark ? const Color(0xff303133) : Colors.white;

    return TolyDropMenu(
        onSelect: onSelect,
        onClose: () {
          print("=====onClose========");
        },
        onCloseSubMeu: (route) {
          print("=====onCloseSubMeu:${route}========");
        },
        subMenuGap: gap,
        placement: Placement.bottomStart,
        hoverConfig: HoverConfig(enterPop: true),
        decorationConfig:
            DecorationConfig(isBubble: false, backgroundColor: bgColor),
        offsetCalculator: boxOffsetCalculator,
        menuItems: [
          ActionMenu(const MenuMeta(route: '01', label: '1st menu item')),
          ActionMenu(const MenuMeta(route: '02', label: '2nd menu item')),
          SubMenu(const MenuMeta(route: 'save', label: 'save'), menus: [
            ActionMenu(const MenuMeta(route: 'png', label: 'sub out .png')),
            ActionMenu(const MenuMeta(route: 'jpeg', label: 'sub out .jpeg')),
            ActionMenu(const MenuMeta(route: 'svg', label: 'sub out .svg')),
            SubMenu(const MenuMeta(route: 'sub sub', label: 'sub sub menu'),
                menus: [
                  ActionMenu(const MenuMeta(route: 's1', label: 'sub menu1')),
                  ActionMenu(const MenuMeta(route: 's2', label: 'sub menu2')),
                  ActionMenu(const MenuMeta(route: 's3', label: 'sub menu3')),
                ]),
          ]),
          SubMenu(const MenuMeta(route: 'export', label: 'export'), menus: [
            ActionMenu(const MenuMeta(route: 'png', label: 'sub out .png')),
            ActionMenu(const MenuMeta(route: 'jpeg', label: 'sub out .jpeg')),
            ActionMenu(const MenuMeta(route: 'svg', label: 'sub out .svg')),
            SubMenu(const MenuMeta(route: 'sub sub', label: 'sub sub menu'),
                menus: [
                  ActionMenu(const MenuMeta(route: 's1', label: 'sub menu1')),
                  ActionMenu(const MenuMeta(route: 's2', label: 'sub menu2')),
                  ActionMenu(const MenuMeta(route: 's3', label: 'sub menu3')),
                ]),
          ]),
          const DividerMenu(),
          ActionMenu(const MenuMeta(route: '03', label: '3rd menu item'),
              enable: false),
          ActionMenu(const MenuMeta(route: '04', label: '4ur menu item')),
        ],
        // width: 160,
        childBuilder: (_, ctrl, __) {
          return DebugDisplayButton(
            info: 'SubMenu:gap#$gap',
            onPressed: ctrl.open,
          );
        });
  }

  void onSelect(MenuMeta menu) {
    $message.success(message: '点击了 [${menu.label}] 菜单');
  }
}

// class SubMenuItem extends StatelessWidget {
//   const SubMenuItem({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     Color backgroundColor = Colors.transparent;
//     Color forgroundColor = Color(0xff1f1f1f);
//     Widget child = Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(6),
//         color: backgroundColor,
//       ),
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         // crossAxisAlignment: WrapCrossAlignment.e,
//         children: [
//           Text(
//             'Sub66',
//             style: TextStyle(color: forgroundColor),
//           ),
//           Spacer(),
//           // const SizedBox(width: 20,),
//           const Icon(
//             Icons.navigate_next,
//             size: 18,
//           )
//         ],
//       ),
//     );
//
//     return TolyPopover(
//       placement: Placement.rightStart,
//       maxWidth: 200,
//       decorationConfig: DecorationConfig(isBubble: false),
//       overlay: const DisplayPanel(),
//       builder: (_, ctrl, __) {
//         return GestureDetector(onTap: ctrl.open, child: child);
//       },
//     );
//   }
// }
