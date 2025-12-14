import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:toly_skeleton/toly_skeleton.dart';

@DisplayNode(
  title: '动画效果',
  desc: '展示骨架屏的动画效果。通过 active 属性启用波浪动画，让占位效果更生动。',
)
class SkeletonDemo2 extends StatelessWidget {
  const SkeletonDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return const TolySkeleton(active: true);
  }
}
