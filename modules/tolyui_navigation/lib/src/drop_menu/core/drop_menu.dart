// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-20
// Contact Me:  1981462002@qq.com

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';
import '../../model/model.dart';
import '../menu_view/action_menu_item.dart';
import '../menu_view/menu_item_display.dart';
import '../menu_view/sub_menu.dart';
import '../style/drop_menu_style.dart';

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

  final DropMenuCellStyle? style;
  final MenuMetaBuilder? leadingBuilder;
  final MenuMetaBuilder? tailBuilder;

  final ValueChanged<MenuMeta>? onSelect;
  final HoverConfig hoverConfig;
  final Placement placement;
  final DecorationConfig? decorationConfig;
  final OffsetCalculator? offsetCalculator;

  const TolyDropMenu({
    super.key,
    required this.menuItems,
    this.width,
    this.child,
    this.leadingBuilder,
    this.tailBuilder,
    this.style,
    this.subMenuGap = 0,
    this.placement = Placement.bottom,
    this.decorationConfig,
    this.offsetCalculator,
    this.childBuilder,
    this.onSelect,
    this.hoverConfig = const HoverConfig(),
  });

  @override
  State<TolyDropMenu> createState() => _TolyDropMenuState();
}

class _TolyDropMenuState extends State<TolyDropMenu> {
  Timer? exitTimer;

  void _startExitTimer(PopoverController controller) {
    _closeTimer();
    exitTimer = Timer(const Duration(milliseconds: 200), () {
      controller.close();
    });
  }

  void _closeTimer() {
    exitTimer?.cancel();
    exitTimer = null;
  }

  @override
  void dispose() {
    _closeTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TolyPopover(
      placement: widget.placement,
      maxWidth: widget.width,
      offsetCalculator: widget.offsetCalculator,
      decorationConfig: widget.decorationConfig,
      overlayBuilder: _overlayBuilder,
      builder: _displayBuilder,
      child: widget.child,
    );
  }

  Widget _displayBuilder(
      BuildContext context, PopoverController ctrl, Widget? child) {
    Widget content = widget.childBuilder?.call(context, ctrl, child) ??
        widget.child ??
        const SizedBox();
    if (widget.hoverConfig.enterPop) {
      return MouseRegion(
        onEnter: (_) => ctrl.open(),
        onExit: (_) => _startExitTimer(ctrl),
        child: content,
      );
    }
    return content;
  }

  Widget _overlayBuilder(BuildContext context, PopoverController ctrl) {
    Widget panel = MenuListPanel(
      tailBuilder: widget.tailBuilder,
      leadingBuilder: widget.leadingBuilder,
      style: widget.style,
      subMenuGap: widget.subMenuGap,
      decorationConfig: widget.decorationConfig,
      onSelect: (menu) {
        widget.onSelect?.call(menu);
        ctrl.close();
      },
      menus: widget.menuItems,
    );
    if (widget.hoverConfig.enterPop) {
      panel = MouseRegion(
        onEnter: (_) => _closeTimer(),
        onExit: (_) {
          if (widget.hoverConfig.exitClose) {
            ctrl.close();
          }
        },
        child: panel,
      );
    }
    return panel;
  }
}

class MenuListPanel extends StatelessWidget {
  final List<MenuDisplay> menus;
  final ValueChanged<MenuMeta>? onSelect;
  final double subMenuGap;
  final DropMenuCellStyle? style;
  final DecorationConfig? decorationConfig;
  final MenuMetaBuilder? leadingBuilder;
  final MenuMetaBuilder? tailBuilder;

  const MenuListPanel({
    super.key,
    required this.menus,
    required this.decorationConfig,
    required this.leadingBuilder,
    required this.tailBuilder,
    this.onSelect,
    this.style,
    required this.subMenuGap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
          leadingBuilder: leadingBuilder,
          tailBuilder: tailBuilder,
          display: menu,
          onSelect: onSelect,
          style: style,
        ),
      DividerMenu() => DividerMenuItem(
          display: menu,
        ),
      SubMenu() => SubMenuItem(
          style: style,
        leadingBuilder: leadingBuilder,
        tailBuilder: tailBuilder,
          menu: menu,
          subMenuGap: subMenuGap,
          onSelect: onSelect,
          decorationConfig: decorationConfig,
        ),
    };
  }
}
