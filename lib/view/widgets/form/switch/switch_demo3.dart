import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '自定义颜色',
  desc: '展示自定义颜色的开关。通过 activeColor 设置激活状态的颜色，activeTrackColor 设置轨道颜色。不同的颜色可以表达不同的功能含义或匹配应用的主题色，提升视觉一致性和用户体验。',
)
class SwitchDemo3 extends StatefulWidget {
  const SwitchDemo3({super.key});

  @override
  State<SwitchDemo3> createState() => _SwitchDemo3State();
}

class _SwitchDemo3State extends State<SwitchDemo3> {
  bool _value1 = true;
  bool _value2 = true;
  bool _value3 = true;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 16,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: _value1,
              activeColor: Colors.green,
              onChanged: (value) => setState(() => _value1 = value),
            ),
            const SizedBox(width: 8),
            const Text('绿色'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: _value2,
              activeColor: Colors.orange,
              onChanged: (value) => setState(() => _value2 = value),
            ),
            const SizedBox(width: 8),
            const Text('橙色'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: _value3,
              activeColor: Colors.purple,
              onChanged: (value) => setState(() => _value3 = value),
            ),
            const SizedBox(width: 8),
            const Text('紫色'),
          ],
        ),
      ],
    );
  }
}
