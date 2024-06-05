import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

class SegmentedDemo1 extends StatefulWidget {
  const SegmentedDemo1({Key? key}) : super(key: key);

  @override
  _SegmentedDemo1State createState() =>
      _SegmentedDemo1State();
}

class _SegmentedDemo1State
    extends State<SegmentedDemo1> {
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
    if(value==null) return;
    setState(() {
      _value=value;
    });
  }
}

