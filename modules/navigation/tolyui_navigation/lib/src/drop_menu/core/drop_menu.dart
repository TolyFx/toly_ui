// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-20
// Contact Me:  1981462002@qq.com

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';
import 'package:tolyui_meta/tolyui_meta.dart';
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
  final PopoverController? controller;
  final Object? overlayTapRegion;
  final ValueChanged<bool>? onSubMenuEnter;

  final double? width;
  final double? minOverlayWidth;
  final bool shrinkWrapWidthOverlay;
  final double subMenuGap;
  final Widget? child;
  final double? maxHeight;
  final double? subMaxHeight;

  final DropMenuCellStyle? style;
  final MenuMetaBuilder? leadingBuilder;
  final MenuMetaBuilder? tailBuilder;
  final MenuMetaBuilder? contentBuilder;

  final ValueChanged<MenuMeta>? onSelect;
  final HoverConfig hoverConfig;
  final Placement placement;
  final DecorationConfig? decorationConfig;
  final OffsetCalculator? offsetCalculator;

  final VoidCallback? onClose;
  final ValueChanged<String>? onCloseSubMeu;

  const TolyDropMenu({
    super.key,
    this.onClose,
    this.onCloseSubMeu,
    required this.menuItems,
    this.width,
    this.onSubMenuEnter,
    this.maxHeight,
    this.subMaxHeight,
    this.child,
    this.shrinkWrapWidthOverlay = true,
    this.overlayTapRegion,
    this.leadingBuilder,
    this.contentBuilder,
    this.tailBuilder,
    this.style,
    this.subMenuGap = 0,
    this.minOverlayWidth,
    this.controller,
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
      maxHeight: widget.maxHeight,
      controller: widget.controller,
      offsetCalculator: widget.offsetCalculator,
      decorationConfig: widget.decorationConfig,
      overlayBuilder: (ctx, ctrl) => _overlayBuilder(context, ctx, ctrl),
      builder: _displayBuilder,
      child: widget.child,
      onClose: widget.onClose,
    );
  }

  Widget _displayBuilder(
      BuildContext context, PopoverController ctrl, Widget? child) {
    Widget content = widget.childBuilder?.call(context, ctrl, child) ??
        widget.child ??
        const SizedBox();
    if (widget.hoverConfig.enterPop) {
      return MouseRegion(
        onEnter: (_) {
          ctrl.open();
        },
        onExit: (_) => _startExitTimer(ctrl),
        child: content,
      );
    }
    return content;
  }

  Widget _overlayBuilder(
      BuildContext target, BuildContext context, PopoverController ctrl) {
    Size size = (target.findRenderObject() as RenderBox).size;
    bool overSize = size.width < (widget.minOverlayWidth ?? 0);
    Widget panel = MenuListPanel(
      onCloseSubMeu: widget.onCloseSubMeu,
      maxHeight: widget.subMaxHeight,
      scrollable: widget.maxHeight != null,
      boxSize: size,
      onSubMenuEnter: (bool value) {
        enterSub = value;
      },
      shrinkWrapWidthOverlay: widget.shrinkWrapWidthOverlay || overSize,
      tailBuilder: widget.tailBuilder,
      leadingBuilder: widget.leadingBuilder,
      contentBuilder: widget.contentBuilder,
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
        onEnter: (_) {
          widget.onSubMenuEnter?.call(true);
          _closeTimer();
        },
        onExit: (_) async {
          widget.onSubMenuEnter?.call(false);
          if (widget.hoverConfig.exitClose) {
            await Future.delayed(Duration(milliseconds: 200));
            if (!enterSub) {
              ctrl.close();
            }
          }
        },
        child: panel,
      );
    }
    if (widget.overlayTapRegion != null) {
      panel = TapRegion(
        groupId: widget.overlayTapRegion!,
        child: panel,
      );
    }
    return panel;
  }

  bool enterSub = false;
}

class MenuListPanel extends StatelessWidget {
  final List<MenuDisplay> menus;
  final ValueChanged<MenuMeta>? onSelect;
  final double subMenuGap;
  final DropMenuCellStyle? style;
  final Size boxSize;
  final DecorationConfig? decorationConfig;
  final MenuMetaBuilder? leadingBuilder;
  final MenuMetaBuilder? tailBuilder;
  final MenuMetaBuilder? contentBuilder;
  final bool shrinkWrapWidthOverlay;
  final bool scrollable;
  final double? maxHeight;
  final ValueChanged<bool>? onSubMenuEnter;
  final ValueChanged<String>? onCloseSubMeu;

  const MenuListPanel({
    super.key,
    required this.menus,
    required this.scrollable,
    required this.maxHeight,
    required this.decorationConfig,
    required this.leadingBuilder,
    required this.tailBuilder,
    required this.contentBuilder,
    required this.shrinkWrapWidthOverlay,
    required this.boxSize,
    required this.onCloseSubMeu,
    this.onSelect,
    this.onSubMenuEnter,
    this.style,
    required this.subMenuGap,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Column(
      mainAxisSize: MainAxisSize.min,
      children: menus.map(_mapItem).toList(),
    );
    if (scrollable) {
      child = SingleChildScrollView(clipBehavior: Clip.hardEdge, child: child);
    }

    if (shrinkWrapWidthOverlay) {
      child = Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: IntrinsicWidth(
            child: child,
          ));
    } else {
      child = Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        width: boxSize.width,
        child: child,
      );
    }

    return child;
  }

  Widget _mapItem(MenuDisplay menu) {
    return switch (menu) {
      ActionMenu() => ActionMenuItem(
          leadingBuilder: leadingBuilder,
          tailBuilder: tailBuilder,
          contentBuilder: contentBuilder,
          display: menu,
          onSelect: onSelect,
          style: style,
        ),
      DividerMenu() => DividerMenuItem(
          display: menu,
        ),
      SubMenu() => SubMenuItem(
          style: style,
          onCloseSubMeu: onCloseSubMeu,
          maxHeight: maxHeight,
          leadingBuilder: leadingBuilder,
          contentBuilder: contentBuilder,
          tailBuilder: tailBuilder,
          onSubMenuEnter: onSubMenuEnter,
          menu: menu,
          subMenuGap: subMenuGap,
          onSelect: onSelect,
          decorationConfig: decorationConfig,
        ),
    };
  }
}
