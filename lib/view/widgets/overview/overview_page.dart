import 'package:flutter/material.dart';
import 'package:toly_ui/app/theme/theme.dart';

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
            child: Text('Overview 组件总览',style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold
            ),),
          ),
          Text('以下是 Toly UI 提供的所有组件，其中包括 Flutter 支持的框架内部件。',style: TextStyle(
              fontSize: 16
          )),
          const SizedBox(height: 24,),

          OverviewCell(
            title: 'Basic 基础组件',

            items: [
              OverviewItem(name: 'Button', label: 'Button 按钮'),
              OverviewItem(name: 'Icon', label: 'Icon 图标'),
              OverviewItem(name: 'Text', label: 'Text 文字'),
              OverviewItem(name: 'Layout', label: 'Layout 布局'),
              OverviewItem(name: 'Link', label: 'Link 链接'),
            ],
          )
        ],
      ),
    );
  }
}

class OverviewItem {
  final String name;
  final String label;

  OverviewItem({
    required this.name,
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
        Text(title,style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
        ),),
        const SizedBox(height: 16,),
        Wrap$(
          padding: EdgeInsets.symmetric(),
            maxWidth: 300,
            height: 180,
            spacing: 24,
            runSpacing: 24,
            children: items
                .map((e) => OverviewWidgetCell(
                      item: e,
                    ))
                .toList())
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

  List<BoxShadow>? get shadow =>hover?[
    BoxShadow(
      color: Color(0xffe8f3ff),
      spreadRadius: 2,
      blurRadius: 6,
    )
  ]:null;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_){
        setState(() {
          hover=true;
        });
      },
      onExit: (_){
        setState(() {
          hover=false;
        });
      },
      cursor: SystemMouseCursors.click,
      child: Container(
        decoration: BoxDecoration(
            boxShadow: shadow,
            color: Colors.white,
            border: Border.all(color: const Color(0xffdcdfe6),width: px1),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
                child: Text(widget.item.label,style: TextStyle(fontSize: 16),),
              ),
            ),
            Divider(),
            Expanded(
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
            ))
          ],
        ),
      ),
    );
  }
}


