

import 'package:flutter/material.dart';

import '../../display_nodes/display_nodes.dart';

/// create by 张风捷特烈 on 2020/4/27
/// contact me by email 1981462002@qq.com
/// 说明:

@DisplayNode(
  title: '用于显示一个图标',
  desc: 'Icon 组件使用 Flutter 框架内部的组件。',
)
class IconDemo1 extends StatelessWidget {
  const IconDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 40,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(Icons.anchor, color: Colors.orange, size: 20),
        Icon(Icons.security, color: Colors.red, size: 40),
        Icon(Icons.date_range_outlined, color: Colors.green, size: 60),
        Icon(Icons.tab_unselected_outlined, color: Colors.blue, size: 80),
      ],
    );
  }
}