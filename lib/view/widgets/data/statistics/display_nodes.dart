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
    'code': """class BaseUseDemo extends StatelessWidget {
  const BaseUseDemo({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle style1 = TextStyle(color: Color(0xff419fff));
    const TextStyle style2 = TextStyle(color: Color(0xff72c749), fontWeight: FontWeight.bold);
    String href = 'https://github.com/TolyFx/toly_ui';
    return Wrap(
      spacing: 10,
      children: [
        TolyLink(href: href, onTap: null, text: 'TolyUI'),
        TolyLink(href: href, onTap: null, text: 'TolyUI', style: style1),
        TolyLink(href: href, onTap: null, text: 'TolyUI', style: style2),
      ],
    );
  }
}"""
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