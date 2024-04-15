import 'package:flutter/material.dart';

import '../model/menu_data.dart';

MenuNode parserMap(Map<String, dynamic> data, int deep, String prefix) {
  String path = data['path'];
  String label = data['label'];
  IconData? icon = data['icon'];
  List<Map<String, dynamic>>? childrenMap = data['children'];
  List<MenuNode> children = [];
  if (childrenMap != null && childrenMap.isNotEmpty) {
    for (int i = 0; i < childrenMap.length; i++) {
      MenuNode cNode = parserMap(childrenMap[i], deep + 1, prefix + path);
      children.add(cNode);
    }
  }

  return MenuNode(
    icon: icon,
    path: prefix + path,
    label: label,
    deep: deep,
    children: children,
  );
}