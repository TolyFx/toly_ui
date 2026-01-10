import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_timeline/tolyui_timeline.dart';

@DisplayNode(
  title: '右侧时间轴',
  desc: '时间轴点可以在另一侧。通过 mode 属性设置为 end 实现右侧布局。',
)
class TimelineDemo6 extends StatelessWidget {
  const TimelineDemo6({super.key});

  @override
  Widget build(BuildContext context) {
    return const TolyTimeline(
      mode: TimelineMode.end,
      items: [
        TimelineItemData(content: 'Create a services site 2015-09-01'),
        TimelineItemData(content: 'Solve initial network problems 2015-09-01'),
        TimelineItemData(
          icon: Icon(Icons.access_time),
          color: Colors.red,
          content: 'Technical testing 2015-09-01',
        ),
        TimelineItemData(content: 'Network problems being solved 2015-09-01'),
      ],
    );
  }
}
