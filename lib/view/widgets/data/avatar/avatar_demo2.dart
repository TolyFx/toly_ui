/// create by 张风捷特烈 on 2020/4/25
/// contact me by email 1981462002@qq.com
/// 说明:
//    {
//      "widgetId": 9,
//      "priority": 1,
//      "name": "CircleAvatar的表现",
//      "subtitle": "【radius】 : 半径  【double】\n"
//          "【backgroundImage】 : 图片资源  【ImageProvider】\n"
//          "【foregroundColor】: 前景色   【Color】\n"
//          "【backgroundColor】: 背景色   【Color】\n"
//          "【minRadius】: 最小半径   【double】\n"
//          "【maxRadius】: 最大半径   【double】\n"
//          "【child】: 孩子组件   【Child】",
//    }

import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '内容与前景色',
  desc: '使用 foregroundColor 设置前景色; backgroundColor 设置背景色。child 设置内容组件，可展示文字、图标等任意组件',
)
class AvatarDemo2 extends StatelessWidget {
  const AvatarDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: [
        CircleAvatar(
          radius: 24,
          foregroundColor: Theme.of(context).primaryColor,
          child: const FlutterLogo(),
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: const Text(
            '张',
            style: TextStyle(fontSize: 20),
          ),
        ),
        const CircleAvatar(
          radius: 24,
          foregroundColor: Colors.white,
          backgroundColor: Colors.orange,
          child: Icon(Icons.account_box_rounded),
        ),
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.limeAccent,
          child: const Text(
            'UI',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
