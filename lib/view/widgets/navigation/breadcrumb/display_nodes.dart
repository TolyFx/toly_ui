Map<String,dynamic> get displayNodes => {
  'BreadcrumbDemo1': {
    'title': '基础用法',
    'desc': '通过 TolyBreadcrumb 展示面包屑，可容纳 MenuMeta 列表展示条目，默认通过 "/" 分隔。\n'
        'onSelect 回调中处理点击条目事件，可用于路由跳转。不设置 router 的条目，将无法响应点击事件，呈灰色展示。'
    ,
    'code': """class BreadcrumbDemo1 extends StatelessWidget {
  const BreadcrumbDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyBreadcrumb(
      onSelect: context.go,
      items: [
        BreadcrumbItem(label: 'Home',to: '/home'),
        BreadcrumbItem(label: 'Widget'),
        BreadcrumbItem(label: 'Navigation'),
        BreadcrumbItem(label: 'Breadcrumb'),
      ],
    );
  }
}"""
  },
  'BreadcrumbDemo2': {
    'title': '自定义分隔符',
    'desc': '可以通过 separator 参数自定义分隔符组件；MenuMeta 中的 Icon 可以设置菜单项的图标。',
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
  'BreadcrumbDemo3': {
    'title': '自定义样式',
    'desc': '通过 cellStyle 属性，可以设置 BreadcrumbCellStyle 样式配色。如下紫色样式：',
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
  'BreadcrumbDemo4': {
    'title': '自定义菜单项',
    'desc': '通过 cellBuilder 属性，可以自定义构建菜单项组件。结合 TolyDropMenu 可以实现面包屑 + 弹出菜单的效果：',
    'code': """class BreadcrumbDemo4 extends StatelessWidget {
  const BreadcrumbDemo4({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyBreadcrumb(
      onSelect: context.go,
      cellBuilder: (menu, display) => DIYBreadcrumbCell(
        display: display,
        menu: menu,
        cellStyle: const BreadcrumbCellStyle(
          disableCellColor: Color(0xff8c8c8c),
          enableCellColor: Color(0xff303133),
          hoverCellColor: Colors.blue,
        ),
      ),
      items: const [
        MenuMeta(label: 'Home', router: '/', icon: Icons.add_home_work_rounded),
        MenuMeta(label: 'Widget', router: '/widgets', icon: Icons.widgets),
        MenuMeta(label: 'Navigation'),
        MenuMeta(label: 'Breadcrumb'),
      ],
    );
  }
}

class DIYBreadcrumbCell extends StatelessWidget {
  final BreadcrumbMeta display;
  final BreadcrumbCellStyle? cellStyle;
  final MenuMeta menu;

  const DIYBreadcrumbCell({
    super.key,
    required this.display,
    required this.menu,
    this.cellStyle,
  });

  @override
  Widget build(BuildContext context) {
    BreadcrumbCellStyle effectStyle = cellStyle ??
        (Theme.of(context).brightness == Brightness.dark
            ? BreadcrumbCellStyle.dark()
            : BreadcrumbCellStyle.light());

    bool hasTarget = (menu.router.isNotEmpty);
    Color? color;
    if (hasTarget) {
      color = display.hovered
          ? effectStyle.hoverCellColor
          : effectStyle.enableCellColor;
    } else {
      color = effectStyle.disableCellColor;
    }
    if (display.isLast) {
      color = effectStyle.lastCellColor;
    }

    TextStyle style = TextStyle(
        fontSize: display.fountSize,
        fontWeight: hasTarget ? FontWeight.bold : null,
        color: color);
    Widget child = Text(menu.label, style: style);
    if (menu.icon != null) {
      child = Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(menu.icon!, size: 16, color: color),
          const SizedBox(width: 4),
          child
        ],
      );
    }

    if (menu.router == '/') {
      child = TolyDropMenu(
        hoverConfig: HoverConfig(enterPop: true),
        decorationConfig:
            DecorationConfig(isBubble: false, backgroundColor: Colors.white),
        onSelect: (menu) => context.go(menu.router),
        menuItems: [
          ActionMenu(const MenuMeta(router: '/guide', label: '使用指南')),
          ActionMenu(const MenuMeta(router: '/widgets', label: '组件总览')),
          ActionMenu(const MenuMeta(router: '/ecological', label: '生态环境')),
          ActionMenu(const MenuMeta(router: '/sponsor', label: '赞助项目')),
        ],
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            child,
            Icon(Icons.expand_more, size: 16, color: color),
          ],
        ),
      );
    }
    if (effectStyle.hoverBackgroundStyle != null) {
      child = Container(
        padding: effectStyle.hoverBackgroundStyle!.padding,
        decoration: BoxDecoration(
            color: display.hovered
                ? effectStyle.hoverBackgroundStyle!.backgroundColor
                : null,
            borderRadius: effectStyle.hoverBackgroundStyle!.radius),
        child: child,
      );
    }
    return child;
  }
}
"""
  },
};