import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:toly_skeleton/toly_skeleton.dart';

@DisplayNode(
  title: '复杂组合',
  desc: '展示包含头像的复杂骨架屏。通过 avatar 属性添加头像占位，paragraphRows 控制段落行数。',
)
class SkeletonDemo3 extends StatelessWidget {
  const SkeletonDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return const TolySkeleton(
      avatar: true,
      paragraphRows: 4,
    );
  }
}
