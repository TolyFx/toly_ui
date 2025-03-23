import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tolyui_meta/tolyui_meta.dart';

import '../model/model.dart';

class TolyBreadcrumb extends StatelessWidget {
  final List<MenuMeta> items;
  final double fontSize;
  final BreadcrumbCellStyle? cellStyle;
  final Widget? separator;
  final ValueChanged<String>? onSelect;
  final BreadcrumbCellBuilder? cellBuilder;

  const TolyBreadcrumb({
    super.key,
    required this.items,
    this.onSelect,
    this.cellBuilder,
    this.cellStyle,
    this.separator,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    for (int i = 0; i < items.length; i++) {
      children.add(TolyBreadcrumbItem(
        cellStyle: cellStyle,
        builder: cellBuilder,
        last: i == items.length - 1,
        fontSize: fontSize,
        item: items[i],
        onTapItem: onSelect,
      ));
      if (i != items.length - 1) {
        children.add(_buildSeparator());
      }
    }
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: children,
    );
  }

  Widget _buildSeparator() {
    return separator ??
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text('/', style: TextStyle(color: Colors.grey)),
        );
  }
}

class BreadcrumbMeta {
  final bool isLast;
  final bool enable;
  final bool hovered;
  final double fountSize;

  BreadcrumbMeta({
    required this.isLast,
    required this.enable,
    required this.hovered,
    required this.fountSize,
  });
}

class HoverBackgroundStyle {
  final EdgeInsets padding;
  final BorderRadius radius;
  final Color backgroundColor;

  const HoverBackgroundStyle({
    this.padding = const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    this.radius = const BorderRadius.all(Radius.circular(4)),
    this.backgroundColor = const Color(0xfff0f0f0),
  });
}

class BreadcrumbCellStyle {
  final Color? lastCellColor;
  final Color disableCellColor;
  final Color enableCellColor;
  final Color hoverCellColor;
  final HoverBackgroundStyle? hoverBackgroundStyle;

  const BreadcrumbCellStyle({
    this.lastCellColor,
    this.hoverBackgroundStyle,
    required this.disableCellColor,
    required this.enableCellColor,
    required this.hoverCellColor,
  });

  factory BreadcrumbCellStyle.light() => const BreadcrumbCellStyle(
        disableCellColor: Color(0xff8c8c8c),
        enableCellColor: Color(0xff303133),
        hoverCellColor: Colors.blue,
      );

  factory BreadcrumbCellStyle.dark() => const BreadcrumbCellStyle(
        disableCellColor: Color(0xff8c8c8c),
        enableCellColor: Color(0xffc4c8d0),
        hoverCellColor: Colors.blue,
      );
}

typedef BreadcrumbCellBuilder = Widget Function(
    MenuMeta menu, BreadcrumbMeta meta);

class TolyBreadcrumbItem extends StatefulWidget {
  final MenuMeta item;
  final BreadcrumbCellStyle? cellStyle;
  final BreadcrumbCellBuilder? builder;
  final bool last;
  final double fontSize;

  final ValueChanged<String>? onTapItem;

  const TolyBreadcrumbItem({
    super.key,
    required this.item,
    required this.builder,
    required this.onTapItem,
    required this.fontSize,
    required this.last,
    required this.cellStyle,
  });

  @override
  State<TolyBreadcrumbItem> createState() => _TolyBreadcrumbItemState();
}

class _TolyBreadcrumbItemState extends State<TolyBreadcrumbItem> {
  bool _hover = false;

  BreadcrumbCellStyle get effectStyle =>
      widget.cellStyle ??
      (Theme.of(context).brightness == Brightness.dark
          ? BreadcrumbCellStyle.dark()
          : BreadcrumbCellStyle.light());

  @override
  Widget build(BuildContext context) {
    BreadcrumbMeta display = BreadcrumbMeta(
      isLast: widget.last,
      enable: widget.item.route.isNotEmpty,
      hovered: _hover,
      fountSize: widget.fontSize,
    );

    Widget child = widget.builder?.call(widget.item,display) ??
        TolyUIBreadcrumbCell(
          cellStyle: widget.cellStyle,
          display: display,
          menu: widget.item,
        );

    bool hasTarget = display.enable&&!display.isLast;
    MouseCursor cursor = hasTarget ? SystemMouseCursors.click : SystemMouseCursors.basic;
    if (hasTarget) {
      child = MouseRegion(
        cursor: cursor,
        onEnter: _onEnter,
        onExit: _onExit,
        child: GestureDetector(
          onTap: () => widget.onTapItem?.call(widget.item.route),
          child: child,
        ),
      );
    }
    return child;
  }

  void _onEnter(PointerEnterEvent event) {
    setState(() {
      _hover = true;
    });
  }

  void _onExit(PointerExitEvent event) {
    setState(() {
      _hover = false;
    });
  }
}

class TolyUIBreadcrumbCell extends StatelessWidget {
  final BreadcrumbMeta display;
  final BreadcrumbCellStyle? cellStyle;
  final MenuMeta menu;

  const TolyUIBreadcrumbCell({
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
      color = display.hovered ? effectStyle.hoverCellColor : effectStyle.enableCellColor;
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

    if(menu is IconMenu){
      child = Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(
            (menu as IconMenu).icon,
            size: 18,
            color: color,
          ),
          const SizedBox(
            width: 4,
          ),
          child
        ],
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
