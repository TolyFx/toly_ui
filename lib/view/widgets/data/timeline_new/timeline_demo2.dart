import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_timeline/tolyui_timeline.dart';

@DisplayNode(
  title: '自定义节点',
  desc: '可以设置为图标或其他自定义元素。通过 icon 属性自定义节点图标，同时支持 color 属性设置颜色。',
)
class TimelineDemo2 extends StatelessWidget {
  const TimelineDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return const TolyTimeline(
      items: [
        TimelineItemData(content: 'Create a services site 2015-09-01'),
        TimelineItemData(content: 'Solve initial network problems 2015-09-01'),
        TimelineItemData(
          icon: Icon(Icons.access_time, color: Colors.red, size: 20),
          color: Colors.red,
          content: 'Technical testing 2015-09-01',
        ),
        TimelineItemData(content: 'Network problems being solved 2015-09-01'),
      ],
    );
  }
}
