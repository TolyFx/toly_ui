import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '基础用法',
  desc: '简单的 Checkbox, 点击可切换选中状态，通过 label 设置右侧的内容。',
)
class CheckboxDemo1 extends StatefulWidget {
  const CheckboxDemo1({super.key});

  @override
  State<CheckboxDemo1> createState() => _CheckboxDemo1State();
}

class _CheckboxDemo1State extends State<CheckboxDemo1> {
  bool _select = false;
  @override
  Widget build(BuildContext context) {
    return TolyCheckBox(
      value: _select,
      label: const Text('Checkbox'),
      onChanged: (bool value) {
        setState(() {
          _select = value;
        });
      },
    );
  }
}
