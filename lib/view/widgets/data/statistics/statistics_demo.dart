import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

import '../../../../incubator/components/data/statistics/statistics.dart';

@DisplayNode(
  title: '倒计时',
  desc: '用于突出某个或某组数字时，如统计数值、金额、排名等，数值和标题前后都可以加icon、单位等元素。',
)
class StatisticsDemo extends StatelessWidget {
  const StatisticsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle style1 = TextStyle(color: Color(0xff419fff));

    return const Wrap(
      spacing: 30,
      children: [
        TolyStatistics(
          title: "学生人数",
          value: 2564,
          enableAnimation: true,
          enableSeparator: true,
        ),
        TolyStatistics(
          title: "用户反馈数",
          value: 255,
          suffix: Padding(
            padding: EdgeInsets.only(left: 5),
            child: Icon(
              Icons.account_circle_rounded,
              size: 15,
              color: Colors.grey,
            ),
          ),
          enableAnimation: true,
        ),
        TolyStatistics(
          title: "参保比例",
          value: 20,
          suffix: Text("/100"),
          valueStyle: style1,
        ),
      ],
    );
  }
}
