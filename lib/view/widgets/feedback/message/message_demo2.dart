import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import '../../../debugger/debugger.dart';

class MessageDemo2 extends StatelessWidget {
  const MessageDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 10,
      children: [display1(), display2(), dsplay3(), display4()],
    );
  }

  Widget display1() {
    return DebugDisplayButton(
      info: 'Success',
      onPressed: () {
        $message.success(message: 'Congrats, this is a success message.');
      },
    );
  }

  Widget display2() {
    return DebugDisplayButton(
      info: 'Warning',
      onPressed: () {
        $message.warning(message: 'Warning, this is a warning message.');
      },
    );
  }

  Widget dsplay3() {
    return DebugDisplayButton(
      onPressed: () {
        $message.info(message: 'This is a common message.');
      },
      info: 'Info',
    );
  }

  Widget display4() {
    return DebugDisplayButton(
      onPressed: () {
        $message.error(message: 'Oops, this is a error message.');
      },
      info: 'Error',
    );
  }
}
