/// create by 星星 on 2024/5/24
/// contact me by email 1395723441@qq.com
/// 说明: 

Map<String,dynamic> get displayNodes => {
  'StatisticsDemo': {
    'title': '基础用法1',
    'desc': '统计组件的基本用法',
    'code': """
class StatisticsDemo extends StatelessWidget {
  const StatisticsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle style1 = TextStyle(color: Color(0xff419fff));

    return const Wrap(
      spacing: 30,
      children: [
        TolyStatistics(title: "学生人数",value: 2564,enableAnimation: true,enableSeparator: true,),
        TolyStatistics(title: "用户反馈数",value: 255,suffix: Padding(
          padding: EdgeInsets.only(left: 5),
          child: Icon( Icons.account_circle_rounded,size: 15,color: Colors.grey,),
        ),enableAnimation: true,),
        TolyStatistics(title: "参保比例",value: 20,suffix: Text("/100"),valueStyle: style1,),

      ],
    );
  }
}
"""
  },
  'CountdownDemo': {
    'title': '禁用状态',
    'desc': '文字链接不可用状态。',
    'code': """class CountdownDemo extends StatelessWidget {
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
            message.info(message: '倒计时已结束');
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
"""
  },
  'LinkDemo3': {
    'title': '下划线',
    'desc': '文字链接下划线。',
    'code': """class LinkDemo3 extends StatelessWidget {
  const LinkDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    String href = 'https://github.com/TolyFx/toly_ui';
    return Wrap(
      spacing: 10,
      children: [
        TolyLink(href: href, onTap: jump, text: 'None', lineType: LineType.none),
        TolyLink(href: href, onTap: jump, text: 'Active', lineType: LineType.active,),
        TolyLink(href: href, onTap: jump, text: 'Always', lineType: LineType.always,),
      ],
    );
  }

  void jump(String url){
    //TODO 点击跳转操作
  }
}"""
  }
};