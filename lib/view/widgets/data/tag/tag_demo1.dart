import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '基础标签',
  desc: '展示标签的基础用法和多样化的视觉风格。第一行演示不同颜色的标签效果，第二行展示四种变体样式：填充、边框、实心、虚线。通过颜色和样式的组合，可以灵活应用于分类标记、状态展示、标签管理等场景。',
)
class TagDemo1 extends StatelessWidget {
  const TagDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 12,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            TolyTag(child: Text('默认样式')),
            TolyTag(color: Colors.red, child: Text('红色 red')),
            TolyTag(color: Colors.purple, child: Text('紫色 purple')),
            TolyTag(color: Colors.green, child: Text('绿色 green')),
          ],
        ),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            TolyTag(
                variant: TagVariant.filled,
                color: Colors.blue,
                child: Text('填充 filled')),
            TolyTag(
                variant: TagVariant.outlined,
                color: Colors.green,
                child: Text('边框 outlined')),
            TolyTag(
              variant: TagVariant.solid,
              color: Colors.orange,
              child: Text('实心 solid'),
            ),
            TolyTag(
              variant: TagVariant.dashed,
              color: Colors.grey,
              child: Text('边线 outlined'),
            ),
          ],
        ),
      ],
    );
  }
}
