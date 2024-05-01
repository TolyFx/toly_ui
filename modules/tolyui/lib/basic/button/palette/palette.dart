import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dash_outline_shape_border.dart';

double _kDisableOpacity = 0.7;
class Palette {
  final Color hover;
  final Color normal;
  final Color pressed;

  const Palette({
    required this.hover,
    required this.normal,
    required this.pressed,
  });

  const Palette.all(Color color)
      : hover = color,
        normal = color,
        pressed = color;
}

abstract class ButtonPalette {
  final Palette backgroundPalette;
  final Palette foregroundPalette;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final bool disable;

  ButtonPalette({
    required this.backgroundPalette,
    required this.foregroundPalette,
    required this.borderRadius,
    required this.padding,
    this.disable = false,
  });

  ButtonStyle get style;
}

class FillButtonPalette extends ButtonPalette {
  final double elevation;

  FillButtonPalette({
    required super.backgroundPalette,
    super.borderRadius = const BorderRadius.all(Radius.circular(4)),
    super.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.elevation = 0,
    super.disable,
    required super.foregroundPalette,
  });

  @override
  ButtonStyle get style {

    Color? getColor(Set<MaterialState> states) {
      Color color= backgroundPalette.normal;
      if (states.contains(MaterialState.pressed)) {
        color = backgroundPalette.pressed;
      } else {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.hovered,
          MaterialState.focused,
        };
        if (states.any(interactiveStates.contains)) {
          color = backgroundPalette.hover;
        }
      }
      color = disable ? color.withOpacity(_kDisableOpacity) : color;
      return color;
    }

    Color? getForegroundColorColor(Set<MaterialState> states) {
      Color color= foregroundPalette.normal;
      if (states.contains(MaterialState.pressed)) {
        color = foregroundPalette.pressed;
      } else {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.hovered,
          MaterialState.focused,
        };
        if (states.any(interactiveStates.contains)) {
          color = foregroundPalette.hover;
        }
      }
      color = disable ? color.withOpacity(_kDisableOpacity) : color;
      return color;
    }

    Color? getBackgroundColor(Set<MaterialState> states) {
      Color color = backgroundPalette.normal;
      color = disable ? color.withOpacity(_kDisableOpacity) : color;
      return color;
    }


    return ButtonStyle(
      elevation: MaterialStatePropertyAll(elevation),
      overlayColor: MaterialStateProperty.resolveWith(getColor),
      foregroundColor: MaterialStateProperty.resolveWith(getForegroundColorColor),
      backgroundColor: MaterialStateProperty.resolveWith(getBackgroundColor),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: borderRadius)),
      padding: MaterialStateProperty.all(padding),
    );
  }
}


class OutlineButtonPalette extends ButtonPalette {
  final Palette borderPalette;
  final double borderWidth;
  final double dashGap;

  OutlineButtonPalette({
    required super.backgroundPalette,
    super.disable,
    super.borderRadius = const BorderRadius.all(Radius.circular(4)),
    super.padding = const EdgeInsets.symmetric(horizontal: 16),
    required this.borderPalette,
    this.borderWidth = 1,
    this.dashGap = 0,
    required super.foregroundPalette,
  });

  @override
  ButtonStyle get style {
    Color? getColor(Set<MaterialState> states) {
      if(disable){
        return backgroundPalette.normal.withOpacity(_kDisableOpacity);
      }
      Color color= backgroundPalette.normal;
      if (states.contains(MaterialState.pressed)) {
        color = backgroundPalette.pressed;
      } else {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.hovered,
          MaterialState.focused,
        };
        if (states.any(interactiveStates.contains)) {
          color = backgroundPalette.hover;
        }
      }
      if(disable){
        color = color.withOpacity(_kDisableOpacity);
      }
      return color;
    }

    Color? getForegroundColor(Set<MaterialState> states) {

      Color color = foregroundPalette.normal;
      if (states.contains(MaterialState.pressed)) {
        color = foregroundPalette.pressed;
      } else {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.hovered,
          MaterialState.focused,
        };
        if (states.any(interactiveStates.contains)) {
          color = foregroundPalette.hover;
        }
      }
      if(disable){
        color = color.withOpacity(_kDisableOpacity);
      }
      return color;

    }

    OutlinedBorder? getOutlineColor(Set<MaterialState> states) {

      Color color = borderPalette.normal;

      if (states.contains(MaterialState.pressed)) {
        color = borderPalette.pressed;
      } else {
        const Set<MaterialState> interactiveStates = <MaterialState>{
          MaterialState.hovered,
          MaterialState.focused,
        };
        if (states.any(interactiveStates.contains)) {
          color = borderPalette.hover;
        }
      }
      if(disable){
        color = color.withOpacity(_kDisableOpacity);
      }

      if (dashGap == 0) {
        return RoundedRectangleBorder(
            borderRadius: borderRadius,
            side: BorderSide(width: borderWidth, color: color));
      }

      return DashOutlineShapeBorder(
          dashGap: dashGap,
          borderRadius: borderRadius,
          side: BorderSide(width: borderWidth, color: color));
    }

    return ButtonStyle(
      elevation: const MaterialStatePropertyAll(0),
      overlayColor: MaterialStateProperty.resolveWith(getColor),
      // side: MaterialStateProperty.resolveWith((getSide)),
      foregroundColor: MaterialStateProperty.resolveWith(getForegroundColor),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      shape: MaterialStateProperty.resolveWith(getOutlineColor),
      padding: MaterialStateProperty.all(padding),
    );
  }
}


