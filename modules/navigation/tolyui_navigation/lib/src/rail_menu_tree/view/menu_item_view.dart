import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tolyui_meta/tolyui_meta.dart';

import '../../../tolyui_navigation.dart';

class MenuNodeItemView extends StatefulWidget {
  final MenuNode data;
  final MenuTreeCellBuilder builder;
  final AnimationConfig animationConfig;

  final String? activeMenu;
  final List<String> expandMenus;
  final ValueChanged<MenuNode> onSelect;
  final Color expandBackgroundColor;

  const MenuNodeItemView({
    super.key,
    required this.data,
    required this.activeMenu,
    required this.expandMenus,
    required this.onSelect,
    required this.builder,
    required this.expandBackgroundColor,
    required this.animationConfig,
  });

  @override
  State<MenuNodeItemView> createState() => _MenuNodeItemViewState();
}

class _MenuNodeItemViewState extends State<MenuNodeItemView> {
  bool get activeExpandMenu {
    return widget.expandMenus.contains(widget.data.id);
  }

  CrossFadeState get crossFadeState =>
      !activeExpandMenu ? CrossFadeState.showFirst : CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context) {
    bool active = widget.activeMenu == widget.data.id
    || (widget.activeMenu??'').startsWith(widget.data.id);
    ;
    return Column(
      children: [
        MenuItemView(
          builder: widget.builder,
          expanded: crossFadeState == CrossFadeState.showSecond,
          onSelect: widget.onSelect,
          selected: active,
          node: widget.data, animationConfig: widget.animationConfig,
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
              child: MenuNodeItemView(
                animationConfig: widget.animationConfig,
                builder: widget.builder,
                expandBackgroundColor: widget.expandBackgroundColor,
                onSelect: widget.onSelect,
                data: e,
                activeMenu: widget.activeMenu,
                expandMenus: widget.expandMenus,
              ),
            ))
        .toList();
  }
}

/// 一个菜单栏的视图
class MenuItemView extends StatefulWidget {
  final MenuTreeCellBuilder builder;
  final MenuNode node;
  final ValueChanged<MenuNode> onSelect;
  final bool selected;
  final bool expanded;
  final AnimationConfig animationConfig;

  const MenuItemView({
    super.key,
    required this.builder,
    required this.node,
    required this.selected,
    required this.onSelect,
    required this.expanded,
    required this.animationConfig,
  });

  @override
  State<MenuItemView> createState() => _MenuItemViewState();
}

class _MenuItemViewState extends State<MenuItemView>
    with TickerProviderStateMixin {
  bool _hover = false;

  AnimationController? _ctrl;
  Animation<double>? _curveAnima;

  @override
  void initState() {
    _createAnimationWhenNeed();
    super.initState();
  }

  void _createAnimationWhenNeed() {
    if (widget.animationConfig.enable) {
      _ctrl = AnimationController(vsync: this);
      updateAnimation();
      if (widget.selected) {
        _ctrl?.value = 1;
      }
    }
  }

  void _releaseAnimation() {
    _ctrl?.dispose();
    _ctrl = null;
  }

  @override
  void dispose() {
    _releaseAnimation();
    super.dispose();
  }

  void updateAnimation() {
    if (_ctrl != null) {
      _ctrl!.duration = widget.animationConfig.duration;

      _curveAnima = CurvedAnimation(
        parent: _ctrl!,
        curve: widget.animationConfig.curve,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: _onEnter,
      onExit: _onExit,
      child: GestureDetector(
        onTap: () => widget.onSelect(widget.node),
        child: buildCellOrAnimation(),
      ),
    );
  }

  Widget buildCellOrAnimation() {
    if (widget.animationConfig.enable && _curveAnima != null) {
      return AnimatedBuilder(
        animation: _curveAnima!,
        builder: (_, __) => buildCell(),
      );
    }
    return buildCell();
  }

  Widget buildCell() {
    Brightness brightness = Theme.of(context).brightness;
    return widget.builder.call(
        widget.node,
        DisplayMeta(
          selected: widget.selected,
          hovered: _hover,
          brightness: brightness,
          anima: _curveAnima?.value,
          widthType: MenuWidthType.large,
          expanded: widget.expanded
        ));
  }

  void _onEnter(PointerEnterEvent event) {
    _hoverAnimaTick(true);
    setState(() {
      _hover = true;
    });
  }

  void _onExit(PointerExitEvent event) {
    _hoverAnimaTick(false);
    setState(() {
      _hover = false;
    });
  }

  void _hoverAnimaTick(bool hovered) {
    if (!(widget.animationConfig.type == AnimTickType.hove)) return;
    if (hovered) {
      _ctrl?.forward();
    } else {
      _ctrl?.reverse();
    }
  }

  @override
  void didUpdateWidget(covariant MenuItemView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animationConfig.enable != widget.animationConfig.enable) {
      if (widget.animationConfig.enable) {
        _createAnimationWhenNeed();
      } else {
        _releaseAnimation();
      }
    }

    if (oldWidget.animationConfig.duration != widget.animationConfig.duration ||
        oldWidget.animationConfig.curve != widget.animationConfig.curve) {
      updateAnimation();
    }

    if (oldWidget.selected != widget.selected) {
      if (widget.selected) {
        _ctrl?.forward();
      } else {
        _ctrl?.reverse();
      }
    }

    if (oldWidget.expanded != widget.expanded) {
      if (widget.expanded) {
        _ctrl?.forward();
      } else {
        _ctrl?.reverse();
      }
    }
  }
}


typedef MenuTreeCellBuilder = Widget Function(
  MenuNode node,
  DisplayMeta display,
);

