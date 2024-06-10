import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

import '../../../../app/theme/theme.dart';

@DisplayNode(
  title: '图标与居中',
  desc: 'MenuMeta 设置 icon 属性时，展示对应图标。通过 alignment: TabAlignment.center 可以将页签居中',
)
class TabsDemo3 extends StatefulWidget {
  const TabsDemo3({super.key});

  @override
  State<TabsDemo3> createState() => _TabsDemo3State();
}

class _TabsDemo3State extends State<TabsDemo3> with TickerProviderStateMixin {
  List<MenuMeta> items = [
    MenuMeta(label: 'Tab1', router: 'tab1', icon: Icons.anchor),
    MenuMeta(label: 'Tab2', router: 'tab2', icon: Icons.ramp_right),
    MenuMeta(label: 'Tab3', router: 'tab3', icon: Icons.cable),
    MenuMeta(label: 'Tab4', router: 'tab4', icon: Icons.account_box_rounded),
  ];

  String activeId = 'tab1';

  MenuMeta get activeMenu => items.singleWhere((e) => e.id == activeId);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TolyTabs(
            dividerHeight: px1,
            alignment: TabAlignment.center,
            tabs: items,
            activeId: activeId,
            onSelect: _onSelect),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text('Content of ${activeMenu.label}'),
        )
      ],
    );
  }

  void _onSelect(MenuMeta meta) {
    activeId = meta.id;
    setState(() {});
  }
}
