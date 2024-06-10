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
  title: '展示圆形图片',
  desc: '使用 radius 属性来设置半径大小。backgroundImage 设置图片。结合 DecoratedBox 装饰可以达到阴影和边框效果，如下中图：',
)
class AvatarDemo1 extends StatelessWidget {
  const AvatarDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      children: [
        const CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage("assets/images/icon_head.webp"),
        ),
        const CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage("assets/images/plcki.jpg"),
        ),
        _buildShadowAvatar(),
        const CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage("assets/images/lx.webp"),
        ),
        const CircleAvatar(
          radius: 18,
          backgroundImage: AssetImage("assets/images/fx.png"),
        ),
      ],
    );
  }

  Widget _buildShadowAvatar() {
    return DecoratedBox(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.blue.withOpacity(0.25), blurRadius: 4, spreadRadius: 2),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(2.0),
        child: CircleAvatar(
          radius: 32,
          backgroundImage: AssetImage("assets/images/me.webp"),
        ),
      ),
    );
  }
}
