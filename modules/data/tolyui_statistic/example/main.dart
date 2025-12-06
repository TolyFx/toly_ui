import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tolyui_statistic/tolyui_statistic.dart';

class StatisticDemo extends StatefulWidget {
  const StatisticDemo({Key? key}) : super(key: key);

  @override
  State<StatisticDemo> createState() => _StatisticDemoState();
}

class _StatisticDemoState extends State<StatisticDemo> {
  @override
  Widget build(BuildContext context) {
    final deadline = DateTime.now().millisecondsSinceEpoch +
        1000 * 60 * 60 * 24 * 2 +
        1000 * 30;
    final before = DateTime.now().millisecondsSinceEpoch -
        1000 * 60 * 60 * 24 * 2 +
        1000 * 30;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistic Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Statistics',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDemo1(),
            _buildDemo2(),
            const Text(
              'Timer Examples',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TolyStatisticTimer(
                      type: TimerType.countdown,
                      title: 'Countdown',
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
                      title: 'Million Seconds',
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
                      title: 'Count Up',
                      value: before,
                      format: 'HH:mm:ss',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TolyStatisticTimer(
                      type: TimerType.countdown,
                      title: 'Day Level Countdown',
                      value: deadline,
                      format: 'D 天 H 时 m 分 s 秒',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDemo1() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const TolyStatistic(
              title: '用户总数',
              value: 112893,
            ),
          ),
          const SizedBox(width: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const TolyStatistic(
              title: '账户余额 (CNY)',
              value: 112893,
              precision: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const TolyStatistic(
              title: '本月签到',
              horizontalCenter: true,
              value: 20,
              valueStyle: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
              suffix: Text.rich(TextSpan(children: [
                TextSpan(
                  text: '/31',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                TextSpan(
                  text: '天',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                )
              ])),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemo2() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TolyStatistic(
              title: '安装人数',
              value: 6.33,
              prefix: Icon(
                Icons.arrow_upward,
                color: Colors.redAccent,
              ),
              suffix: const Text('%',
                  style: TextStyle(color: Colors.redAccent, fontSize: 24)),
              valueStyle:
                  const TextStyle(color: Colors.redAccent, fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TolyStatistic(
              title: '详情页转化率',
              value: 9.3,
              prefix: Icon(
                Icons.arrow_downward,
                color: Colors.green,
              ),
              suffix: const Text('%',
                  style: TextStyle(color: Colors.green, fontSize: 24)),
              valueStyle: const TextStyle(color: Colors.green, fontSize: 24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TolyStatistic(
              title: '用户评价',
              value: 12562,
              prefix: Icon(
                CupertinoIcons.text_bubble_fill,
                color: Color(0xff1f1f1f),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
