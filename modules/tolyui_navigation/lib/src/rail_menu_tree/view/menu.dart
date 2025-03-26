import 'package:flutter/material.dart';
import 'package:tolyui_meta/tolyui_meta.dart';
import '../../../tolyui_navigation.dart';
import 'toly_ui_tree_menu_cell.dart';

class TolyRailMenuTree extends StatelessWidget {
  final double width;
  final double maxWidth;
  final bool enableWidthChange;

  final Widget? leading;
  final Widget? tail;

  final MenuTreeMeta meta;

  final Color? backgroundColor;
  final Color? expandBackgroundColor;
  final MenuTreeCellStyle? cellStyle;

  final ValueChanged<MenuNode> onSelect;
  final MenuTreeCellBuilder? builder;
  final AnimationConfig animationConfig;

  const TolyRailMenuTree({
    super.key,
    required this.meta,
    this.backgroundColor,
    this.leading,
    this.tail,
    this.expandBackgroundColor,
    this.enableWidthChange = false,
    this.animationConfig = const AnimationConfig(),
    required this.onSelect,
    this.builder,
    this.cellStyle,
    this.width = 240,
    this.maxWidth = 360,
  });

  Widget _defaultMenuTreeCellBuilder(MenuNode node, DisplayMeta display) {
    return TolyUITreeMenuCell(
      menuNode: node,
      display: display,
      style: cellStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    TolyMenuTheme? tolyMenuTheme = Theme.of(context).extension<TolyMenuTheme>();
    MenuTreeCellBuilder effectBuilder = builder ?? _defaultMenuTreeCellBuilder;
    Widget child = ColoredBox(
      color: backgroundColor ??
          tolyMenuTheme?.backgroundColor ??
          Colors.transparent,
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
          itemCount: meta.items.length,
          itemBuilder: (_, index) => MenuNodeItemView(
            builder: effectBuilder,
            onSelect: onSelect,
            data: meta.items[index],
            activeMenu: meta.activeMenu?.id,
            expandMenus: meta.expandMenus,
            expandBackgroundColor: expandBackgroundColor ??
                tolyMenuTheme?.expandBackgroundColor ??
                Colors.transparent,
            animationConfig: animationConfig,
          ),
        ),
      ),
    );

    if (leading != null || tail != null) {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) leading!,
          Expanded(child: child),
          if (tail != null) tail!,
        ],
      );
    }

    if (enableWidthChange) {
      child = ChangeWidthArea(
        width: width,
        range: RangeValues(width, maxWidth),
        child: child,
      );
    } else {
      child = SizedBox(
        width: width,
        child: child,
        // child: const Placeholder(),
      );
    }
    return child;
  }
}
