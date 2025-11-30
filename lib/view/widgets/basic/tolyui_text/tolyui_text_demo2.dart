import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';
import 'package:tolyui_text/tolyui_text.dart';

import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: '法律条款高亮',
  desc: '基于 Rule 和 RegExp 的智能文本识别系统，自动识别《》包围的法律条款并提供点击交互。支持多种场景：注册协议、支付条款、会员服务等，每种场景都可自定义样式和交互行为。广泛应用于App注册、登录、支付等页面。',
)
class TolyuiTextDemo2 extends StatelessWidget {
  const TolyuiTextDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    const String agreementText = '我已阅读并同意《用户协议》和《隐私政策》。';
    const TextStyle style =
        TextStyle(color: Colors.blue, fontWeight: FontWeight.w500);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HighlightText(
          agreementText,
          rules: {
            Rule(RegExp(r'《[^\u300b]+》'), onTap: onTapMatch): style,
          },
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  void onTapMatch(HighlightMatch match) {
    $message.success(
      message: '点击的是第:${match.matchIndex} 个:${match.matchedText}',
    );
  }
}
