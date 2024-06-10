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

  const SliverDisplayNodeList({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> displayNodes = queryDisplayNodes(name);
    List<String> keys = displayNodes.keys.toList();
    dynamic data = displayNodes.values.toList();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, index) => NodeDisplay(
          display: widgetDisplayMap(keys[index]),
          node: Node.fromMap(data[index]),
        ),
        childCount: displayNodes.length,
      ),
    );
  }
}
