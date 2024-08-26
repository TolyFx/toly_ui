import 'dart:ui';

import 'package:flutter/material.dart';

import 'attributes.dart';

class TolyInputStyle {
  final Color? hoverColor;
  final DisplaySize inputSize;
  final Radius radius;
  final InputDecoration? decoration;

  TolyInputStyle({
    this.hoverColor,
    this.decoration = const InputDecoration(),
    this.radius = const Radius.circular(4),
    this.inputSize = const DefaultSize(),
  });

  bool get enableHoverBorder => hoverColor != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TolyInputStyle &&
          runtimeType == other.runtimeType &&
          hoverColor == other.hoverColor &&
          inputSize == other.inputSize;

  @override
  int get hashCode => hoverColor.hashCode ^ inputSize.hashCode;
}
