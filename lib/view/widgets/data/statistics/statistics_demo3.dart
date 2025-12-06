import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';
import 'package:tolyui_statistic/tolyui_statistic.dart';

@DisplayNode(
  title: '倒计时统计',
  desc:
      '基于时间的动态统计组件，支持倒计时和正计时两种模式。可自定义时间格式显示，包含毫秒、标准时分秒、中文天时分秒等格式，并支持倒计时结束回调处理。',
)
class StatisticsDemo3 extends StatelessWidget {
  const StatisticsDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    final deadline = DateTime.now().millisecondsSinceEpoch +
        1000 * 60 * 60 * 24 * 2 +
        1000 * 30;
    final before = DateTime.now().millisecondsSinceEpoch -
        1000 * 60 * 60 * 24 * 2 +
        1000 * 30;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TolyStatisticTimer(
                  type: TimerType.countdown,
                  title: '倒计时',
                  value: deadline,
                  onFinish: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Countdown finished!')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TolyStatisticTimer(
                  type: TimerType.countdown,
                  title: '倒计时-毫秒',
                  value: deadline,
                  format: 'HH:mm:ss:SSS',
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TolyStatisticTimer(
                  type: TimerType.countup,
                  title: '正计时',
                  value: before,
                  format: 'HH:mm:ss',
                ),
              ),
              const SizedBox(width: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TolyStatisticTimer(
                  type: TimerType.countdown,
                  title: '天数级倒计时',
                  value: deadline,
                  format: 'D天 H时 m分 s秒',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
