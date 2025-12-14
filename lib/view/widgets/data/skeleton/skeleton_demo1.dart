import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:toly_skeleton/toly_skeleton.dart';

@DisplayNode(
  title: '基础骨架屏',
  desc: '展示骨架屏的基础用法。最简单的占位效果，包含标题和段落占位。',
)
class SkeletonDemo1 extends StatelessWidget {
  const SkeletonDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return const TolySkeleton();
  }
}
