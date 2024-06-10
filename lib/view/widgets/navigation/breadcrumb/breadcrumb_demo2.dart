import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(title: '自定义分隔符', desc: '可以通过 separator 参数自定义分隔符组件；MenuMeta 中的 Icon 可以设置菜单项的图标。')
class BreadcrumbDemo2 extends StatelessWidget {
  const BreadcrumbDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyBreadcrumb(
      onSelect: context.go,
      separator: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text('>', style: TextStyle(color: Colors.grey)),
      ),
      items: const [
        MenuMeta(label: 'Home', router: '/', icon: Icons.add_home_work_rounded),
        MenuMeta(label: 'Widget', router: '/widgets', icon: Icons.widgets),
        MenuMeta(label: 'Navigation'),
        MenuMeta(label: 'Breadcrumb'),
      ],
    );
  }
}
