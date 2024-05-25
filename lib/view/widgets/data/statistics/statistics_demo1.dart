import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../../../incubator/components/data/statistics/toly_statistics.dart';

class StatisticsDemo1 extends StatelessWidget {
  const StatisticsDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle style1 = TextStyle(color: Color(0xff419fff));
    const TextStyle style2 = TextStyle(color: Color(0xff72c749), fontWeight: FontWeight.bold);
    String href = 'https://github.com/TolyFx/toly_ui';
    return const Wrap(
      spacing: 10,
      children: [
        TolyStatistics(title: "学生人数",value: 2564,enableAnimation: true,enableSeparator: true,),
        TolyStatistics(title: "用户反馈数",value: 255,suffix: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Icon( Icons.message,size: 15,color: Colors.grey,),
        ),enableAnimation: true,),

      ],
    );
  }

  void jump(String url){
    // TODO 点击跳转操作
  }
}
