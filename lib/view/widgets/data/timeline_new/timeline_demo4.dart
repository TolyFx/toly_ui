import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_timeline/tolyui_timeline.dart';

@DisplayNode(
  title: '交替展示',
  desc: '内容在时间轴两侧轮流出现。通过 mode 属性设置为 alternate 实现交替布局。',
)
class TimelineDemo4 extends StatelessWidget {
  const TimelineDemo4({super.key});

  @override
  Widget build(BuildContext context) {
    return const TolyTimeline(
      mode: TimelineMode.alternate,
      items: [
        TimelineItemData(content: 'Create a services site 2015-09-01'),
        TimelineItemData(
          color: Colors.green,
          content: 'Solve initial network problems 2015-09-01',
        ),
        TimelineItemData(
          icon: Icon(Icons.access_time, size: 16),
          content:
              'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
        ),
        TimelineItemData(
          color: Colors.red,
          content: 'Network problems being solved 2015-09-01',
        ),
        TimelineItemData(content: 'Create a services site 2015-09-01'),
        TimelineItemData(
          icon: Icon(Icons.access_time, size: 16),
          content: 'Technical testing 2015-09-01',
        ),
      ],
    );
  }
}
