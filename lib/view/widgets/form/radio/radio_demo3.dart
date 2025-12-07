import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '自定义颜色',
  desc: '展示自定义颜色的单选按钮。通过 fillColor 属性设置选中状态的颜色，可以创建符合应用主题的单选按钮。不同的颜色可以表达不同的选项类型或重要程度，提升界面的视觉层次和用户体验。',
)
class RadioDemo3 extends StatefulWidget {
  const RadioDemo3({super.key});

  @override
  State<RadioDemo3> createState() => _RadioDemo3State();
}

class _RadioDemo3State extends State<RadioDemo3> {
  String _value = 'green';

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: 'green',
              groupValue: _value,
              fillColor: WidgetStateProperty.all(Colors.green),
              onChanged: (value) => setState(() => _value = value!),
            ),
            const Text('绿色'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: 'orange',
              groupValue: _value,
              fillColor: WidgetStateProperty.all(Colors.orange),
              onChanged: (value) => setState(() => _value = value!),
            ),
            const Text('橙色'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: 'purple',
              groupValue: _value,
              fillColor: WidgetStateProperty.all(Colors.purple),
              onChanged: (value) => setState(() => _value = value!),
            ),
            const Text('紫色'),
          ],
        ),
      ],
    );
  }
}
