import 'package:flutter/material.dart';
import 'package:tolyui_meta/tolyui_meta.dart';

import '../../model/menu_meta.dart';
import '../../model/model.dart';
import '../size_change/drag_change_width.dart';
import '../view.dart';
import 'menu.dart';

class TolyRailMenuBar extends StatefulWidget {
  final double width;
  final double maxWidth;
  final String? activeId;
  final Color? backgroundColor;
  final List<MenuMeta> menus;
  final ValueChanged<String> onSelected;
  final bool enableWidthChange;
  final MenuCellBuilder? cellBuilder;
  final EdgeInsetsGeometry padding;
  final AnimationConfig animationConfig;
  final WidthTypeParser? widthTypeParser;
  final WidthTypeBuilder? leading;
  final WidthTypeBuilder? tail;
  final double gap;
  final MenuCellStyle cellStyle;

  const TolyRailMenuBar({
    super.key,
    this.width = 64,
    this.maxWidth = 360,
    this.gap = 6,
    this.backgroundColor,
    this.enableWidthChange = false,
    this.activeId,
    required this.menus,
    required this.onSelected,
    this.leading,
    this.widthTypeParser,
    this.tail,
    this.cellStyle = const MenuCellStyle(),
    this.padding = const EdgeInsets.symmetric(horizontal: 4),
    this.cellBuilder,
    this.animationConfig = const AnimationConfig(),
  });

  @override
  State<TolyRailMenuBar> createState() => _TolyRailMenuBarState();
}


typedef WidthTypeParser = MenuWidthType Function(double width);
typedef WidthTypeBuilder = Widget Function(MenuWidthType type);

class _TolyRailMenuBarState extends State<TolyRailMenuBar> {
  WidthTypeParser get effectWidthTypeParser =>
      widget.widthTypeParser ?? _defaultWidthTypeParser;

  MenuWidthType _defaultWidthTypeParser(double width) {
    if (width > 140) return MenuWidthType.large;
    return MenuWidthType.small;
  }

  @override
  Widget build(BuildContext context) {
    Widget child = LayoutBuilder(
      builder: (ctx, cts) {
        MenuWidthType widthType = effectWidthTypeParser(cts.maxWidth);
        return Column(
          children: [
            if (widget.leading != null)
              SizedBox(
                width: cts.maxWidth,
                child: widget.leading!(widthType),
              ),
            Expanded(
              child: RailMenu(
                cellStyle: widget.cellStyle,
                items: widget.menus,
                activeId: widget.activeId,
                onTapItem: widget.onSelected,
                builder: widget.cellBuilder,
                padding: widget.padding,
                animationConfig: widget.animationConfig,
                widthType: widthType,
                gap: widget.gap,
              ),
            ),
            if (widget.tail != null)
              SizedBox(width: cts.maxWidth, child: widget.tail!(widthType)),
          ],
        );
      },
    );

    if (widget.enableWidthChange) {
      child = ChangeWidthArea(
        width: widget.width,
        range: RangeValues(widget.width,widget.maxWidth),
        child: child,
      );
    } else {
      child = SizedBox(
        width: widget.width,
        child: child,
        // child: const Placeholder(),
      );
    }
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: Alignment.topLeft,
      child: ColoredBox(
        color: widget.backgroundColor ??
            (isDark ? Color(0xff191a1c) : Color(0xfff6f7f8)),
        child: child,
      ),
    );
  }
}
