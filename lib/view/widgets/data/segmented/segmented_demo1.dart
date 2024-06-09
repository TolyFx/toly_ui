import 'package:flutter/cupertino.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '基础用法',
  desc: '点击切换展示某个 Segmented 页签：',
)
class SegmentedDemo1 extends StatefulWidget {
  const SegmentedDemo1({super.key});

  @override
  _SegmentedDemo1State createState() => _SegmentedDemo1State();
}

class _SegmentedDemo1State extends State<SegmentedDemo1> {
  int _value = 1;

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl(
      groupValue: _value,
      onValueChanged: _onValueChanged,
      padding: const EdgeInsets.all(5),
      children: const {
        1: Text("Delicacy"),
        2: Text("Desserts"),
        4: Text("Fresh foods"),
        5: Text("Supermarket"),
      },
    );
  }

  void _onValueChanged(int? value) {
    if (value == null) return;
    setState(() {
      _value = value;
    });
  }
}
