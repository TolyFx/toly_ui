import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: 'Badge 标签标记',
  desc: '在指定的子组件上，增加 label 的徽标，可以设置徽标颜色、样式、边距、高度等属性：',
)
class BadgeDemo2 extends StatelessWidget {
  const BadgeDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Badge(
      backgroundColor: Colors.red,
      label: Text('99'),
      textStyle: TextStyle(fontSize: 8, color: Colors.red, height: 1),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      largeSize: 12,
      child: Icon(
        CupertinoIcons.mail,
        size: 36,
        color: Colors.indigo,
      ),
    );
  }
}
