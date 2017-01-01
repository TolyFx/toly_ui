import 'package:flutter/material.dart';
import 'package:toly_ui/app/res/toly_icon.dart';
import 'package:tolyui_navigation/src/tabs/toly_tabs.dart';
import 'package:toly_ui/view/debugger/debugger.dart';
import 'package:tolyui/tolyui.dart';

import '../../../../app/theme/theme.dart';

class TabsDemo4 extends StatefulWidget {
  const TabsDemo4({super.key});

  @override
  State<TabsDemo4> createState() => _TabsDemo4State();
}

class _TabsDemo4State extends State<TabsDemo4> with TickerProviderStateMixin {

  List<MenuMeta> items = const [
    MenuMeta(label: 'Tab1', router: 'tab1',icon: Icons.anchor),
    MenuMeta(label: 'Tab2', router: 'tab2',icon: Icons.ramp_right),
    MenuMeta(label: 'Tab3', router: 'tab3',icon: Icons.cable),
    MenuMeta(label: 'Tab4', router: 'tab4',icon: Icons.account_box_rounded),
  ];

  String activeId = 'tab1';

  MenuMeta get activeMenu => items.singleWhere((e) => e.id == activeId);

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = const EdgeInsets.only(left: 16, right: 16, bottom: 12,top: 12);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TolyTabs(
          dividerHeight: px1,
            leading: _buildLeading(),
            tail: _buildTail(),
            alignment: TabAlignment.center,
            labelPadding: padding,
            tabs: items, activeId: activeId, onSelect: _onSelect,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text('Content of ${activeMenu.label}'),
        )
      ],
    );
  }

  Widget _buildLeading()=>const Wrap(
    spacing: 6,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      FlutterLogo(),
      Text('Flutter&TolyUI')
    ],
  );

  Widget _buildTail()=>const Wrap(
      spacing: 8,
      children:[
        Icon(Icons.add),
        Icon(Icons.travel_explore_rounded),
        Icon(Icons.more_horiz_outlined),
      ]);

  void _onSelect(MenuMeta meta) {
    activeId = meta.id;
    setState(() {});
  }
}


