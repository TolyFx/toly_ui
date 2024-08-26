import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '基础用法',
  desc: '通过 TolyInput 展示最基本输入框样式。',
)
class InputDemo1 extends StatelessWidget {
  const InputDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        width: 250,
        child: TolyInput(
          hintText: '用户名/手机号/匠心ID',
        ));
  }
}
