import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import '../../../debugger/debugger.dart';

@DisplayNode(
  title: 'Notification 全局通知',
  desc: r'使用 $message.xxxNotice 弹出全局通知。时长设置为 0，可以取消自动关闭，由用户手动关闭。',
)
class NotificationDemo1 extends StatelessWidget {
  const NotificationDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 20,
      runSpacing: 10,
      children: [
        buildDisplay1(),
        buildDisplay2(),
      ],
    );
  }

  Widget buildDisplay1() {
    String title = 'Notification Title';
    String subtitle = 'I will be close automatically' * 3;
    TextStyle titleStyle =
        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    return DebugDisplayButton(
      info: 'Auto Close',
      onPressed: () {
        $message.infoNotice(
          title: Text(title, style: titleStyle),
          subtitle: Text(subtitle),
        );
      },
    );
  }

  Widget buildDisplay2() {
    String title = 'Notification Title';
    String subtitle = 'I will never close automatically' * 3;
    TextStyle titleStyle =
        const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    return DebugDisplayButton(
      info: 'User Close',
      onPressed: () {
        $message.infoNotice(
          duration: Duration.zero,
          title: Text(title, style: titleStyle),
          subtitle: Text(subtitle),
        );
      },
    );
  }

  Widget buildDisplay3() {
    InlineSpan span = TextSpan(children: [
      TextSpan(text: '请通过此邮箱联系我 '),
      TextSpan(
        style: TextStyle(color: Colors.blue),
        text: '1981462002@qq.com ',
      )
    ]);
    return DebugDisplayButton(
      onPressed: () {
        // context.go('/sponsor');
        $message.info(richMessage: span);
      },
      info: '富文本',
    );
    ;
  }
}
