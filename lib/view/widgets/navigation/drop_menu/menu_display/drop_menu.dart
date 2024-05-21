// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-20
// Contact Me:  1981462002@qq.com

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:toly_ui/view/widgets/navigation/drop_menu/menu_display/sub_menu.dart';
import 'package:tolyui/tolyui.dart';
import 'action_menu_item.dart';
import 'menu_item_display.dart';

typedef MenuBuilder = List<MenuDisplay> Function(PopoverController controller);

class HoverConfig {
  final bool enterPop;
  final bool exitClose;

  const HoverConfig({
    this.enterPop = false,
    this.exitClose = true,
  });
}

class TolyDropMenu extends StatefulWidget {
  final List<MenuDisplay> menuItems;
  final TolyPopoverChildBuilder? childBuilder;
  final double? width;
  final double subMenuGap;
  final Widget? child;

  final ValueChanged<MenuMeta>? onSelect;
  final HoverConfig hoverConfig;
  final Placement placement;
  final DecorationConfig? decorationConfig;
  final OffsetCalculator? offsetCalculator;

  // final PopoverController? controller;
  // final VoidCallback? onEnter;

  const TolyDropMenu({
    super.key,
    required this.menuItems,
    this.width,
    this.child,
    this.subMenuGap = 0,
    // this.onEnter,
    this.placement = Placement.bottom,
    this.decorationConfig,
    this.offsetCalculator,
    // this.controller,
    this.childBuilder,
    this.onSelect,
    this.hoverConfig = const HoverConfig(),
  });

  @override
  State<TolyDropMenu> createState() => _TolyDropMenuState();
}

class _TolyDropMenuState extends State<TolyDropMenu> {
  Timer? exitTimer;

  void startExitTimer(PopoverController controller) {
    closeTimer();
    exitTimer = Timer(const Duration(milliseconds: 200), () {
      controller.close();
    });
    // setState(() {});
  }

  void closeTimer() {
    exitTimer?.cancel();
    exitTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return TolyPopover(
      placement: widget.placement,
      maxWidth: widget.width,
      offsetCalculator: widget.offsetCalculator,
      decorationConfig: widget.decorationConfig,
      overlayBuilder: _overlayBuilder,
      builder: (ctx, ctrl, child) {
        Widget content = widget.childBuilder?.call(ctx, ctrl, child)
            ??widget.child?? const SizedBox();
        if (widget.hoverConfig.enterPop) {
          return MouseRegion(
            onEnter: (_) => ctrl.open(),
            onExit: (_) => startExitTimer(ctrl),
            child: content,
          );
        }
        return content;
      },
      child: widget.child ,
    );
  }

  Widget _overlayBuilder(BuildContext context, PopoverController ctrl) {
    Widget panel = MenuListPanel(
      subMenuGap: widget.subMenuGap,
      onSelect: (menu) {
        widget.onSelect?.call(menu);
        ctrl.close();
      },
      menus: widget.menuItems,
    );
    if (widget.hoverConfig.enterPop) {
      panel = MouseRegion(
        onEnter: (_) {
          // widget.onEnter?.call();
          closeTimer();
        },
        onExit: (_) {
          if (widget.hoverConfig.exitClose) {
            ctrl.close();
            // startExitTimer(ctrl);
          }
        },
        child: panel,
      );
    }
    return panel;
  }

// Widget _handle
}

class MenuListPanel extends StatelessWidget {
  final List<MenuDisplay> menus;
  final ValueChanged<MenuMeta>? onSelect;
  final double subMenuGap;

  const MenuListPanel({
    super.key,
    required this.menus,
    this.onSelect,
    required this.subMenuGap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: IntrinsicWidth(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: menus.map(_mapItem).toList(),
        ),
      ),
    );
  }

  Widget _mapItem(MenuDisplay menu) {
    return switch (menu) {
      ActionMenu() => ActionMenuItem(
          display: menu,
          onSelect: onSelect,
        ),
      DividerMenu() => DividerMenuItem(
          display: menu,
        ),
      SubMenu() => SubMenuItem(
          menu: menu,
          subMenuGap: subMenuGap,
          onSelect: onSelect,
        ),
    };
  }
}
