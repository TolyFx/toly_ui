import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../../../incubator/components/data/statistics/countdown.dart';

class CountdownDemo extends StatelessWidget {
  const CountdownDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 40,
      children: [
        TolyCountdown(
          title: '倒计时结束时弹窗',
          value: const Duration(seconds: 10),
          format: "ss",
          finish: (){
            $message.info(message: '倒计时已结束');
          },
        ),
        TolyCountdown(
          title: '跨年倒计时',
          endTime: DateTime.fromMillisecondsSinceEpoch(1717654306000),
          format: "hh:mm:ss",
        ),
        const TolyCountdown(
          title: '高考倒计时',
          value: Duration(
            days: 58,
          ),
          format: "MM月DD天",
        ),
        TolyCountdown(
          title: '恋爱一周年',
          value: const Duration(days: 60),
          suffix: ElevatedButton(onPressed: () {}, child: const Text("按钮")),
        ),
      ],
    );
  }
}
