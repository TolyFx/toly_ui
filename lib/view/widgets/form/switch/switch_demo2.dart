import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '禁用状态',
  desc: '展示禁用状态的开关。通过将 onChanged 设置为 null 来禁用开关，此时开关呈现灰色且无法交互。禁用状态用于表示当前功能不可用或需要满足特定条件才能操作，帮助用户理解功能的可用性。',
)
class SwitchDemo2 extends StatelessWidget {
  const SwitchDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 16,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Switch(value: false, onChanged: null),
        Switch(value: true, onChanged: null),
        Text('禁用状态'),
      ],
    );
  }
}
