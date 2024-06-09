import 'package:flutter/material.dart';
import 'package:toly_ui/incubator/components/data/card/card.dart';
import 'package:toly_ui/view/debugger/display/debug_display_tile.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '基础用法',
  desc: '可以通过 TolyCard 组件实现具有阴影的卡片效果：',
)
class CardDemo1 extends StatelessWidget {
  const CardDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 260,
      child: TolyCard(
          child: DebugDisplayTile(
        title: '《应龙》',
        centerTitle: true,
        content: "一游小池两岁月，\n洗却凡世几闲尘。\n时逢雷霆风会雨，\n应乘扶摇化入云。",
        foot: '张风捷特烈 2017.2.2',
      )),
    );
  }
}
