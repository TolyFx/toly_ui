// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-12
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';

import '../../model/display_meta.dart';
import '../../model/menu_meta.dart';

class MenuCellStyle {
  final bool showIndicator;
  final bool hideActiveText;
  final Color activeColor;
  final Color? activeBackgroundColor;
  final Color inActiveColor;
  final Color foregroundColor;
  final Color? hoverColor;
  final double iconSize;
  final double height;
  final double heightLarge;

  const MenuCellStyle({
    this.showIndicator = true,
    this.hideActiveText = true,
    this.activeColor = const Color(0xff02589F),
    this.inActiveColor = Colors.transparent,
    this.foregroundColor = const Color(0xff61666d),
    this.activeBackgroundColor,
    this.hoverColor,
    this.iconSize = 24,
    this.height = 60,
    this.heightLarge = 46,
  });

}

class TolyUiMenuCell extends StatelessWidget {
  final MenuMeta menu;
  final DisplayMeta display;
  final MenuCellStyle style;

  const TolyUiMenuCell({
    super.key,
    required this.menu,
    required this.display,
    required this.style ,
  });

  Color get hoverC => style.hoverColor ?? style.foregroundColor.withOpacity(0.1);

  ColorTween get backgroundTween =>
      ColorTween(begin: inActiveBackgroundColor, end: activeBackgroundColor);

  Color? get activeBackgroundColor {
    return display.isDark
        ? style.activeColor.withOpacity(0.3)
        : style.activeColor.withOpacity(0.1);
  }

  Color? get inActiveBackgroundColor {
    if (display.hovered) {
      return style.foregroundColor.withOpacity(0.1);
    }
    return style.inActiveColor;
  }

  Color? get effectForegroundColor {
    if (display.selected) {
      return display.isDark ? Colors.white : style.activeColor;
    }
    return style.foregroundColor;
  }

  bool get selectOrPlaying => display.selected || display.playing;

  double get anim => display.anima ?? 1;

  Color? get backgroundColor {
    if (selectOrPlaying) {
      return backgroundTween.transform(anim);
    }
    if (display.hovered) {
      return const Color(0xff868686).withOpacity(0.1);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    bool largeWidth = display.widthType == MenuWidthType.large;

    bool showLabel =
        !display.selected || display.playing || largeWidth || !style.hideActiveText;
    Widget cell = VerticalMenuCell(
      backgroundColor: backgroundColor,
      icon: Icon(
        menu.icon,
        color: effectForegroundColor,
        size: style.iconSize,
      ),
      height: largeWidth ? style.heightLarge : style.height,
      showLabel: showLabel,
      direction: largeWidth ? Axis.horizontal : Axis.vertical,
      label: Text(
        menu.label,
        style: TextStyle(
            color: effectForegroundColor,
            fontSize: largeWidth ? 14 : 12 * (style.hideActiveText ? (1 - anim) : 1)),
      ),
    );
    if (selectOrPlaying && style.showIndicator) {
      cell = Stack(
        alignment: Alignment.centerLeft,
        children: [
          cell,
          LineIndicator(progress: anim, color: effectForegroundColor),
        ],
      );
    }
    return cell;
  }
}

class LineIndicator extends StatelessWidget {
  final double width;
  final double height;
  final double progress;
  final Color? color;

  const LineIndicator({
    super.key,
    this.width = 4,
    required this.progress,
    required this.color,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width + (height - 4) * progress,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          width / 2,
        ),
      ),
    );
  }
}

class VerticalMenuCell extends StatelessWidget {
  final Color? backgroundColor;
  final Widget icon;
  final Widget label;
  final double height;
  final bool showLabel;
  final Axis direction;

  const VerticalMenuCell({
    super.key,
    required this.backgroundColor,
    required this.icon,
    required this.label,
    this.showLabel = true,
    this.direction = Axis.vertical,
    this.height = 54,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment:
          direction == Axis.vertical ? Alignment.center : Alignment.centerLeft,
      padding: direction == Axis.vertical
          ? null
          : const EdgeInsets.symmetric(horizontal: 12),
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Wrap(
        direction: direction,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: direction == Axis.vertical ? 4 : 12,
        children: [
          icon,
          if (showLabel) label,
        ],
      ),
    );
  }
}
