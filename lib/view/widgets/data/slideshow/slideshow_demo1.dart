import 'package:flutter/material.dart';

import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: '基础用法',
  desc: '最基本的幻灯片的用法。',
)
class SlideshowDemo1 extends StatelessWidget {
  const SlideshowDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("幻灯片"),
    );
  }
}
