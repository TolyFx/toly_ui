import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/incubator/components/navigation/toly_breadcrumb.dart';
import 'package:tolyui/tolyui.dart';

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
