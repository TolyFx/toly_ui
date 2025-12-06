import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';
import 'package:tolyui_statistic/tolyui_statistic.dart';

@DisplayNode(
  title: '带图标统计',
  desc: '在统计数值前后添加图标和文本装饰，通过颜色和图标传达数据趋势。支持上升、下降箭头等视觉提示，增强数据表达力。',
)
class CountdownDemo extends StatelessWidget {
  const CountdownDemo({super.key});

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.all(16.0);

    return Wrap(
      spacing: 40,
      children: [
        Padding(padding: padding, child: buildInstallStatistic()),
        Padding(padding: padding, child: buildConversionStatistic()),
        Padding(padding: padding, child: buildReviewStatistic()),
      ],
    );
  }

  Widget buildInstallStatistic() {
    const redColor = Colors.redAccent;
    const textStyle = TextStyle(color: redColor, fontSize: 24);

    return const TolyStatistic(
      title: '安装人数',
      value: 6.33,
      prefix: Icon(Icons.arrow_upward, color: redColor),
      suffix: Text('%', style: textStyle),
      valueStyle: textStyle,
    );
  }

  Widget buildConversionStatistic() {
    const greenColor = Colors.green;
    const textStyle = TextStyle(color: greenColor, fontSize: 24);

    return const TolyStatistic(
      title: '详情页转化率',
      value: 9.3,
      prefix: Icon(
        Icons.arrow_downward,
        color: greenColor,
      ),
      suffix: Text('%', style: textStyle),
      valueStyle: textStyle,
    );
  }

  Widget buildReviewStatistic() {
    const Color color = Color(0xff1f1f1f);
    return const TolyStatistic(
      titleSuffix: TolyTooltip(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        message: '该框架用户的所有评论数',
        placement: Placement.top,
        child: Icon(CupertinoIcons.question_circle, size: 20, color: color),
      ),
      title: '用户评价',
      value: 12562,
      prefix: Icon(CupertinoIcons.text_bubble_fill, color: color),
    );
  }
}
