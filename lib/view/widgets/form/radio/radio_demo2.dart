import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '禁用状态',
  desc: '展示禁用状态的单选按钮。通过将 onChanged 设置为 null 来禁用单选按钮，此时按钮呈现灰色且无法交互。禁用状态用于表示当前选项不可用或需要满足特定条件才能选择，帮助用户理解选项的可用性。',
)
class RadioDemo2 extends StatefulWidget {
  const RadioDemo2({super.key});

  @override
  State<RadioDemo2> createState() => _RadioDemo2State();
}

class _RadioDemo2State extends State<RadioDemo2> {
  int _value = 1;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<int>(
              value: 1,
              groupValue: _value,
              onChanged: (value) => setState(() => _value = value!),
            ),
            const Text('可用选项'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<int>(
              value: 2,
              groupValue: _value,
              onChanged: null,
            ),
            const Text('禁用未选中'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<int>(
              value: 3,
              groupValue: 3,
              onChanged: null,
            ),
            const Text('禁用已选中'),
          ],
        ),
      ],
    );
  }
}
