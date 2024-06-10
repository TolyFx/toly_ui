import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '禁用项与分割线等配置项',
  desc:
      '将 MenuMeta 中的 router 为空字符串时，可禁用对应菜单项;\nshowDivider 置为 false 可隐藏下划线;\nlabelPadding 设置标签四边距；indicatorPadding 设置指示器的四边距。\nindicatorSize 设置称 tab 时，指示器和菜单项宽度一致。',
)
class TabsDemo2 extends StatefulWidget {
  const TabsDemo2({super.key});

  @override
  State<TabsDemo2> createState() => _TabsDemo2State();
}

class _TabsDemo2State extends State<TabsDemo2> with TickerProviderStateMixin {
  List<MenuMeta> items = const [
    MenuMeta(label: 'Tab1', router: 'tab1'),
    MenuMeta(label: 'Tab2', router: ''),
    MenuMeta(label: 'Tab3', router: 'tab3'),
    MenuMeta(label: 'Tab4', router: 'tab4'),
  ];

  String activeId = 'tab1';

  MenuMeta get activeMenu => items.singleWhere((e) => e.id == activeId);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TolyTabs(
          showDivider: false,
          tabs: items,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.symmetric(horizontal: 8),
          activeId: activeId,
          onSelect: _onSelect,
          labelPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
        ),
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
