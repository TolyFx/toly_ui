Map<String,dynamic> get displayNodes => {
  'LinkDemo1': {
    'title': '基础用法',
    'desc': '基础的文字链接用法。',
    'code': """class LinkDemo1 extends StatelessWidget {
  const LinkDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    const TextStyle style1 = TextStyle(color: Color(0xff419fff));
    const TextStyle style2 = TextStyle(color: Color(0xff72c749), fontWeight: FontWeight.bold);
    String href = 'https://github.com/TolyFx/toly_ui';
    return Wrap(
      spacing: 10,
      children: [
        TolyLink(href: href, onTap: jump, text: 'TolyUI'),
        TolyLink(href: href, onTap: jump, text: 'TolyUI', style: style1),
        TolyLink(href: href, onTap: jump, text: 'TolyUI', style: style2),
      ],
    );
  }
  
  void jump(String url){
    //TODO 点击跳转操作
  }
}"""
  },
  'LinkDemo2': {
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