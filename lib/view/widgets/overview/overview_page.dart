import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/app/theme/theme.dart';
import 'package:toly_ui/incubator/components/data/tag/tag.dart';
import 'package:toly_ui/incubator/ext/go_router/path.dart';

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

          OverviewCell(
            title: 'Basic 基础组件',
            items: [
              OverviewItem(name: 'Action', label: 'Action 动作', path: '/widgets/basic/action'),
              OverviewItem(name: 'Button', label: 'Button 按钮', path: '/widgets/basic/button'),
              OverviewItem(name: 'Icon', label: 'Icon 图标', path: '/widgets/basic/icon'),
              OverviewItem(name: 'Text', label: 'Text 文字', path: '/widgets/basic/text'),
              OverviewItem(name: 'Layout', label: 'Layout 布局', path: '/widgets/basic/layout'),
              OverviewItem(name: 'Link', label: 'Link 链接', path: '/widgets/basic/link'),
            ],
          ),
          const SizedBox(height: 24),
          OverviewCell(
            title: 'Form 表单组件',
            items: [
              OverviewItem(name: 'Autocomplete', label: 'Autocomplete 自动补全', path: '/widgets/form/Autocomplete'),
              OverviewItem(name: 'ColorPicker', label: 'ColorPicker 颜色选择', path: '/widgets/form/ColorPicker'),
              OverviewItem(name: 'DatePicker', label: 'DatePicker 日期选择器', path: '/widgets/form/DatePicker'),
              OverviewItem(name: 'Input', label: 'Input 输入框', path: '/widgets/form/input'),
              OverviewItem(name: 'Select', label: 'Select 选择器', path: '/widgets/form/select'),
              OverviewItem(name: 'Transfer', label: 'Transfer 穿梭框', path: '/widgets/form/transfer'),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          OverviewCell(
            title: 'Navigation 导航组件',
            items: [
              OverviewItem(name: 'Anchor', label: 'Anchor 锚点', path: '/widgets/navigation/Anchor'),
              OverviewItem(name: 'Breadcrumb', label: 'Breadcrumb 面包屑', path: '/widgets/navigation/breadcrumb'),
              OverviewItem(name: 'DropMenu', label: 'DropMenu 下拉菜单', path: '/widgets/navigation/drop_menu'),
              OverviewItem(name: 'RailMenuTree', label: 'RailMenuTree 树形菜单', path: '/widgets/navigation/input'),
              OverviewItem(name: 'RailMenuBar', label: 'RailMenuBar 侧栏菜单', path: '/widgets/navigation/rail_menu_bar'),
              OverviewItem(name: 'Tabs', label: 'Tabs 标签页', path: '/widgets/navigation/tabs'),
              OverviewItem(name: 'Steps', label: 'Steps 步骤条', path: '/widgets/navigation/steps'),
            ],
          ),

          const SizedBox(height: 24),

        ],
      ),
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
              tagText: '${items.length}',padding: EdgeInsets.symmetric(horizontal: 8),radius: 6,)
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
