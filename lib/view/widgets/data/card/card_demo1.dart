import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

class LinkDemo1 extends StatelessWidget {
  const LinkDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle style1 = TextStyle(color: Color(0xff419fff));
    const TextStyle style2 = TextStyle(color: Color(0xff72c749), fontWeight: FontWeight.bold);
    String href = 'https://github.com/TolyFx/toly_ui';
    return Wrap(
      spacing: 10,
      children: [
        TolyLink(href: href, onTap: jump, text: 'TolyUI'),
        TolyLink(href: href, onTap: jump, text: 'TolyUI', style: style1),
        TolyLink(href: href, onTap: jump, text: 'TolyUI', style: style2),
      ],
    );
  }

  void jump(String url){
    // TODO 点击跳转操作
  }
}
