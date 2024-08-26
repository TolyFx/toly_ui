import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '禁用输入',
  desc: 'enabled 置为 false 可禁用输入',
)
class InputDemo2 extends StatelessWidget {
  const InputDemo2({super.key});

  @override
  Widget build(BuildContext context) {
   return SizedBox(
     width: 250,
     child: const TolyInput(
       enable: false,
       hintText: '用户名/手机号/匠心ID',
     ),
   );
  }
}
