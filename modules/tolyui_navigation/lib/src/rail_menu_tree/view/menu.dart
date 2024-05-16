import 'package:flutter/material.dart';
import '../../../tolyui_navigation.dart';
import 'toly_ui_tree_menu_cell.dart';

class TolyRailMenuTree extends StatelessWidget {
  final double width;
  final double maxWidth;
  final MenuTreeMeta meta;
  final TextStyle? labelTextStyle;
  final Color? backgroundColor;
  final Color activeColor;
  final Color? expandBackgroundColor;
  final Color? activeItemBackground;
  final ValueChanged<MenuNode> onSelect;
  final MenuTreeCellBuilder? builder;
  final AnimationConfig animationConfig;
  final bool enableWidthChange;

  const TolyRailMenuTree({
    super.key,
    required this.meta,
    this.backgroundColor,
    this.expandBackgroundColor,
    this.activeItemBackground,
    this.enableWidthChange = false,
    this.animationConfig = const AnimationConfig(),
    this.labelTextStyle,
    required this.onSelect,
    this.activeColor = const Color(0xff0960BD),
    this.builder,
     this.width = 240,
     this.maxWidth = 360,
  });

  Widget _defaultMenuTreeCellBuilder(MenuNode node, DisplayMeta display) {
    return TolyUITreeMenuCell(
      menuNode: node,
      display: display,
    );
  }

  @override
  Widget build(BuildContext context) {
    TolyMenuTheme? tolyMenuTheme = Theme.of(context).extension<TolyMenuTheme>();
    MenuTreeCellBuilder effectBuilder = builder ?? _defaultMenuTreeCellBuilder;
    Widget child =  ColoredBox(
      color: backgroundColor ??
          tolyMenuTheme?.backgroundColor ??
          Colors.transparent,
      child: ListView.builder(
        itemCount: meta.items.length,
        itemBuilder: (_, index) => MenuNodeItemView(
          builder: effectBuilder,
          activeItemBackground: activeItemBackground,
          activeColor: activeColor,
          unselectedLabelTextStyle: labelTextStyle,
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
    );
    if (enableWidthChange) {
      child = ChangeWidthArea(
        width: width,
        range: RangeValues(width,maxWidth),
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
