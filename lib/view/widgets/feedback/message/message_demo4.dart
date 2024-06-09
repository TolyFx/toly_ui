import 'package:flutter/material.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import '../../../debugger/debugger.dart';
import '../../../debugger/panel/debug_display_panel.dart';
import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: 'Message 自定义消息内容',
  desc: '通过 emit 方法，产出自定义的组件提示信息。animaDuration 控制动画时长；duration 控制展示时长；offset 控制消息的偏移。',
)
class MessageDemo4 extends StatelessWidget {
  const MessageDemo4({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 10,
      children: [buildDisplay1(), buildDisplay2()],
    );
  }

  Widget buildDisplay1() {
    return DebugDisplayButton(
      info: '自定义内容',
      onPressed: () {
        $message.emit(
            child: const DebugDisplayPanel(
          image: 'assets/images/icon_head.webp',
          title: '张风捷特烈',
          info1: '微信号: zdl1994328',
          info2: '地区: 安徽·合肥',
        ));
      },
    );
  }

  Widget buildDisplay2() {
    return DebugDisplayButton(
      info: '动画时长',
      onPressed: () {
        $message.emit(
          position: MessagePosition.bottom,
          offset: const Offset(0, 10),
          duration: const Duration(seconds: 2),
          animaDuration: const Duration(milliseconds: 500),
          child: const DebugDisplayPanel(
            image: 'assets/images/icon_head.webp',
            title: '张风捷特烈',
            info1: '微信号: zdl1994328',
            info2: '地区: 安徽·合肥',
          ),
        );
      },
    );
  }
}
