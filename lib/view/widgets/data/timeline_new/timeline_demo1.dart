import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_timeline/tolyui_timeline.dart';

@DisplayNode(
  title: '基础时间轴',
  desc: '基本的时间轴展示，通过 items 属性传入时间节点数据。',
)
class TimelineDemo1 extends StatelessWidget {
  const TimelineDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyTimeline(
      items: const [
        TimelineItemData(content: 'Create a services site 2015-09-01'),
        TimelineItemData(content: 'Solve initial network problems 2015-09-01'),
        TimelineItemData(content: 'Technical testing 2015-09-01'),
        TimelineItemData(content: 'Network problems being solved 2015-09-01'),
      ],
    );
  }
}
