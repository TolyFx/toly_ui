Map<String, dynamic> get displayNodes => {
      'DropMenuDemo1': {
        'title': '基础用法',
        'desc':
            '当页面上的操作命令过多时，用此组件可以收纳操作元素。点击或移入触点，会出现一个下拉菜单。可在列表中进行选择，并执行相应的命令。下面是气泡和非气泡模式：',
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
  'DropMenuDemo2': {
    'title': '分割线与不可用菜单项',
    'desc': 'DividerMenu 可以展示分割线项，ActionMenu 的 enable 属性配置其是否可用; 菜单元数据 MenuMeta 中的 icon 属性可以配置菜单项图标。 ',
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
      'DropMenuDemo3': {
        'title': '子菜单',
        'desc': '通过 SubMenu 提供子菜单的元数据，可通过 TolyDropMenu#subMenuGap 参数，调节弹出子面板的间距。',
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
      'DropMenuDemo4': {
        'title': '菜单面板定位',
        'desc': '和 Popover一样，与目标组件之间有 12 种定位方式：',
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
      },   'DropMenuDemo5': {
        'title': '右键触发',
        'desc': '可以通过右键，在一个组件之上弹出菜单面板。',
        'code': r"""class DropMenuDemo5 extends StatelessWidget{
  const DropMenuDemo5({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyDropMenu(
      onSelect: onSelect,
      decorationConfig: const DecorationConfig(isBubble: false),
      placement: Placement.topEnd,
      menuItems: [
        ActionMenu(const MenuMeta(router: '01', label: '1st menu item')),
        ActionMenu(const MenuMeta(router: '02', label: '2nd menu item')),
        SubMenu(const MenuMeta(router: '03', label: 'export image'), menus: [
          ActionMenu(const MenuMeta(router: 'png', label: 'sub out .png')),
          ActionMenu(const MenuMeta(router: 'jpeg', label: 'sub out .jpeg')),
          ActionMenu(const MenuMeta(router: 'svg', label: 'sub out .svg')),
        ]),
        ActionMenu(const MenuMeta(router: '04', label: '4ur menu item')),
      ],
      // width: 140,
      childBuilder: (_, ctrl, __) => GestureDetector(
        onTapDown: (_) => ctrl.close(),
        onSecondaryTapDown: (detail) => _onSecondaryTapDown(detail, ctrl),
        child: Container(
          color: const Color(0xfff7f7f7),
          alignment: Alignment.center,
          height: 180,
          child: const Text('Right Click on here'),
        ),
      ),
    );
  }

  void onSelect(
    MenuMeta menu,
  ) {
    $message.success(message: '点击了 [${menu.label}] 个菜单');
  }

  void _onSecondaryTapDown(TapDownDetails details, PopoverController ctrl) async {
    if (ctrl.isOpen) {
      ctrl.close();
      Future.delayed(Duration(milliseconds: 260), () {
        ctrl.open(position: details.localPosition);
      });
    } else {
      ctrl.open(position: details.localPosition);
    }
  }
}"""
      },
    };
