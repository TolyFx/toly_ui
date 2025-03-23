import 'package:flutter/material.dart';
import 'package:toly_ui/app/theme/theme.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '基础用法',
  desc: '通过 TolyTabs 展示标签页，可容纳 MenuMeta 列表展示条目，onSelect 回调中处理点击条目事件，可用于路由跳转或者状态切换。',
)
class TabsDemo1 extends StatefulWidget {
  const TabsDemo1({super.key});

  @override
  State<TabsDemo1> createState() => _TabsDemo1State();
}

class _TabsDemo1State extends State<TabsDemo1> with TickerProviderStateMixin {
  List<MenuMeta> items = const [
    MenuMeta(label: 'Tab1', route: 'tab1'),
    MenuMeta(label: 'Tab2', route: 'tab2'),
    MenuMeta(label: 'Tab3', route: 'tab3'),
    MenuMeta(label: 'Tab4', route: 'tab4'),
  ];

  String activeId = 'tab1';

  MenuMeta get activeMenu => items.singleWhere((e) => e.id == activeId);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TolyTabs(dividerHeight: px1, tabs: items, activeId: activeId, onSelect: _onSelect),
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
