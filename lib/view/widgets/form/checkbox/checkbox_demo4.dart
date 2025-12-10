import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '三态复选框',
  desc: '支持三种状态的复选框：未选中、选中、不确定状态。不确定状态通常用于表示部分选中的情况，如树形结构中的父节点。',
)
class CheckboxDemo4 extends StatefulWidget {
  const CheckboxDemo4({super.key});

  @override
  State<CheckboxDemo4> createState() => _CheckboxDemo4State();
}

class _CheckboxDemo4State extends State<CheckboxDemo4> {
  bool? _parentState = false;
  final List<bool> _childStates = [false, false, false];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildParentCheckbox(),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Column(
            children: [
              buildChildCheckbox(0, '选项 A'),
              buildChildCheckbox(1, '选项 B'),
              buildChildCheckbox(2, '选项 C'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        buildStandaloneExamples(),
      ],
    );
  }

  Widget buildParentCheckbox() {
    return TolyCheckBox(
      value: _parentState ?? false,
      indeterminate: _parentState == null,
      label: Text('全选'),
      onChanged: (value) {
        setState(() {
          _parentState = value;
          for (int i = 0; i < _childStates.length; i++) {
            _childStates[i] = value;
          }
        });
      },
    );
  }

  Widget buildChildCheckbox(int index, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TolyCheckBox(
        value: _childStates[index],
        label: Text(label),
        onChanged: (value) {
          setState(() {
            _childStates[index] = value;
            _updateParentState();
          });
        },
      ),
    );
  }

  Widget buildStandaloneExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('独立示例：'),
        const SizedBox(height: 8),
        Row(
          children: [
            TolyCheckBox(
              value: false,
              label: const Text('未选中'),
              onChanged: (_) {},
            ),
            const SizedBox(width: 24),
            TolyCheckBox(
              value: true,
              label: const Text('已选中'),
              onChanged: (_) {},
            ),
            const SizedBox(width: 24),
            TolyCheckBox(
              value: false,
              indeterminate: true,
              label: const Text('不确定'),
              onChanged: (_) {},
            ),
          ],
        ),
      ],
    );
  }

  void _updateParentState() {
    final selectedCount = _childStates.where((state) => state).length;
    
    if (selectedCount == _childStates.length) {
      _parentState = true; // 全选
    } else if (selectedCount == 0) {
      _parentState = false; // 全不选
    } else {
      _parentState = null; // 部分选中
    }
  }
}