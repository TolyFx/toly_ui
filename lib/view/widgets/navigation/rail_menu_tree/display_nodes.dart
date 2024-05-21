Map<String,dynamic> get displayNodes => {
  'RailMenuTreeDemo1': {
    'title': 'TolyUI 默认菜单树样式',
    'desc': '支持拖拽拉伸，点击选中时条目背景色、指示器动画变化，子菜单面板。\n'
        '具有子节点的菜单项，有 icon 标识，点击时会折叠/展开子菜单列表，且具有动画效果。\n'
        '下面案例中支持多个菜单项同时展开：'
    ,
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
  'RailMenuTreeDemo2': {
    'title': '只同时展开一个子面板',
    'desc': '将折叠的选中事件触发时，singleExpand 设置为 true，可以在展开子菜单面板时，关闭其他已展开面板:',
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
  'RailMenuTreeDemo3': {
    'title': '首尾组件',
    'desc': 'leading 和 tail 属性可以设置 TolyRailMenuTree 的首尾组件，树形菜单内容超出时，可在中间区域滚动展示',
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
  },
  'RailMenuTreeDemo4': {
    'title': 'Meta 拓展和自定义构建菜单项',
    'desc': '可以通过 MenuMeta 的拓展，以及自定义菜单项，来灵活构建菜单项，以此满足更多的使用场景。',
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