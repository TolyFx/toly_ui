import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: 'Checkbox 组-单选',
  desc: '通过多个 Checkbox 的组合, 控制激活逻辑，可以达到组内单选效果。',
)
class CheckboxDemo3 extends StatefulWidget {
  const CheckboxDemo3({super.key});

  @override
  State<CheckboxDemo3> createState() => _CheckboxDemo1State();
}

class _CheckboxDemo1State extends State<CheckboxDemo3> {
  List<String> data = ['Dart','Rust','Kotlin','C++'];
  String? _select ;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12, 
      children: data.map((e)=>TolyCheckBox(
        value: _select==e,
        label:  Text(e),
        onChanged: (v)=>_toggleActive(v,e),
      )).toList() ,
    );
  }

  void _toggleActive(bool value,String e) {
    if(value){
      _select = e;
    }else{
      _select = null;
    }
    setState(() {});
  }
}
