import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '两种风格',
  desc: '展示 Material 和 Cupertino 两种风格的单选按钮。Material 风格采用圆形选中标记，视觉效果清晰。Cupertino 风格采用 iOS 设计语言，选中时显示勾选标记。单选按钮用于在多个互斥选项中选择一个，适用于性别选择、支付方式、配送方式等场景。',
)
class RadioDemo1 extends StatefulWidget {
  const RadioDemo1({super.key});

  @override
  State<RadioDemo1> createState() => _RadioDemo1State();
}

class _RadioDemo1State extends State<RadioDemo1> {
  int _materialValue = 1;
  int _cupertinoValue = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Material 风格', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<int>(
                  value: 1,
                  groupValue: _materialValue,
                  onChanged: (value) => setState(() => _materialValue = value!),
                ),
                const Text('选项一'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<int>(
                  value: 2,
                  groupValue: _materialValue,
                  onChanged: (value) => setState(() => _materialValue = value!),
                ),
                const Text('选项二'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<int>(
                  value: 3,
                  groupValue: _materialValue,
                  onChanged: (value) => setState(() => _materialValue = value!),
                ),
                const Text('选项三'),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Cupertino 风格', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoRadio<int>(
                  value: 1,
                  groupValue: _cupertinoValue,
                  onChanged: (value) => setState(() => _cupertinoValue = value!),
                ),
                const SizedBox(width: 4),
                const Text('选项一'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoRadio<int>(
                  value: 2,
                  groupValue: _cupertinoValue,
                  onChanged: (value) => setState(() => _cupertinoValue = value!),
                ),
                const SizedBox(width: 4),
                const Text('选项二'),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoRadio<int>(
                  value: 3,
                  groupValue: _cupertinoValue,
                  onChanged: (value) => setState(() => _cupertinoValue = value!),
                ),
                const SizedBox(width: 4),
                const Text('选项三'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
