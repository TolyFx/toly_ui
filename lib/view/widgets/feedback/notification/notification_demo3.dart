import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import '../../../debugger/debugger.dart';
import '../../../debugger/panel/debug_display_panel.dart';
import '../../display_nodes/display_nodes.dart';

@DisplayNode(title: 'Notification 自定义内容和偏移',
  desc: r'通过 $message.emitNotice 方法可以自定义通知内容组件，其中回调的 close 函数用于关闭通知。offset 属性可以设置提示面板偏移量。',)
class NotificationDemo3 extends StatelessWidget {
  const NotificationDemo3({super.key});

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
    return DebugDisplayButton(
      info: '张风捷特烈',
      onPressed: () {
        $message.emitNotice(
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

  Widget buildDisplay2() {
    return DebugDisplayButton(
      info: 'TolyUI',
      onPressed: () {
        $message.emitNotice(
          position: NoticePosition.bottomRight,
          offset: const Offset(24, 24),
          builder: (_, close) => DebugDisplayPanel(
            image: 'assets/images/logo.png',
            title: 'TolyUI',
            info1: 'Flutter 全平台响应式 UI 框架',
            info2: '当前版本: V 0.1.1',
            onClose: close,
          ),
        );
      },
    );
  }
}


