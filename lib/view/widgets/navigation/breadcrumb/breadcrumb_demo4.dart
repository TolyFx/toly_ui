import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '自定义菜单项',
  desc: '通过 cellBuilder 属性，可以自定义构建菜单项组件。结合 TolyDropMenu 可以实现面包屑 + 弹出菜单的效果：',
)
class BreadcrumbDemo4 extends StatelessWidget {
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
      items: [
        IconMenu(Icons.add_home_work_rounded, label: 'Home', route: '/'),
        IconMenu(Icons.widgets, label: 'Widget', route: '/widgets'),
        MenuMeta(label: 'Navigation', route: ''),
        MenuMeta(label: 'Breadcrumb', route: ''),
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

    bool hasTarget = (menu.route.isNotEmpty);
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
    IconData? icon;
    if (menu is IconMenu) {
      icon = (menu as IconMenu).icon;
    }
    if (icon != null) {
      child = Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          child
        ],
      );
    }

    if (menu.route == '/') {
      child = TolyDropMenu(
        hoverConfig: HoverConfig(enterPop: true),
        decorationConfig:
            DecorationConfig(isBubble: false, backgroundColor: Colors.white),
        onSelect: (menu) => context.go(menu.route),
        menuItems: [
          ActionMenu(const MenuMeta(route: '/guide', label: '使用指南')),
          ActionMenu(const MenuMeta(route: '/widgets', label: '组件总览')),
          ActionMenu(const MenuMeta(route: '/ecological', label: '生态环境')),
          ActionMenu(const MenuMeta(route: '/sponsor', label: '赞助项目')),
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
