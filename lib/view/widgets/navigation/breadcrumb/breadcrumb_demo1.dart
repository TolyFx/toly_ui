import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tolyui/tolyui.dart';

class BreadcrumbDemo1 extends StatelessWidget {
  const BreadcrumbDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyBreadcrumb(
      onSelect: context.go,
      items: const [
        MenuMeta(label: 'Home',router: '/'),
        MenuMeta(label: 'Widget',router: '/widgets'),
        MenuMeta(label: 'Navigation'),
        MenuMeta(label: 'Breadcrumb'),
      ],
    );
  }
}
