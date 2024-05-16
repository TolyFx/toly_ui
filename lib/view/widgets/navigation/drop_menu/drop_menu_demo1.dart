import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tolyui/tolyui.dart';

import '../../../debugger/debugger.dart';

class DropMenuDemo1 extends StatelessWidget{
  const DropMenuDemo1({super.key});


  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      children: [
        TolyPopover(
          placement: Placement.bottom,
          maxWidth: 200,
          overlayBuilder: (_, ctrl) => MenuListPanel(
            disableList: ['03'],
            menus: [
              MenuMeta(router: '01', label: '1st menu item'),
              MenuMeta(router: '02', label: '2nd menu item'),
              MenuMeta(router: '03', label: '3rd menu item'),
              MenuMeta(router: '04', label: '4ur menu item'),
            ],
            onSelect: (MenuMeta menu) {
              ctrl.close();
              $message.success(message: '点击了 [${menu.label}] 个菜单');
            },
          ),
          builder: (_, ctrl, __) {
            return DebugDisplayButton(
              info: 'DropMenu',
              onPressed: ctrl.open,
            );
          },
        ),
        TolyPopover(
          // overlayDecorationBuilder: decorationBuilder,
          placement: Placement.bottomStart,
          decorationConfig: DecorationConfig(isBubble: false),
          maxWidth: 200,
          offsetCalculator: (_) => Offset(0, -8),
          overlayBuilder: (_, ctrl) => MenuListPanel(
            disableList: ['03'],
            menus: [
              MenuMeta(router: '01', label: '1st menu item'),
              MenuMeta(router: '02', label: '2nd menu item'),
              MenuMeta(router: '03', label: '3rd menu item'),
              MenuMeta(router: '04', label: '4ur menu item'),
            ],
            onSelect: (MenuMeta menu) {
              ctrl.close();
              $message.success(message: '点击了 [${menu.label}] 个菜单');
            },
          ),
          builder: (_, ctrl, __) {
            return DebugDisplayButton(
                info: 'DropMenu', onPressed: ctrl.open);
          },
        ),
      ],
    );
  }
}

class MenuListPanel extends StatelessWidget {
  final ValueChanged<MenuMeta> onSelect;
  final List<MenuMeta> menus;
  final List<String> disableList;

  const MenuListPanel({
    super.key,
    required this.onSelect,
    required this.menus,
    this.disableList= const[],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        direction: Axis.vertical,
        children: menus.map(_mapItem).toList(),
      ),
    );
  }

  Widget _mapItem(MenuMeta menu) {
    bool disable = disableList.contains(menu.id);
    return ActionMenuItem(
      menu: menu,
      onTap: disable?null:() => onSelect(menu),
    );
    // ActionMenuItem(
    //     child: Text('1st menu item'), onTap: () => onSelect(0)),
    // ActionMenuItem(
    // child: Text('2nd menu item'), onTap: () => onSelect(1)),
    // ActionMenuItem(
    // child: Text('3rd menu item'), onTap: () => onSelect(2)),
    // ActionMenuItem(child: Text('4ur menu item'), onTap: null),
  }
}

class ActionMenuItem extends StatefulWidget {
  final MenuMeta menu;
  final VoidCallback? onTap;

  const ActionMenuItem({super.key, required this.onTap, required this.menu});

  @override
  State<ActionMenuItem> createState() => _ActionMenuItemState();
}

class _ActionMenuItemState extends State<ActionMenuItem> with HoverStateMix {
  @override
  Widget build(BuildContext context) {
    bool enable = widget.onTap != null;
    MouseCursor cursor =
    enable ? SystemMouseCursors.click : SystemMouseCursors.forbidden;
    Color backgroundColor = Colors.transparent;
    Color forgroundColor = Color(0xff1f1f1f);
    if (enable) {
      if (hovered) {
        backgroundColor = Color(0xfff5f5f5);
      }
    }else{
      forgroundColor = Color(0xffbfbfbf);
    }

    Widget child = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: backgroundColor,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(widget.menu.label,style: TextStyle(color: forgroundColor),),
    );

    if (enable) {
      child = GestureDetector(
        onTap: widget.onTap,
        child: child,
      );
    }

    return wrap(child, cursor: cursor);
  }
}

mixin HoverStateMix<T extends StatefulWidget> on State<T> {
  bool _hovered = false;

  bool get hovered => _hovered;

  Widget wrap(Widget child, {MouseCursor? cursor}) {
    return MouseRegion(
      cursor: cursor ?? SystemMouseCursors.click,
      onEnter: _onEnter,
      onExit: _onExit,
      child: child,
    );
  }

  void _onEnter(PointerEnterEvent event) {
    setState(() {
      _hovered = true;
    });
  }

  void _onExit(PointerExitEvent event) {
    setState(() {
      _hovered = false;
    });
  }
}