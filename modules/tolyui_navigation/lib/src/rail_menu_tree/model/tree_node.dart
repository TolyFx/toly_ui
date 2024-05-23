// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-15
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';

import '../../model/model.dart';

typedef MenuMateExtParser = MenuMateExt Function(Map<String, dynamic> data);

class MenuNode implements Identify<String> {
  final List<MenuNode> children;
  final int depth;
  final MenuMeta data;

  bool get isLeaf => children.isEmpty;

  const MenuNode({
    this.children = const [],
    required this.data,
    this.depth = 0,
  });

  @override
  String get id => data.id;

  factory MenuNode.fromMap(
    Map<String, dynamic> data, {
    int deep = -1,
    String prefix = '',
    MenuMateExtParser? extParser,
  }) {
    String path = data['path'] ?? '';
    String label = data['label'] ?? '';
    IconData? icon = data['icon'];
    List<Map<String, dynamic>>? childrenMap = data['children'];
    List<MenuNode> children = [];

    if (childrenMap != null && childrenMap.isNotEmpty) {
      for (int i = 0; i < childrenMap.length; i++) {
        MenuNode cNode = MenuNode.fromMap(childrenMap[i],
            deep: deep + 1, prefix: prefix + path, extParser: extParser);
        children.add(cNode);
      }
    }

    MenuMateExt? ext;

    if (extParser != null) {
      ext = extParser(data);
    }

    return MenuNode(
      depth: deep,
      data: MenuMeta(router: prefix + path, label: label, icon: icon, ext: ext),
      children: children,
    );
  }

  MenuNode? find(String id) {
    return queryMenuNodeByPath(this, id);
  }

  MenuNode? queryMenuNodeByPath(MenuNode node, String id) {
    if (node.id == id) {
      return node;
    }
    if (node.children.isNotEmpty) {
      for (int i = 0; i < node.children.length; i++) {
        MenuNode? result = queryMenuNodeByPath(node.children[i], id);
        if (result != null) {
          return result;
        }
      }
    }
    return null;
  }
}
