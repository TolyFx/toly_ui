import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import '../../../debugger/debugger.dart';
import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: '异步任务全局 loading',
  desc: r'通过 $message.loadingTask 执行一个异步任务，期间全局 Loading。可以通过 timeout 设置超时时长; onError 监听异常事件。',
)
class LoadingDemo3 extends StatelessWidget {
  const LoadingDemo3({super.key});

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
      info: 'loading#task',
      onPressed: () {
        $message.loadingTask(task: task);
      },
    );
  }

  Future<void> task() async {
    await Future.delayed(Duration(seconds: 3));
  }

  Widget display2() {
    return DebugDisplayButton(
      info: 'loading#timeout',
      onPressed: () {
        $message.loadingTask(
            task: task,
            timeout: const Duration(seconds: 2),
            onError: (e, t) {
              $message.error(message: e.toString());
            });
      },
    );
  }
}
