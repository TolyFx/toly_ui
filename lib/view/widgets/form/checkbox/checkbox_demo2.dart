import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: 'Checkbox 组-多选',
  desc: '通过多个 Checkbox 的组合, 可以实现多选效果。',
)
class CheckboxDemo2 extends StatefulWidget {
  const CheckboxDemo2({super.key});

  @override
  State<CheckboxDemo2> createState() => _CheckboxDemo1State();
}

class _CheckboxDemo1State extends State<CheckboxDemo2> {
  List<String> data = ['Dart','Rust','Kotlin','C++'];
  List<String> _select = [];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: data.map((e)=>TolyCheckBox(
        value: _select.contains(e),
        label:  Text(e),
        onChanged: (v)=>_toggleActive(v,e),
      )).toList() ,
    );
  }

  void _toggleActive(bool value,String e) {
    if(value){
      _select.add(e);
    }else{
      _select.remove(e);
    }
    setState(() {
    });
  }
}
