import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';
import 'package:tolyui_statistic/tolyui_statistic.dart';

@DisplayNode(
  title: '统计组件',
  desc: '展示关键数据指标的组件，支持数值格式化、精度控制和自定义样式。适用于用户统计、财务数据、进度展示等场景，可灵活配置前缀、后缀和布局方式。',
)
class StatisticsDemo extends StatelessWidget {
  const StatisticsDemo({super.key});

  Widget buildPart3() {
    const TextStyle valueStyle = TextStyle(
        fontSize: 24, fontWeight: FontWeight.w600, color: Colors.blue);
    const TextStyle suffixStyle = TextStyle(
        fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87);
    const TextStyle unitStyle = TextStyle(fontSize: 12, color: Colors.grey);
    return const TolyStatistic(
      title: '本月签到',
      horizontalCenter: true,
      value: 20,
      valueStyle: valueStyle,
      suffix: Text.rich(TextSpan(children: [
        TextSpan(text: '/31', style: suffixStyle),
        TextSpan(text: '天', style: unitStyle)
      ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle style1 = TextStyle(color: Color(0xff419fff));

    return const Wrap(
      spacing: 30,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TolyStatistic(title: '用户总数', value: 112893),
        ),
        SizedBox(width: 16),
        Padding(
          padding: EdgeInsets.all(16.0),
          child:
              TolyStatistic(title: '账户余额 (CNY)', value: 112893, precision: 2),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: TolyStatistic(
            title: '本月签到',
            horizontalCenter: true,
            value: 20,
            valueStyle: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w600, color: Colors.blue),
            suffix: Text.rich(TextSpan(children: [
              TextSpan(
                text: '/31',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              TextSpan(
                text: '天',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              )
            ])),
          ),
        ),
      ],
    );
  }
}
