// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-09
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';
import 'package:toly_ui/components/node_display.dart';
import 'package:toly_ui/view/widgets/display_nodes/gen/widget_display_map.g.dart';

import '../display_nodes/gen/node.g.dart';

class SliverDisplayNodeList extends StatelessWidget {
  final String name;

  /// 可选的 GlobalKey 列表，用于右侧锚点导航追踪每个 section 的位置。
  /// 长度应与 displayNodes 数量一致，通过 package key 包在 NodeDisplay 外层。
  final List<GlobalKey>? itemKeys;

  const SliverDisplayNodeList({super.key, required this.name, this.itemKeys});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> displayNodes = queryDisplayNodes(name);
    List<String> keys = displayNodes.keys.toList();
    dynamic data = displayNodes.values.toList();
    return SliverList(
      key: PageStorageKey('sliver_list_$name'),
      delegate: SliverChildBuilderDelegate(
        (_, index) {
          Widget child = NodeDisplay(
            key: PageStorageKey('node_${name}_${keys[index]}'),
            display: widgetDisplayMap(keys[index]),
            node: Node.fromMap(data[index]),
          );
          // 通过 Column 包裹来挂载 GlobalKey，不影响 NodeDisplay 的 PageStorageKey
          if (itemKeys != null && index < itemKeys!.length) {
            child = Column(key: itemKeys![index], children: [child]);
          }
          return child;
        },
        childCount: displayNodes.length,
      ),
    );
  }
}
