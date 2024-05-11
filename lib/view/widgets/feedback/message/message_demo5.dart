import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import '../debugger/debugger.dart';
import '../debugger/panel/debug_display_panel.dart';

class MessageDemo5 extends StatelessWidget {
  const MessageDemo5({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 10,
      children: [display1(), display2()],
    );
  }

  Widget display1() {
    return DebugDisplayButton(
      info: '可关闭消息',
      onPressed: () {
        $message.success(
          closeable: true,
          duration: const Duration(seconds: 5),
          message: 'Congrats, this is a success message.',
        );
      },
    );
  }

  Widget display2() {
    return DebugDisplayButton(
      info: '关闭自定义消息',
      onPressed: () {
        $message.emit(
          duration: const Duration(seconds: 5),
          builder: (_, close) => DebugDisplayPanel(
            image: 'assets/images/icon_head.webp',
            title: '张风捷特烈',
            info1: '微信号: zdl1994328',
            info2: '地区: 安徽·合肥',
            onClose: close,
          ),
        );
      },
    );
  }
}
