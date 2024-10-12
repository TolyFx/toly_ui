import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/app/theme/theme.dart';
import 'package:toly_ui/incubator/components/data/tag/tag.dart';
import 'package:toly_ui/incubator/ext/go_router/path.dart';
import 'package:toly_ui/navigation/menu/advance.dart';
import 'package:toly_ui/navigation/menu/basic.dart';
import 'package:toly_ui/navigation/menu/data.dart';
import 'package:toly_ui/navigation/menu/feedback.dart';
import 'package:toly_ui/navigation/menu/form.dart';
import 'package:toly_ui/navigation/menu/navigation.dart';

import '../../../incubator/components/layout/grid_layout/wrap_grid_layout.dart';
import 'display_map.dart';

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 48),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              'Overview 组件总览',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
              '以下是 Toly UI 提供的所有组件，包括基础组件、表单组件、导航系统、数据展示、高级组件、反馈组件六大类别；\n'
              '另外 TolyUI 体系中也包括 Flutter 支持的框架内部件，'
              '将在面板中通过 Flutter Logo示意。',
              style: TextStyle(fontSize: 16)),
          const SizedBox(height: 24),
          // buildByMenuNode(dataMenus),
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
          buildByMenuNode(advanceMenus),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget buildByMenuNode(Map<String, dynamic> menu) {
    return OverviewCell(
      title: menu['label'],
      items: menu['children']
          .map<OverviewItem>((e) => OverviewItem(
              name: e['label'],
              label: '${e['label']} ${e['subtitle']}',
              path: '${menu['path']}${e['path']}'))
          .toList(),
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

  const OverviewCell({
    super.key,
    required this.title,
    required this.items,
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
            TolyTag(
              tagText: '${items.length}',
              padding: EdgeInsets.symmetric(horizontal: 8),
              radius: 6,
            )
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Wrap$(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(),
            maxWidth: 300,
            height: 180,
            spacing: 24,
            runSpacing: 24,
            children: items.map((e) => OverviewWidgetCell(item: e)).toList())
        // GridView(gridDelegate: gridDelegate)
      ],
    );
  }
}

class OverviewWidgetCell extends StatefulWidget {
  final OverviewItem item;

  const OverviewWidgetCell({super.key, required this.item});

  @override
  State<OverviewWidgetCell> createState() => _OverviewWidgetCellState();
}

class _OverviewWidgetCellState extends State<OverviewWidgetCell> {
  bool hover = false;

  List<BoxShadow>? get shadow => hover
      ? [
          BoxShadow(
            color: Color(0xffe8f3ff),
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
              border: Border.all(color: const Color(0xffdcdfe6), width: px1),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              FractionallySizedBox(
                widthFactor: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
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
