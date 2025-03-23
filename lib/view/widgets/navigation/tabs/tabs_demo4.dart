import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

import '../../../../app/theme/theme.dart';

@DisplayNode(
  title: '首尾组件',
  desc: '通过 leading和tail 属性，可以设置左右的首尾组件：',
)
class TabsDemo4 extends StatefulWidget {
  const TabsDemo4({super.key});

  @override
  State<TabsDemo4> createState() => _TabsDemo4State();
}

class _TabsDemo4State extends State<TabsDemo4> with TickerProviderStateMixin {
  List<MenuMeta> items = [
    IconMenu( Icons.anchor,label: 'Tab1', route: 'tab1'),
    IconMenu( Icons.ramp_right,label: 'Tab2', route: 'tab2'),
    IconMenu( Icons.cable,label: 'Tab3', route: 'tab3'),
    IconMenu( Icons.account_box_rounded,label: 'Tab4', route: 'tab4'),
  ];

  String activeId = 'tab1';

  MenuMeta get activeMenu => items.singleWhere((e) => e.id == activeId);

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = const EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 12);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TolyTabs(
          dividerHeight: px1,
          leading: _buildLeading(),
          tail: _buildTail(),
          alignment: TabAlignment.center,
          labelPadding: padding,
          tabs: items,
          activeId: activeId,
          onSelect: _onSelect,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text('Content of ${activeMenu.label}'),
        )
      ],
    );
  }

  Widget _buildLeading() => const Wrap(
        spacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [FlutterLogo(), Text('Flutter&TolyUI')],
      );

  Widget _buildTail() => const Wrap(spacing: 8, children: [
        Icon(Icons.add),
        Icon(Icons.travel_explore_rounded),
        Icon(Icons.more_horiz_outlined),
      ]);

  void _onSelect(MenuMeta meta) {
    activeId = meta.id;
    setState(() {});
  }
}
