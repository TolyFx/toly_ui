Map<String, dynamic> get displayNodes => {
      'DropMenuDemo1': {
        'title': '基础用法',
        'desc':
            '当页面上的操作命令过多时，用此组件可以收纳操作元素。点击或移入触点，会出现一个下拉菜单。可在列表中进行选择，并执行相应的命令。下面是气泡和非气泡模式：',
        'code': r"""class DropMenuDemo1 extends StatelessWidget {
  const DropMenuDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    Color bgColor = context.isDark ? const Color(0xff303133) : Colors.white;
    return Wrap(
      spacing: 20,
      children: [
        TolyDropMenu(
          hoverConfig: const HoverConfig(enterPop: true, exitClose: true),
          onSelect: onSelect,
          menuItems: [
            ActionMenu(const MenuMeta(router: '01', label: '1st menu item')),
            ActionMenu(const MenuMeta(router: '02', label: '2nd menu item')),
            ActionMenu(const MenuMeta(router: '03', label: '3rd menu item')),
            ActionMenu(const MenuMeta(router: '04', label: '4ur menu item')),
          ],
          // width: 140,
          child: DebugDisplayButton(
            info: 'Hover Pop',
            onPressed: () {},
          ),
        ),
        TolyDropMenu(
            placement: Placement.bottomStart,
            offsetCalculator: boxOffsetCalculator,
            decorationConfig:
                DecorationConfig(isBubble: false, backgroundColor: bgColor),
            onSelect: onSelect,
            menuItems: [
              ActionMenu(const MenuMeta(router: '01', label: '1st menu item')),
              ActionMenu(const MenuMeta(router: '02', label: '2nd menu item')),
              ActionMenu(
                const MenuMeta(router: '03', label: '3rd menu item'),
              ),
              ActionMenu(const MenuMeta(router: '04', label: '4ur menu item')),
            ],
            childBuilder: (_, ctrl, __) {
              return DebugDisplayButton(
                info: 'Click Pop',
                onPressed: ctrl.open,
              );
            }),
      ],
    );
  }

  void onSelect(
    MenuMeta menu,
  ) {
    $message.success(message: '点击了 [${menu.label}] 个菜单');
  }
}
"""
      },
  'DropMenuDemo2': {
    'title': '分割线与不可用菜单项',
    'desc': 'DividerMenu 可以展示分割线项，ActionMenu 的 enable 属性配置其是否可用; 菜单元数据 MenuMeta 中的 icon 属性可以配置菜单项图标。 ',
    'code': r"""class DropMenuDemo2 extends StatelessWidget {
  const DropMenuDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    Color bgColor = context.isDark? const Color(0xff303133):Colors.white;
    return Wrap(
      spacing: 20,
      children: [display1(bgColor), display2(bgColor)],
    );
  }

  void onSelect(MenuMeta menu) {
    $message.success(message: '点击了 [${menu.label}] 个菜单');
  }

  Widget display1(Color bgColor) {
    return TolyDropMenu(
        onSelect: onSelect,
        placement: Placement.bottomStart,
        decorationConfig: DecorationConfig(isBubble: false,backgroundColor: bgColor),
        offsetCalculator: boxOffsetCalculator,
        menuItems: [
          ActionMenu(const MenuMeta(icon: Icons.add, router: '01', label: '1st menu item')),
          ActionMenu(const MenuMeta(icon: Icons.remove, router: '02', label: '2nd menu item')),
          ActionMenu(const MenuMeta(icon: Icons.close, router: '03', label: '3rd menu item')),
          const DividerMenu(),
          ActionMenu(const MenuMeta(icon: Icons.diamond, router: '04', label: '4ur menu item')),
        ],
        childBuilder: (_, ctrl, __) {
          return DebugDisplayButton(
            info: 'Divider Menu',
            onPressed: ctrl.open,
          );
        });
  }

  Widget display2(Color bgColor) {
    return TolyDropMenu(
        onSelect: onSelect,
        menuItems: [
          ActionMenu(const MenuMeta(router: '01', label: '1st menu item')),
          ActionMenu(const MenuMeta(router: '02', label: '2nd menu item')),
          ActionMenu(const MenuMeta(router: '03', label: '3rd menu item'), enable: false),
          const DividerMenu(),
          ActionMenu(const MenuMeta(router: '04', label: '4ur menu item')),
        ],
        // width: 140,
        childBuilder: (_, ctrl, __) {
          return DebugDisplayButton(
            info: 'Disable Menu',
            onPressed: ctrl.open,
          );
        });
  }
}"""
  },
      'DropMenuDemo3': {
        'title': '子菜单',
        'desc': '通过 SubMenu 提供子菜单的元数据，可通过 TolyDropMenu#subMenuGap 参数，调节弹出子面板的间距。',
        'code': r"""class DropMenuDemo3 extends StatelessWidget {
  const DropMenuDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      children: [
        display(context),
        display(context,gap: 6),
      ],
    );
  }

  Widget display(BuildContext context,{double gap=0}){
    Color bgColor = context.isDark? const Color(0xff303133):Colors.white;

    return TolyDropMenu(
        onSelect: onSelect,
        subMenuGap: gap,
        placement: Placement.bottomStart,
        decorationConfig:  DecorationConfig(isBubble: false,backgroundColor: bgColor),
        offsetCalculator: boxOffsetCalculator,
        menuItems: [
          ActionMenu(const MenuMeta(router: '01', label: '1st menu item')),
          ActionMenu(const MenuMeta(router: '02', label: '2nd menu item')),
          SubMenu(const MenuMeta(router: 'export', label: 'export image'),
              menus: [
                ActionMenu(const MenuMeta(router: 'png', label: 'sub out .png')),
                ActionMenu(const MenuMeta(router: 'jpeg', label: 'sub out .jpeg')),
                ActionMenu(const MenuMeta(router: 'svg', label: 'sub out .svg')),
                SubMenu(const MenuMeta(router: 'sub sub', label: 'sub sub menu'),
                    menus: [
                      ActionMenu(const MenuMeta(router: 's1', label: 'sub menu1')),
                      ActionMenu(const MenuMeta(router: 's2', label: 'sub menu2')),
                      ActionMenu(const MenuMeta(router: 's3', label: 'sub menu3')),
                    ]),
              ]),
          const DividerMenu(),
          ActionMenu(const MenuMeta(router: '03', label: '3rd menu item'), enable: false),
          ActionMenu(const MenuMeta(router: '04', label: '4ur menu item')),
        ],
        // width: 160,
        childBuilder: (_, ctrl, __) {
          return DebugDisplayButton(
            info: 'SubMenu:gap#$gap',
            onPressed: ctrl.open,
          );
        });
  }

  void onSelect(MenuMeta menu) {
    $message.success(message: '点击了 [${menu.label}] 菜单');
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
      },  'DropMenuDemo5': {
    'title': '修改样式',
    'desc': '可以通过 DropMenuCellStyle 修改菜单项样式。包括背景色、前景色、边距、圆角等属性。',
    'code': r"""class DropMenuDemo5 extends StatelessWidget {
  const DropMenuDemo5({super.key});

  @override
  Widget build(BuildContext context) {
    DropMenuCellStyle lightStyle = const DropMenuCellStyle(
      padding: EdgeInsets.symmetric(horizontal: 8),
      borderRadius: BorderRadius.all(Radius.circular(6)),
      foregroundColor: Color(0xff1f1f1f),
      backgroundColor: Colors.transparent,
      disableColor: Color(0xffbfbfbf),
      hoverBackgroundColor: Color(0xfff5f5f5),
      hoverForegroundColor: Color(0xff1f1f1f),
    );

    DropMenuCellStyle darkStyle = const DropMenuCellStyle(
      padding: EdgeInsets.symmetric(horizontal: 8),
      borderRadius: BorderRadius.all(Radius.circular(6)),
      foregroundColor: Color(0xffcfd3dc),
      backgroundColor: Colors.transparent,
      disableColor: Colors.grey,
      hoverBackgroundColor: Color(0xff313131),
      hoverForegroundColor: Color(0xffcfd3dc),
    );
    return Wrap(
      spacing: 20,
      children: [
        display(context, lightStyle, Colors.white, 'light'),
        display(context, darkStyle, const Color(0xff1f1f1f), 'dark'),
      ],
    );
  }

  Widget display(
    BuildContext context,
    DropMenuCellStyle style,
    Color bgColor,
    String label,
  ) {
    return TolyDropMenu(
        onSelect: onSelect,
        style: style,
        subMenuGap: 6,
        placement: Placement.bottomStart,
        decorationConfig:
            DecorationConfig(isBubble: false, backgroundColor: bgColor),
        offsetCalculator: boxOffsetCalculator,
        menuItems: [
          ActionMenu(const MenuMeta(router: '01', label: '1st menu item')),
          ActionMenu(const MenuMeta(router: '02', label: '2nd menu item')),
          SubMenu(const MenuMeta(router: 'export', label: 'export image'),
              menus: [
                ActionMenu(
                    const MenuMeta(router: 'png', label: 'sub out .png')),
                ActionMenu(
                    const MenuMeta(router: 'jpeg', label: 'sub out .jpeg')),
                ActionMenu(
                    const MenuMeta(router: 'svg', label: 'sub out .svg')),
                SubMenu(
                    const MenuMeta(router: 'sub sub', label: 'sub sub menu'),
                    menus: [
                      ActionMenu(const MenuMeta(router: 's1', label: 'sub menu1')),
                      ActionMenu(const MenuMeta(router: 's2', label: 'sub menu2')),
                      ActionMenu(const MenuMeta(router: 's3', label: 'sub menu3')),
                    ]),
              ]),
          const DividerMenu(),
          ActionMenu(const MenuMeta(router: '03', label: '3rd menu item'),
              enable: false),
          ActionMenu(const MenuMeta(router: '04', label: '4ur menu item')),
        ],
        // width: 160,
        childBuilder: (_, ctrl, __) {
          return DebugDisplayButton(
            info: 'DIY Style#$label',
            onPressed: ctrl.open,
          );
        });
  }

  void onSelect(
    MenuMeta menu,
  ) {
    $message.success(message: '点击了 [${menu.label}] 菜单');
  }
}"""
  }, 'DropMenuDemo6': {
        'title': '自定义 Meta 拓展和首尾组件',
        'desc': '可以通过自定义 Meta 和首尾组件构造器，来灵活定制菜单项的表现。',
        'code': r"""class MenuDisplayExt extends MenuMateExt {
  final ImageProvider? image;
  final String? action;

  const MenuDisplayExt({this.image, this.action});
}

class DropMenuDemo6 extends StatelessWidget {
  const DropMenuDemo6({super.key});

  @override
  Widget build(BuildContext context) {
    DropMenuCellStyle lightStyle = const DropMenuCellStyle(
      padding: EdgeInsets.symmetric(horizontal: 8),
      borderRadius: BorderRadius.all(Radius.circular(6)),
      foregroundColor: Color(0xff1f1f1f),
      backgroundColor: Colors.transparent,
      disableColor: Color(0xffbfbfbf),
      hoverBackgroundColor: Color(0xfff5f5f5),
      hoverForegroundColor: Color(0xff1f1f1f),
    );
    return Align(
      alignment: Alignment.centerLeft,
      child: TolyDropMenu(
          onSelect: onSelect,
          style: lightStyle,
          tailBuilder: _tailBuilder,
          leadingBuilder: _leadingBuilder,
          subMenuGap: 6,
          placement: Placement.bottomStart,
          decorationConfig:
              DecorationConfig(isBubble: false, backgroundColor: Colors.white),
          offsetCalculator: boxOffsetCalculator,
          menuItems: [
            ActionMenu(const MenuMeta(
                router: '01',
                label: '1st menu item',
                ext: MenuDisplayExt(
                  image: AssetImage('assets/images/icon_head.webp'),
                  action: 'Ctrl+J',
                ))),
            ActionMenu(
              const MenuMeta(
                  router: '02',
                  label: '2nd menu item',
                  ext: MenuDisplayExt(
                    image: AssetImage('assets/images/logo.png'),
                    action: 'Ctrl+P',
                  )),
            ),
            SubMenu(
                const MenuMeta(router: 'export', label: 'export image', icon: Icons.file_upload_outlined),
                menus: [
                  ActionMenu(const MenuMeta(router: 'png', label: 'sub out .png')),
                  ActionMenu(const MenuMeta(router: 'jpeg', label: 'sub out .jpeg')),
                  ActionMenu(const MenuMeta(router: 'svg', label: 'sub out .svg')),
                  SubMenu(
                      const MenuMeta(router: 'sub sub', label: 'sub sub menu'),
                      menus: [
                        ActionMenu(const MenuMeta(router: 's1', label: 'sub menu1')),
                        ActionMenu(const MenuMeta(router: 's2', label: 'sub menu2')),
                        ActionMenu(const MenuMeta(router: 's3', label: 'sub menu3')),
                      ]),
                ]),
            const DividerMenu(),
            ActionMenu(const MenuMeta(router: '03', label: '3rd menu item'), enable: false),
            ActionMenu(const MenuMeta(router: '04', label: '4ur menu item')),
          ],
          // width: 160,
          childBuilder: (_, ctrl, __) {
            return DebugDisplayButton(
              info: 'Leading&tail',
              onPressed: ctrl.open,
            );
          }),
    );
  }

  void onSelect(MenuMeta menu) {
    $message.success(message: '点击了 [${menu.label}] 菜单');
  }

  Widget? _tailBuilder(_, MenuMeta menu, DropMenuDisplayMeta display) {
    MenuDisplayExt? ext = menu.ext?.me<MenuDisplayExt>();
    
    if (ext?.action != null) {
      const TextStyle style = TextStyle(color: Colors.grey, fontSize: 12);
      return Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Text(ext!.action!, style: style),
      );
    }

    return null;
  }

  Widget? _leadingBuilder(_, MenuMeta menu, DropMenuDisplayMeta display) {
    if (menu.router == '04') {
      return const Padding(
          padding:  EdgeInsets.only(right: 8.0),
          child: FlutterLogo(size: 18));
    }
    MenuDisplayExt? ext = menu.ext?.me<MenuDisplayExt>();
    if (ext?.image != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Image(image: ext!.image!, width: 20),
      );
    }
    if (menu.icon != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Icon(menu.icon!, size: 20),
      );
    }
    return null;
  }
}"""
      },
  'DropMenuDemo7': {
    'title': '右键触发',
    'desc': '可以通过右键，在一个组件之上弹出菜单面板。',
    'code': r"""class DropMenuDemo7 extends StatelessWidget{
  const DropMenuDemo7({super.key});

  @override
  Widget build(BuildContext context) {
    Color bgColor = context.isDark? const Color(0xff303133):Colors.white;

    return TolyDropMenu(
      onSelect: onSelect,
      decorationConfig:  DecorationConfig(isBubble: false,backgroundColor: bgColor),
      placement: Placement.topStart,
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
    $message.success(message: '点击了 [${menu.label}] 菜单');
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
