import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';
import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title:'下划线',
  desc: '文字链接下划线。',
)
class LinkDemo3 extends StatelessWidget {
  const LinkDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    String href = 'https://github.com/TolyFx/toly_ui';
    return Wrap(
      spacing: 10,
      children: [
        TolyLink(href: href, onTap: jump, text: 'None', lineType: LineType.none),
        TolyLink(href: href, onTap: jump, text: 'Active', lineType: LineType.active,),
        TolyLink(href: href, onTap: jump, text: 'Always', lineType: LineType.always,),
      ],
    );
  }

  void jump(String url){
    //TODO 点击跳转操作
  }
}
