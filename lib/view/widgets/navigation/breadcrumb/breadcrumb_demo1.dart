import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '基础用法',
  desc:
      '通过 TolyBreadcrumb 展示面包屑，可容纳 MenuMeta 列表展示条目，默认通过 "/" 分隔。\nonSelect 回调中处理点击条目事件，可用于路由跳转。不设置 router 的条目，将无法响应点击事件，呈灰色展示。',
)
class BreadcrumbDemo1 extends StatelessWidget {
  const BreadcrumbDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyBreadcrumb(
      onSelect: context.go,
      items: const [
        MenuMeta(label: 'Home', route: '/'),
        MenuMeta(label: 'Widget', route: '/widgets'),
        MenuMeta(label: 'Navigation',route: ''),
        MenuMeta(label: 'Breadcrumb',route: ''),
      ],
    );
  }
}
