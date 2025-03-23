import 'package:flutter/material.dart';
import 'package:tolyui_meta/tolyui_meta.dart';
import '../../model/display_meta.dart';
import '../../model/menu_meta.dart';
import '../view.dart';

typedef MenuCellBuilder = Widget Function(
  MenuMeta menu,
  DisplayMeta display,
);

class RailMenu extends StatelessWidget {
  final List<MenuMeta> items;
  final ValueChanged<String> onTapItem;
  final MenuCellBuilder? builder;
  final EdgeInsetsGeometry padding;
  final String? activeId;
  final AnimationConfig animationConfig;
  final MenuWidthType widthType;
  final double gap;
  final MenuCellStyle cellStyle;

  const RailMenu({
    super.key,
    required this.items,
    required this.activeId,
    required this.onTapItem,
    required this.animationConfig,
    this.builder,
    this.gap = 6,
    required this.cellStyle,
    required this.padding,
    required this.widthType,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: ListView.separated(
          padding: padding,
          separatorBuilder: (_, __) => SizedBox(
            height: gap,
          ),
          itemBuilder: _buildItem,
          itemCount: items.length,
        ));
  }

  Widget? _buildItem(BuildContext context, int index) {
    return RailMenuItemWidget(
      cellStyle: cellStyle,
      widthType: widthType,
      animationConfig: animationConfig,
      builder: builder,
      item: items[index],
      selected: items[index].route == activeId,
      onTap: () => onTapItem.call(items[index].route),
    );
  }
}

enum AnimTickType { none, select, hove }

class AnimationConfig {
  final AnimTickType type;
  final Duration duration;
  final Curve curve;

  bool get enable => type != AnimTickType.none;

  const AnimationConfig({
    this.type = AnimTickType.select,
    this.duration = const Duration(milliseconds: 360),
    this.curve = Curves.ease,
  });
}

class RailMenuItemWidget extends StatefulWidget {
  final MenuMeta item;
  final bool selected;
  final VoidCallback onTap;
  final MenuCellBuilder? builder;
  final AnimationConfig animationConfig;
  final MenuWidthType widthType;
  final MenuCellStyle cellStyle;

  const RailMenuItemWidget({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
    required this.builder,
    required this.animationConfig,
    required this.widthType,
    required this.cellStyle,
  });

  @override
  State<RailMenuItemWidget> createState() => _RailMenuItemWidgetState();
}

class _RailMenuItemWidgetState extends State<RailMenuItemWidget>
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

  void updateAnimation() {
    if (_ctrl != null) {
      _ctrl!.duration = widget.animationConfig.duration;

      _curveAnima = CurvedAnimation(
        parent: _ctrl!,
        curve: widget.animationConfig.curve,
      );
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

  Widget _defaultMenuCellBuilder(
    MenuMeta menu,
    DisplayMeta display,
  ) {
    return TolyUiMenuCell(
      menu: menu,
      display: display,
      style: widget.cellStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.selected ? null : onTap,
      onHover: widget.selected ? null : onHover,
      child: buildCellOrAnimation(),
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
    MenuCellBuilder builder = widget.builder ?? _defaultMenuCellBuilder;
    return builder(
        widget.item,
        DisplayMeta(
          selected: widget.selected,
          hovered: _hover,
          anima: _curveAnima?.value,
          brightness: Theme.of(context).brightness,
          widthType: widget.widthType,
        ));
  }

  void onHover(bool hovered) {
    _hoverAnimaTick(hovered);
    setState(() {
      _hover = hovered;
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

  void onTap() {
    widget.onTap();
    setState(() {
      _hover = false;
    });
  }

  @override
  void didUpdateWidget(covariant RailMenuItemWidget oldWidget) {
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
  }
}
