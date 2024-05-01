import 'package:flutter/material.dart';

class MenuNode {
  final String label;
  final int deep;
  final String path;
  final IconData? icon;
  final List<MenuNode> children;

  bool get isLeaf => children.isEmpty;

  MenuNode({
    required this.path,
    required this.label,
    this.deep = 0,
    this.icon,
    this.children = const [],
  });

  factory MenuNode.fromMap(
    Map<String, dynamic> data, {
    int deep = -1,
    String prefix = '',
  }) {
    String path = data['path'] ?? '';
    String label = data['label'] ?? '';
    IconData? icon = data['icon'];
    List<Map<String, dynamic>>? childrenMap = data['children'];
    List<MenuNode> children = [];
    if (childrenMap != null && childrenMap.isNotEmpty) {
      for (int i = 0; i < childrenMap.length; i++) {
        MenuNode cNode = MenuNode.fromMap(
          childrenMap[i],
          deep: deep + 1,
          prefix: prefix + path,
        );
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
}
