import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../toly_menu.dart';
import r'expand_icon$.dart';
import 'menu_theme.dart';

class MenuNodeView extends StatefulWidget {
  final MenuNode data;
  final MenuItemBuilder? builder;

  final String activeMenu;
  final List<String> expandMenus;
  final ValueChanged<MenuNode> onSelect;
  final TextStyle? unselectedLabelTextStyle;
  final TextStyle? selectedLabelTextStyle;
  final Color expandBackgroundColor;
  final Color activeColor;
  final Color? activeItemBackground;

  const MenuNodeView({
    super.key,
    required this.data,
    required this.activeMenu,
    required this.expandMenus,
    required this.onSelect,
    this.unselectedLabelTextStyle,
    this.selectedLabelTextStyle,
    this.builder,
    this.activeItemBackground,
    required this.expandBackgroundColor,
    required this.activeColor,
  });

  @override
  State<MenuNodeView> createState() => _MenuNodeViewState();
}

class _MenuNodeViewState extends State<MenuNodeView> {
  bool get activeExpandMenu {
    return widget.expandMenus.contains(widget.data.path);
  }

  CrossFadeState get crossFadeState =>
      !activeExpandMenu ? CrossFadeState.showFirst : CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    bool active = widget.activeMenu == widget.data.path;
    return Column(
      children: [
        MenuItemView(
          activeItemBackground: widget.activeItemBackground,
          builder: widget.builder,
          selectedLabelTextStyle: widget.selectedLabelTextStyle,
          activeColor: widget.activeColor,
          unselectedLabelTextStyle: widget.unselectedLabelTextStyle,
          expanded: crossFadeState == CrossFadeState.showSecond,
          onSelect: widget.onSelect,
          active: active,
          data: widget.data,
        ),
        AnimatedCrossFade(
            firstChild: const SizedBox(width: double.maxFinite),
            secondChild: Column(
              children: [..._buildChildrenItem(widget.data.children)],
            ),
            crossFadeState: crossFadeState,
            duration: const Duration(milliseconds: 200))
      ],
    );
  }

  List<Widget> _buildChildrenItem(List<MenuNode> children) {
    return children
        .map((e) => ColoredBox(
              color: widget.expandBackgroundColor,
              child: MenuNodeView(
                activeItemBackground: widget.activeItemBackground,
                builder: widget.builder,
                activeColor: widget.activeColor,
                expandBackgroundColor: widget.expandBackgroundColor,
                onSelect: widget.onSelect,
                data: e,
                activeMenu: widget.activeMenu,
                expandMenus: widget.expandMenus,
                unselectedLabelTextStyle: widget.unselectedLabelTextStyle,
                selectedLabelTextStyle: widget.selectedLabelTextStyle,
              ),
            ))
        .toList();
  }
}

/// 一个菜单栏的视图
class MenuItemView extends StatefulWidget {
  final MenuItemBuilder? builder;
  final MenuNode data;
  final ValueChanged<MenuNode> onSelect;
  final bool active;
  final bool expanded;
  final TextStyle? unselectedLabelTextStyle;
  final TextStyle? selectedLabelTextStyle;
  final Color activeColor;
  final Color? activeItemBackground;

  const MenuItemView({
    super.key,
    this.builder,
    required this.data,
    required this.selectedLabelTextStyle,
    required this.unselectedLabelTextStyle,
    required this.active,
    required this.onSelect,
    required this.expanded,
    required this.activeColor,
    required this.activeItemBackground,
  });

  @override
  State<MenuItemView> createState() => _MenuItemViewState();
}

class _MenuItemViewState extends State<MenuItemView> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    MenuItemState menuItemState = MenuItemState(
      selectedLabelTextStyle: widget.selectedLabelTextStyle,
      unselectedLabelTextStyle: widget.unselectedLabelTextStyle,
      selectedItemBackground: widget.activeItemBackground,
      active: widget.active,
      expanded: widget.expanded,
      node: widget.data,
      isHover: _hover,
    );

    Widget? child = widget.builder?.call(context, menuItemState);
    child = child ?? DefaultMenuItem(state: menuItemState);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onTap: () => widget.onSelect(widget.data),
        child: child,
      ),
    );
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

class MenuItemState {
  final TextStyle? selectedLabelTextStyle;
  final TextStyle? unselectedLabelTextStyle;
  final bool active;
  final bool isHover;
  final bool expanded;
  final MenuNode node;
  final Color? selectedItemBackground;

  MenuItemState({
    required this.selectedLabelTextStyle,
    required this.active,
    required this.expanded,
    required this.node,
    required this.unselectedLabelTextStyle,
    required this.isHover,
    this.selectedItemBackground,
  });
}

typedef MenuItemBuilder = Widget Function(
    BuildContext context, MenuItemState state);

Widget _defaultMenuItemBuilder(BuildContext context, MenuItemState state) {
  return DefaultMenuItem(
    state: state,
  );
}

class DefaultMenuItem extends StatelessWidget {
  final MenuItemState state;

  const DefaultMenuItem({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    TolyMenuTheme? theme = Theme.of(context).extension<TolyMenuTheme>();
    TextStyle? selectedStyle =
        state.selectedLabelTextStyle ?? theme?.selectedLabelTextStyle;
    TextStyle? unselectedStyle = state.unselectedLabelTextStyle ??
        theme?.unselectedLabelTextStyle;

    TextStyle? textStyle =
        (state.active || state.expanded) ? selectedStyle : unselectedStyle;

    if (state.isHover) {
      textStyle = textStyle?.copyWith(color: selectedStyle?.color);
    }

    Color? activeItemBackground =
        state.selectedItemBackground ?? theme?.selectedItemBackground;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: state.active
            ? Border(
                right: BorderSide(
                    width: 4, color: textStyle?.color ?? Colors.transparent))
            : null,
        color: state.active ? activeItemBackground : null,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(
                  horizontal: 24.0 + (12 * state.node.deep), vertical: 14),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (state.node.icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Icon(
                        state.node.icon,
                        size: 18,
                        color: textStyle?.color,
                      ),
                    ),
                  Text(state.node.label,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: textStyle
                      // _hover?:widget.labelTextStyle.copyWith(
                      //       color: widget.labelTextStyle.color?.withOpacity(0.7)
                      //     ),
                      )
                ],
              ),
            ),
          ),
          if (state.node.children.isNotEmpty)
            _buildExpandIndicator(state.expanded, selectedStyle?.color)
        ],
      ),
    );
  }

  Widget _buildExpandIndicator(bool expanded, Color? color) {
    // Color? color = Theme.of(context).extension<TolyMenuTheme>()?.selectedLabelTextStyle?.color;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ExpandIcon$(
        size: 24,
        expandedColor: color,
        isExpanded: expanded,
        color: state.isHover ? color : null,
        // onPressed: (bool value) => widget.onSelect(widget.data),
        // color: widget.labelTextStyle.color,
      ),
    );
  }
}
