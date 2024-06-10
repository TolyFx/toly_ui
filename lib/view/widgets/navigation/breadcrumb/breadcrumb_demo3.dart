import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '自定义样式',
  desc: '通过 cellStyle 属性，可以设置 BreadcrumbCellStyle 样式配色。如下紫色样式：',
)
class BreadcrumbDemo3 extends StatelessWidget {
  const BreadcrumbDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyBreadcrumb(
      onSelect: context.go,
      cellStyle: BreadcrumbCellStyle(
        disableCellColor: Colors.purple.withOpacity(0.6),
        enableCellColor: Colors.purple,
        hoverCellColor: Colors.purpleAccent,
        lastCellColor: Colors.purple,
        hoverBackgroundStyle: HoverBackgroundStyle(backgroundColor: Colors.purple.withOpacity(0.1)),
      ),
      separator: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Text('>', style: TextStyle(color: Colors.grey)),
      ),
      items: [
        MenuMeta(label: 'Home', router: '/', icon: Icons.add_home_work_rounded),
        MenuMeta(label: 'Widget', router: '/widgets', icon: Icons.widgets),
        MenuMeta(label: 'Navigation'),
        MenuMeta(label: 'Breadcrumb'),
      ],
    );
  }
}
