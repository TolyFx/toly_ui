import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import '../../../debugger/debugger.dart';

class MessageDemo3 extends StatelessWidget {
  const MessageDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 10,
      children: [display1(), display2(), display3(), display4()],
    );
  }

  Widget display1() {
    String message = 'Congrats, this is a success message.';
    return DebugDisplayButton(
      info: 'Success',
      onPressed: () {
        $message.success(plain: true, message:message );
      },
    );
  }

  Widget display2() {
    String message = 'Warning, this is a warning message.';
    return DebugDisplayButton(
      info: 'Warning',
      onPressed: () {
        $message.warning(plain: true, message: message);
      },
    );
  }

  Widget display3() {
    String message = 'This is a common message.';
    return DebugDisplayButton(
      onPressed: () {
        $message.info(plain: true, message: message);
      },
      info: 'Info',
    );
  }

  Widget display4() {
    String message = 'Oops, this is a error message.';
    return DebugDisplayButton(
      onPressed: () {
        $message.error(plain: true, message: message);
      },
      info: 'Error',
    );
  }
}
