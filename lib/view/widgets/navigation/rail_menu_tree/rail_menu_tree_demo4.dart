import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toly_ui/view/debugger/debugger.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:toly_ui/view/widgets/navigation/rail_menu_tree/plcki_menu_tree_data_plus.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: 'Meta 拓展和自定义构建菜单项',
  desc: '可以通过 MenuMeta 的拓展，以及自定义菜单项，来灵活构建菜单项，以此满足更多的使用场景。',
)
class RailMenuTreeDemo4 extends StatefulWidget {
  const RailMenuTreeDemo4({super.key});

  @override
  State<RailMenuTreeDemo4> createState() => _RailMenuTreeDemo4State();
}

class _RailMenuTreeDemo4State extends State<RailMenuTreeDemo4> {
  late MenuTreeMeta _menuMeta;

  @override
  void initState() {
    super.initState();
    _initTreeMeta();
  }

  @override
  Widget build(BuildContext context) {
    Color expandBackgroundColor = context.isDark ? Colors.black : Colors.transparent;
    Color backgroundColor = context.isDark ? const Color(0xff001529) : Colors.white;
    return SizedBox(
      height: 490,
      child: Row(
        children: [
          TolyRailMenuTree(
            builder: (menu, display) => PlckiTreeMenuCell(
              menuNode: menu,
              display: display,
            ),
            leading: const DebugLeadingAvatar(),
            tail: const VersionTail(),
            enableWidthChange: true,
            meta: _menuMeta,
            backgroundColor: backgroundColor,
            expandBackgroundColor: expandBackgroundColor,
            onSelect: _onSelect,
          ),
        ],
      ),
    );
  }

  @override
  void reassemble() {
    _initTreeMeta();
    super.reassemble();
  }

  void _initTreeMeta() {
    MenuNode root = MenuNode.fromMap(
      plckiMenuDataPlus,
      extParser: PlckiMenuMetaExt.fromMap,
    );
    _menuMeta = MenuTreeMeta(
      expandMenus: ['/dashboard'],
      activeMenu: root.find('/dashboard/home'),
      root: root,
    );
  }

  void _onSelect(MenuNode menu) {
    _menuMeta = _menuMeta.select(menu, singleExpand: true);

    setState(() {});
  }
}

class PlckiMenuMetaExt extends Extra {
  final String? subtitle;
  final String? tag;

  const PlckiMenuMetaExt({
    required this.subtitle,
    required this.tag,
  });

  factory PlckiMenuMetaExt.fromMap(Map<String, dynamic> map) {
    return PlckiMenuMetaExt(
      subtitle: map['subtitle'],
      tag: map['tag'],
    );
  }
}

class PlckiTreeMenuCell extends StatelessWidget {
  final MenuNode menuNode;
  final DisplayMeta display;
  final MenuTreeCellStyle? style;

  const PlckiTreeMenuCell({
    super.key,
    required this.menuNode,
    required this.display,
    this.style,
  });

  MenuTreeCellStyle get effectStyle =>
      style ?? (display.isDark ? MenuTreeCellStyle.dark() : MenuTreeCellStyle.light());

  Color? effectForegroundColor(MenuTreeCellStyle style) {
    if (display.selected) {
      return display.isDark ? Colors.white : style.activeForegroundColor;
    }
    if (display.hovered) {
      return display.isDark ? Colors.white : style.hoverForegroundColor;
    }
    return style.inactiveForegroundColor;
  }

  double get anim => display.anima ?? 1;

  Color? backgroundColor(MenuTreeCellStyle style) {
    if (hasChild) return null;
    if (selectOrPlaying) {
      return style.activeBackgroundColor.withOpacity(anim);
    }
    if (display.hovered) {
      return style.hoverBackgroundColor;
    }
    return null;
  }

  bool get selectOrPlaying => (display.selected || display.playing);

  bool get hasChild => menuNode.children.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    MenuTreeCellStyle effectStyle =
        style ?? (display.isDark ? MenuTreeCellStyle.dark() : MenuTreeCellStyle.light());

    Color? bgColor = backgroundColor(effectStyle);
    Color? fgColor = effectForegroundColor(effectStyle);
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 2);
    MenuMeta menu = menuNode.data;
    IconData? icon;
    if(menu is IconMenu){
      icon = menu.icon;
    }
    Widget cell = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: bgColor,
      ),

      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 12.0 + (12 * menuNode.depth), vertical: 12),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(icon, size: 20, color: fgColor),
                    ),
                  _buildTitle(fgColor)
                ],
              ),
            ),
          ),
          if (ext?.tag != null) _buildTag(ext),
          if (menuNode.children.isNotEmpty) _buildExpandIndicator(display.expanded, fgColor)
        ],
      ),
    );
    if (selectOrPlaying && effectStyle.showIndicator && !hasChild) {
      cell = Stack(
        alignment: Alignment.centerLeft,
        children: [
          cell,
          LineIndicator(progress: anim, color: fgColor),
        ],
      );
    }
    return Padding(padding: padding, child: cell);
  }

  PlckiMenuMetaExt? get ext {
    if (menuNode.data.ext is PlckiMenuMetaExt) {
      return (menuNode.data.ext) as PlckiMenuMetaExt;
    }
    return null;
  }

  Widget _buildTitle(Color? fgColor) {
    TextStyle subStyle = const TextStyle(fontSize: 12, color: Colors.grey);
    TextStyle titleStyle = TextStyle(color: fgColor);
    Widget child =
        Text(menuNode.data.label, overflow: TextOverflow.ellipsis, maxLines: 1, style: titleStyle);
    if (ext?.subtitle != null) {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [child, Text(ext!.subtitle!, style: subStyle)],
      );
    }
    return child;
  }

  Widget _buildTag(PlckiMenuMetaExt? ext) {
    TextStyle tagStyle = const TextStyle(color: Colors.white, height: 1, fontSize: 12);
    Widget child =
        Text('${ext?.tag}', overflow: TextOverflow.ellipsis, maxLines: 1, style: tagStyle);
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.8), borderRadius: BorderRadius.circular(4)),
          child: child),
    );
  }

  Widget _buildExpandIndicator(bool expanded, Color? color) {
    return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Transform.rotate(
            angle: display.rate * pi,
            child: Icon(CupertinoIcons.chevron_down, size: 16, color: color)));
  }
}
