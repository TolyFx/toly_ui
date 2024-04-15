import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'model/menu_state.dart';
import 'model/menu_data.dart';

class TolyMenu extends StatelessWidget {
  final MenuState state;
  final TextStyle labelTextStyle;
  final Color backgroundColor;
  final Color activeColor;
  final Color expandBackgroundColor;
  final ValueChanged<MenuNode> onSelect;

  const TolyMenu({
    super.key,
    required this.state,
    this.backgroundColor = const Color(0xff001529),
    this.expandBackgroundColor = const Color(0xff0C2135),
    this.labelTextStyle = const TextStyle(color: Colors.white),
    required this.onSelect,
    this.activeColor = const Color(0xff0960BD),
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor,
      child: ListView.builder(
        itemCount: state.items.length,
        itemBuilder: (_, index) => MenuItemView(
          activeColor: activeColor,
          labelTextStyle: labelTextStyle,
          onSelect: onSelect,
          data: state.items[index],
          activeMenu: state.activeMenu,
          expandMenus: state.expandMenus,
          expandBackgroundColor: expandBackgroundColor,
        ),
      ),
    );
  }
}

class MenuItemView extends StatefulWidget {
  final MenuNode data;
  final String activeMenu;
  final List<String> expandMenus;
  final ValueChanged<MenuNode> onSelect;
  final TextStyle labelTextStyle;
  final Color expandBackgroundColor;
  final Color activeColor;

  const MenuItemView({
    super.key,
    required this.data,
    required this.activeMenu,
    required this.expandMenus,
    required this.onSelect,
    required this.labelTextStyle,
    required this.expandBackgroundColor,
    required this.activeColor,
  });

  @override
  State<MenuItemView> createState() => _MenuItemViewState();
}

class _MenuItemViewState extends State<MenuItemView> {
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
        AMenuItem(
          activeColor: widget.activeColor,
          labelTextStyle: widget.labelTextStyle,
          expanded: crossFadeState == CrossFadeState.showSecond,
          onSelect: widget.onSelect,
          active: active,
          data: widget.data,
        ),
        AnimatedCrossFade(
            firstChild: const SizedBox(
              width: double.maxFinite,
            ),
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
              child: MenuItemView(
                activeColor: widget.activeColor,
                expandBackgroundColor: widget.expandBackgroundColor,
                onSelect: widget.onSelect,
                data: e,
                activeMenu: widget.activeMenu,
                expandMenus: widget.expandMenus,
                labelTextStyle: widget.labelTextStyle,
              ),
            ))
        .toList();
  }
}

class AMenuItem extends StatefulWidget {
  final MenuNode data;
  final ValueChanged<MenuNode> onSelect;
  final bool active;
  final bool expanded;
  final TextStyle labelTextStyle;
  final Color activeColor;

  const AMenuItem({
    super.key,
    required this.data,
    required this.labelTextStyle,
    required this.active,
    required this.onSelect,
    required this.expanded,
    required this.activeColor,
  });

  @override
  State<AMenuItem> createState() => _AMenuItemState();
}

class _AMenuItemState extends State<AMenuItem> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onTap: () => widget.onSelect(widget.data),
        child: ColoredBox(
          color: widget.active ? widget.activeColor : Colors.transparent,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(
                      horizontal: 24.0 + (12 * widget.data.deep), vertical: 14),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (widget.data.icon != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Icon(
                            widget.data.icon,
                            size: 18,
                            color:widget.labelTextStyle.color,
                          ),
                        ),
                      Text(widget.data.label,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: widget.labelTextStyle

                          // _hover?:widget.labelTextStyle.copyWith(
                          //       color: widget.labelTextStyle.color?.withOpacity(0.7)
                          //     ),
                          )
                    ],
                  ),
                ),
              ),
              if (widget.data.children.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ExpandIcon(
                      size: 18,
                      isExpanded: widget.expanded,
                      onPressed: (bool value) => widget.onSelect(widget.data),
                      color: widget.labelTextStyle.color,),
                )
            ],
          ),
        ),
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
