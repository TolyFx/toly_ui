import 'package:flutter/material.dart';

import '../core/core.dart';

class MenuMeta implements Identify<String> {
  final String route;
  final String label;
  final bool enable;
  final bool closeable;
  final Extra? ext;

  const MenuMeta({
    required this.route,
    required this.label,
    this.ext,
    this.enable = true,
    this.closeable = true,
  });

  @override
  String toString() {
    return 'MenuMeta{router: $route, label: $label}';
  }

  @override
  String get id => route;
}

class IconMenu extends MenuMeta {
  final IconData icon;

  const IconMenu(
    this.icon, {
    required super.route,
    required super.label,
    super.enable,
    super.closeable,
    super.ext,
  });
}

class ImageMenu extends MenuMeta {
  final String image;

  const ImageMenu(
    this.image, {
    required super.route,
    required super.label,
    super.enable,
    super.closeable,
    super.ext,
  });
}
