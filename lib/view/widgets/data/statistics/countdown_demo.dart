import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../../../incubator/components/data/statistics/toly_countdown.dart';

class CountdownDemo extends StatelessWidget {
  const CountdownDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return  Wrap(
      spacing: 40,
      children: [
        const TolyCountdown(title: '跨年倒计时',value: Duration(seconds: 60),format: "ss",),
        const TolyCountdown(title: '高考倒计时',value: Duration(days:58,),format: "MM月DD天",),
        TolyCountdown(title: '恋爱一周年',value: Duration(days: 60),suffix: ElevatedButton(onPressed:(){
        }, child: Text("按钮")),),
        
      ],
    );
  }
}
