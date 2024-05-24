import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/incubator/components/navigation/toly_breadcrumb.dart';
import 'package:tolyui/tolyui.dart';

class BreadcrumbDemo2 extends StatelessWidget {
  const BreadcrumbDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyBreadcrumb(
      onSelect: context.go,
      separator: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
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
