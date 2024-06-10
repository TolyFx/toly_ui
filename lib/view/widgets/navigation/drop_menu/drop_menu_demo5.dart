import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

import '../../../debugger/debugger.dart';

@DisplayNode(
  title: '修改样式',
  desc: '可以通过 DropMenuCellStyle 修改菜单项样式。包括背景色、前景色、边距、圆角等属性。',
)
class DropMenuDemo5 extends StatelessWidget {
  const DropMenuDemo5({super.key});

  @override
  Widget build(BuildContext context) {
    DropMenuCellStyle lightStyle = const DropMenuCellStyle(
      padding: EdgeInsets.symmetric(horizontal: 8),
      borderRadius: BorderRadius.all(Radius.circular(6)),
      foregroundColor: Color(0xff1f1f1f),
      backgroundColor: Colors.transparent,
      disableColor: Color(0xffbfbfbf),
      hoverBackgroundColor: Color(0xfff5f5f5),
      hoverForegroundColor: Color(0xff1f1f1f),
    );

    DropMenuCellStyle darkStyle = const DropMenuCellStyle(
      padding: EdgeInsets.symmetric(horizontal: 8),
      borderRadius: BorderRadius.all(Radius.circular(6)),
      foregroundColor: Color(0xffcfd3dc),
      backgroundColor: Colors.transparent,
      disableColor: Colors.grey,
      hoverBackgroundColor: Color(0xff313131),
      hoverForegroundColor: Color(0xffcfd3dc),
    );
    return Wrap(
      spacing: 20,
      children: [
        display(context, lightStyle, Colors.white, 'light'),
        display(context, darkStyle, const Color(0xff1f1f1f), 'dark'),
      ],
    );
  }

  Widget display(
    BuildContext context,
    DropMenuCellStyle style,
    Color bgColor,
    String label,
  ) {
    return TolyDropMenu(
        onSelect: onSelect,
        style: style,
        subMenuGap: 6,
        placement: Placement.bottomStart,
        decorationConfig: DecorationConfig(isBubble: false, backgroundColor: bgColor),
        offsetCalculator: boxOffsetCalculator,
        menuItems: [
          ActionMenu(const MenuMeta(router: '01', label: '1st menu item')),
          ActionMenu(const MenuMeta(router: '02', label: '2nd menu item')),
          SubMenu(const MenuMeta(router: 'export', label: 'export image'), menus: [
            ActionMenu(const MenuMeta(router: 'png', label: 'sub out .png')),
            ActionMenu(const MenuMeta(router: 'jpeg', label: 'sub out .jpeg')),
            ActionMenu(const MenuMeta(router: 'svg', label: 'sub out .svg')),
            SubMenu(const MenuMeta(router: 'sub sub', label: 'sub sub menu'), menus: [
              ActionMenu(const MenuMeta(router: 's1', label: 'sub menu1')),
              ActionMenu(const MenuMeta(router: 's2', label: 'sub menu2')),
              ActionMenu(const MenuMeta(router: 's3', label: 'sub menu3')),
            ]),
          ]),
          const DividerMenu(),
          ActionMenu(const MenuMeta(router: '03', label: '3rd menu item'), enable: false),
          ActionMenu(const MenuMeta(router: '04', label: '4ur menu item')),
        ],
        // width: 160,
        childBuilder: (_, ctrl, __) {
          return DebugDisplayButton(
            info: 'DIY Style#$label',
            onPressed: ctrl.open,
          );
        });
  }

  void onSelect(MenuMeta menu) {
    $message.success(message: '点击了 [${menu.label}] 菜单');
  }
}
