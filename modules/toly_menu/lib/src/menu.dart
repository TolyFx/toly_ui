import 'package:flutter/material.dart';
import '../toly_menu.dart';
import 'model/menu_state.dart';
import 'model/menu_data.dart';
import 'view/menu_item_view.dart';

class TolyMenu extends StatelessWidget {
  final MenuState state;
  final TextStyle? labelTextStyle;
  final Color? backgroundColor;
  final Color activeColor;
  final Color? expandBackgroundColor;
  final Color? activeItemBackground;
  final ValueChanged<MenuNode> onSelect;

  const TolyMenu({
    super.key,
    required this.state,
    this.backgroundColor,
    this.expandBackgroundColor,
    this.activeItemBackground,
    this.labelTextStyle,
    required this.onSelect,
    this.activeColor = const Color(0xff0960BD),
  });

  @override
  Widget build(BuildContext context) {
    TolyMenuTheme? tolyMenuTheme = Theme.of(context).extension<TolyMenuTheme>();

    return ColoredBox(
      color: backgroundColor??tolyMenuTheme?.backgroundColor??Colors.transparent,
      child: ListView.builder(
        itemCount: state.items.length,
        itemBuilder: (_, index) => MenuNodeView(
          activeItemBackground: activeItemBackground,
          activeColor: activeColor,
          unselectedLabelTextStyle: labelTextStyle,
          onSelect: onSelect,
          data: state.items[index],
          activeMenu: state.activeMenu,
          expandMenus: state.expandMenus,
          expandBackgroundColor: expandBackgroundColor??tolyMenuTheme?.expandBackgroundColor??Colors.transparent,
        ),
      ),
    );
  }
}
