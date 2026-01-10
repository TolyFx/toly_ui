import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_timeline/tolyui_timeline.dart';

@DisplayNode(
  title: '加载状态',
  desc: '节点支持 loading 属性表示加载，reverse 属性用于控制节点排序。',
)
class TimelineDemo3 extends StatelessWidget {
  const TimelineDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return const TolyTimeline(
      items: [
        TimelineItemData(content: 'Create a services site 2015-09-01'),
        TimelineItemData(content: 'Solve initial network problems 2015-09-01'),
        TimelineItemData(content: 'Technical testing 2015-09-01'),
        TimelineItemData(loading: true, content: 'Recording...'),
      ],
    );
  }
}
