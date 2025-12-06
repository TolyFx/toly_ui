import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/data/tags/src/tag.dart';
import 'package:tolyui/data/tags/src/types.dart';

@DisplayNode(
  title: '基础标签',
  desc: '最基本的标签用法，支持不同颜色和变体样式。包括填充、边框、实心三种视觉风格，适用于分类标记、状态展示等场景。',
)
class TagDemo1 extends StatelessWidget {
  const TagDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        Tag(child: Text('默认')),
        Tag(
          variant: TagVariant.filled,
          color: Colors.blue,
          child: Text('填充'),
        ),
        Tag(
          variant: TagVariant.outlined,
          color: Colors.green,
          child: Text('边框'),
        ),
        Tag(
          variant: TagVariant.solid,
          color: Colors.orange,
          child: Text('实心'),
        ),
        Tag(
          color: Colors.red,
          child: Text('红色'),
        ),
        Tag(
          color: Colors.purple,
          child: Text('紫色'),
        ),
      ],
    );
  }
}
