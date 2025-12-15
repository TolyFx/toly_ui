import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_skeleton/tolyui_skeleton.dart';

@DisplayNode(
  title: '元素组合',
  desc: '展示不同类型的骨架屏元素。包括按钮、头像、输入框和图片占位，可以灵活组合使用。',
)
class SkeletonDemo5 extends StatefulWidget {
  const SkeletonDemo5({super.key});

  @override
  State<SkeletonDemo5> createState() => _SkeletonDemo5State();
}

class _SkeletonDemo5State extends State<SkeletonDemo5> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SkeletonButton(active: _active),
            SkeletonAvatar(active: _active),
            SkeletonInput(active: _active, width: 160),
          ],
        ),
        const SizedBox(height: 16),
        SkeletonButton(active: _active, block: true),
        const SizedBox(height: 16),
        SkeletonInput(active: _active, block: true),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          children: [
            SkeletonImage(active: _active),
            SkeletonAvatar(active: _active, size: 96, circle: false),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('动画效果'),
            const SizedBox(width: 8),
            Switch(
              value: _active,
              onChanged: (v) => setState(() => _active = v),
            ),
          ],
        ),
      ],
    );
  }
}
