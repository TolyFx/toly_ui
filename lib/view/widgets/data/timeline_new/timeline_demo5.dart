import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_timeline/tolyui_timeline.dart';

@DisplayNode(
  title: '标题展示',
  desc: '使用 title 标签单独展示时间。支持通过 mode 属性切换不同的布局模式。',
)
class TimelineDemo5 extends StatefulWidget {
  const TimelineDemo5({super.key});

  @override
  State<TimelineDemo5> createState() => _TimelineDemo5State();
}

class _TimelineDemo5State extends State<TimelineDemo5> {
  TimelineMode _mode = TimelineMode.start;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('Start'),
              selected: _mode == TimelineMode.start,
              onSelected: (_) => setState(() => _mode = TimelineMode.start),
            ),
            ChoiceChip(
              label: const Text('End'),
              selected: _mode == TimelineMode.end,
              onSelected: (_) => setState(() => _mode = TimelineMode.end),
            ),
            ChoiceChip(
              label: const Text('Alternate'),
              selected: _mode == TimelineMode.alternate,
              onSelected: (_) => setState(() => _mode = TimelineMode.alternate),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TolyTimeline(
          mode: _mode,
          items: [
            TimelineItemData(
              title: const Text('2015-09-01', style: TextStyle(fontWeight: FontWeight.bold)),
              content: 'Create a services',
            ),
            TimelineItemData(
              title: const Text('2015-09-01 09:12:11', style: TextStyle(fontWeight: FontWeight.bold)),
              content: 'Solve initial network problems',
            ),
            TimelineItemData(
              content: 'Technical testing',
            ),
            TimelineItemData(
              title: const Text('2015-09-01 09:12:11', style: TextStyle(fontWeight: FontWeight.bold)),
              content: 'Network problems being solved',
            ),
          ],
        ),
      ],
    );
  }
}
