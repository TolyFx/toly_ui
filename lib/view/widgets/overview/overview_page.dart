import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/app/theme/theme.dart';
import 'package:toly_ui/navigation/menu/advanced.dart';
import 'package:toly_ui/navigation/menu/basic.dart';
import 'package:toly_ui/navigation/menu/data.dart';
import 'package:toly_ui/navigation/menu/feedback.dart';
import 'package:toly_ui/navigation/menu/form.dart';
import 'package:toly_ui/navigation/menu/navigation.dart';
import 'package:tolyui/tolyui.dart';

import '../../../incubator/components/layout/grid_layout/wrap_grid_layout.dart';
import 'display_map.dart';

final PageStorageBucket _bucket = PageStorageBucket();

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  String _searchQuery = '';

  @override
  void initState() {
    print("_OverviewPageState#initState=========");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int totalCount = basicMenus['children'].length +
        formMenus['children'].length +
        navigationMenus['children'].length +
        dataMenus['children'].length +
        feedbackMenus['children'].length +
        advancedMenus['children'].length;

    return PageStorage(
      bucket: _bucket,
      child: Scaffold(
        body: Padding$(
          padding: (re) => switch (re) {
            Rx.xs => const EdgeInsets.symmetric(horizontal: 20),
            _ => const EdgeInsets.symmetric(horizontal: 48),
          },
          child: ListView(
            key: PageStorageKey<String>('pageOne'),
            // padding: EdgeInsets.symmetric(horizontal: 48),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Row(
                  children: [
                    Text(
                      'Overview 组件总览',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Text(
                        '$totalCount',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    WindowRespondBuilder(builder: (_, r) {
                      if (r.index > 1)
                        SizedBox(
                          width: 300,
                          child: TolyInput(
                            hintText: '搜索组件...',
                            prefixIcon: Icon(Icons.search,
                                size: 18, color: Colors.grey),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value.toLowerCase();
                              });
                            },
                          ),
                        );
                      return Icon(Icons.search, size: 18, color: Colors.grey);
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                  '以下是 Toly UI 提供的所有组件，包括基础组件、表单组件、导航系统、数据展示、高级组件、反馈组件六大类别；\n'
                  '另外 TolyUI 体系中也包括 Flutter 支持的框架内部件，'
                  '将在面板中通过 Flutter Logo示意。',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 24),
              buildByMenuNode(basicMenus),
              const SizedBox(height: 24),
              buildByMenuNode(formMenus),
              const SizedBox(height: 24),
              buildByMenuNode(navigationMenus),
              const SizedBox(height: 24),
              buildByMenuNode(dataMenus),
              const SizedBox(height: 24),
              buildByMenuNode(feedbackMenus),
              const SizedBox(height: 24),
              buildByMenuNode(advancedMenus),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildByMenuNode(Map<String, dynamic> menu) {
    List<OverviewItem> items = menu['children']
        .map<OverviewItem>((e) => OverviewItem(
            name: e['label'],
            label: '${e['label']} ${e['subtitle']}',
            path: '${menu['path']}${e['path']}'))
        .toList();

    if (_searchQuery.isNotEmpty) {
      items = items
          .where((item) =>
              item.name.toLowerCase().contains(_searchQuery) ||
              item.label.toLowerCase().contains(_searchQuery))
          .toList();

      if (items.isEmpty) return SizedBox.shrink();
    }

    return OverviewCell(
      title: menu['label'],
      items: items,
      searchQuery: _searchQuery,
    );
  }
}

class OverviewItem {
  final String name;
  final String label;
  final String path;

  OverviewItem({
    required this.name,
    required this.path,
    required this.label,
  });
}

class OverviewCell extends StatelessWidget {
  final String title;
  final List<OverviewItem> items;
  final String searchQuery;

  const OverviewCell({
    super.key,
    required this.title,
    required this.items,
    this.searchQuery = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                '${items.length}',
                style: TextStyle(fontSize: 12, color: Colors.blue),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Wrap$(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.zero,
            measureWidth: 280,
            expandType: ExpandType.width,
            height: 180,
            spacing: 24,
            runSpacing: 24,
            children: items
                .asMap()
                .entries
                .map((entry) => OverviewWidgetCell(
                      item: entry.value,
                      highlight: searchQuery.isNotEmpty && entry.key < 2,
                    ))
                .toList())
        // GridView(gridDelegate: gridDelegate)
      ],
    );
  }
}

class OverviewWidgetCell extends StatefulWidget {
  final OverviewItem item;
  final bool highlight;

  const OverviewWidgetCell(
      {super.key, required this.item, this.highlight = false});

  @override
  State<OverviewWidgetCell> createState() => _OverviewWidgetCellState();
}

class _OverviewWidgetCellState extends State<OverviewWidgetCell> {
  bool hover = false;

  List<BoxShadow>? get shadow => hover || widget.highlight
      ? [
          BoxShadow(
            color: widget.highlight
                ? Colors.orange.withOpacity(0.3)
                : Color(0xffe8f3ff),
            spreadRadius: 2,
            blurRadius: 6,
          )
        ]
      : null;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hover = true;
        });
      },
      onExit: (_) {
        setState(() {
          hover = false;
        });
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          context.go(widget.item.path);
        },
        child: Container(
          decoration: BoxDecoration(
              boxShadow: shadow,
              color: Colors.white,
              border: Border.all(
                color:
                    widget.highlight ? Colors.orange : const Color(0xffdcdfe6),
                width: widget.highlight ? 2 : px1,
              ),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Text(
                    widget.item.label,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Divider(),
              Expanded(
                  child: IgnorePointer(
                child: Container(
                  alignment: Alignment.center,
                  child: overviewDisplayMap(widget.item.name),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    color: Color(0xfff5f7fa),
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
