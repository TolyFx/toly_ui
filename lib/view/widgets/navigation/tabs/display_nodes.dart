Map<String,dynamic> get displayNodes => {
  'TabsDemo1': {
    'title': '基础用法',
    'desc': '通过 TolyTabs 展示标签页，可容纳 MenuMeta 列表展示条目，onSelect 回调中处理点击条目事件，可用于路由跳转或者状态切换。',
    'code': r"""class TabsDemo1 extends StatefulWidget {
  const TabsDemo1({super.key});

  @override
  State<TabsDemo1> createState() => _TabsDemo1State();
}

class _TabsDemo1State extends State<TabsDemo1> with TickerProviderStateMixin {

  List<MenuMeta> items = const [
    MenuMeta(label: 'Tab1', router: 'tab1'),
    MenuMeta(label: 'Tab2', router: 'tab2'),
    MenuMeta(label: 'Tab3', router: 'tab3'),
    MenuMeta(label: 'Tab4', router: 'tab4'),
  ];

  String activeId = 'tab1';

  MenuMeta get activeMenu => items.singleWhere((e) => e.id == activeId);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TolyTabs(tabs: items, activeId: activeId, onSelect: _onSelect),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text('Content of ${activeMenu.label}'),
        )
      ],
    );
  }

  void _onSelect(MenuMeta meta) {
    activeId = meta.id;
    setState(() {});
  }
}"""
  },
  'TabsDemo2': {
    'title': '禁用项与分割线等配置项',
    'desc': '将 MenuMeta 中的 router 为空字符串时，可禁用对应菜单项;\n'
        'showDivider 置为 false 可隐藏下划线;\n'
        'labelPadding 设置标签四边距；indicatorPadding 设置指示器的四边距。\n'
        'indicatorSize 设置称 tab 时，指示器和菜单项宽度一致。'
        '',
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
  'TabsDemo3': {
    'title': '图标与居中',
    'desc': 'MenuMeta 设置 icon 属性时，展示对应图标。通过 alignment: TabAlignment.center 可以将页签居中',
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
  'TabsDemo4': {
    'title': '首尾组件',
    'desc': '通过 leading和tail 属性，可以设置左右的首尾组件：',
    'code': r"""class TabsDemo4 extends StatefulWidget {
  const TabsDemo4({super.key});

  @override
  State<TabsDemo4> createState() => _TabsDemo4State();
}

class _TabsDemo4State extends State<TabsDemo4> with TickerProviderStateMixin {

  List<MenuMeta> items = const [
    MenuMeta(label: 'Tab1', router: 'tab1',icon: Icons.anchor),
    MenuMeta(label: 'Tab2', router: 'tab2',icon: Icons.ramp_right),
    MenuMeta(label: 'Tab3', router: 'tab3',icon: Icons.cable),
    MenuMeta(label: 'Tab4', router: 'tab4',icon: Icons.account_box_rounded),
  ];

  String activeId = 'tab1';

  MenuMeta get activeMenu => items.singleWhere((e) => e.id == activeId);

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = const EdgeInsets.only(left: 16, right: 16, bottom: 12,top: 12);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TolyTabs(
            leading: _buildLeading(),
            tail: _buildTail(),
            alignment: TabAlignment.center,
            labelPadding: padding,
            tabs: items, activeId: activeId, onSelect: _onSelect,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text('Content of ${activeMenu.label}'),
        )
      ],
    );
  }

  Widget _buildLeading()=>const Wrap(
    spacing: 6,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      FlutterLogo(),
      Text('Flutter&TolyUI')
    ],
  );
  
  Widget _buildTail()=>const Wrap(
      spacing: 8,
      children:[
        Icon(Icons.add),
        Icon(Icons.travel_explore_rounded),
        Icon(Icons.more_horiz_outlined),
      ]);
  
  void _onSelect(MenuMeta meta) {
    activeId = meta.id;
    setState(() {});
  }
}"""
  },
  'TabsDemo5': {
    'title': '自定义页签组件',
    'desc': '通过 cellBuilder 可以自定义构建页签样式：',
    'code': r"""class TabsDemo4 extends StatefulWidget {
  const TabsDemo4({super.key});

  @override
  State<TabsDemo4> createState() => _TabsDemo4State();
}

class _TabsDemo4State extends State<TabsDemo4> with TickerProviderStateMixin {

  List<MenuMeta> items = const [
    MenuMeta(label: 'Tab1', router: 'tab1',icon: Icons.anchor),
    MenuMeta(label: 'Tab2', router: 'tab2',icon: Icons.ramp_right),
    MenuMeta(label: 'Tab3', router: 'tab3',icon: Icons.cable),
    MenuMeta(label: 'Tab4', router: 'tab4',icon: Icons.account_box_rounded),
  ];

  String activeId = 'tab1';

  MenuMeta get activeMenu => items.singleWhere((e) => e.id == activeId);

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = const EdgeInsets.only(left: 16, right: 16, bottom: 12,top: 12);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TolyTabs(
            leading: _buildLeading(),
            tail: _buildTail(),
            alignment: TabAlignment.center,
            labelPadding: padding,
            tabs: items, activeId: activeId, onSelect: _onSelect,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text('Content of ${activeMenu.label}'),
        )
      ],
    );
  }

  Widget _buildLeading()=>const Wrap(
    spacing: 6,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      FlutterLogo(),
      Text('Flutter&TolyUI')
    ],
  );
  
  Widget _buildTail()=>const Wrap(
      spacing: 8,
      children:[
        Icon(Icons.add),
        Icon(Icons.travel_explore_rounded),
        Icon(Icons.more_horiz_outlined),
      ]);
  
  void _onSelect(MenuMeta meta) {
    activeId = meta.id;
    setState(() {});
  }
}"""
  },
  'TabsDemo6': {
    'title': '页签的添加和移除',
    'desc': '通过 leading和tail 属性，可以设置左右的首尾组件：',
    'code': r"""class TabsDemo4 extends StatefulWidget {
  const TabsDemo4({super.key});

  @override
  State<TabsDemo4> createState() => _TabsDemo4State();
}

class _TabsDemo4State extends State<TabsDemo4> with TickerProviderStateMixin {

  List<MenuMeta> items = const [
    MenuMeta(label: 'Tab1', router: 'tab1',icon: Icons.anchor),
    MenuMeta(label: 'Tab2', router: 'tab2',icon: Icons.ramp_right),
    MenuMeta(label: 'Tab3', router: 'tab3',icon: Icons.cable),
    MenuMeta(label: 'Tab4', router: 'tab4',icon: Icons.account_box_rounded),
  ];

  String activeId = 'tab1';

  MenuMeta get activeMenu => items.singleWhere((e) => e.id == activeId);

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding = const EdgeInsets.only(left: 16, right: 16, bottom: 12,top: 12);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TolyTabs(
            leading: _buildLeading(),
            tail: _buildTail(),
            alignment: TabAlignment.center,
            labelPadding: padding,
            tabs: items, activeId: activeId, onSelect: _onSelect,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text('Content of ${activeMenu.label}'),
        )
      ],
    );
  }

  Widget _buildLeading()=>const Wrap(
    spacing: 6,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      FlutterLogo(),
      Text('Flutter&TolyUI')
    ],
  );
  
  Widget _buildTail()=>const Wrap(
      spacing: 8,
      children:[
        Icon(Icons.add),
        Icon(Icons.travel_explore_rounded),
        Icon(Icons.more_horiz_outlined),
      ]);
  
  void _onSelect(MenuMeta meta) {
    activeId = meta.id;
    setState(() {});
  }
}"""
  },
};