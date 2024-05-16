import 'package:flutter/material.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import '../../../debugger/debugger.dart';

class MessageDemo1 extends StatelessWidget {
  const MessageDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 10,
      children: [display1(), display2(), display3()],
    );
  }

  Widget display1() {
    return DebugDisplayButton(
      info: 'Show Message Top',
      onPressed: () {
        $message.info(message: 'This is a common message.');
      },
    );
  }

  Widget display2() {
    return DebugDisplayButton(
      info: 'Show Message Bottom',
      onPressed: () {
        $message.info(
          message: 'This is a common message.',
          position: MessagePosition.bottom,
        );
      },
    );
  }

  Widget display3() {
    InlineSpan span = const TextSpan(children: [
      TextSpan(text: '请通过此邮箱联系我 '),
      TextSpan(style: TextStyle(color: Colors.blue), text: '1981462002@qq.com ')
    ]);
    return DebugDisplayButton(
      onPressed: () {
        $message.info(richMessage: span);
      },
      info: '富文本',
    );
  }
}
