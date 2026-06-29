// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-09
// Contact Me:  1981462002@qq.com

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import 'display_meta.dart';

/// 生成 .g.dart 代码文件
class FileGen {
  final Map<String, List<NodeMeta>> displayMap;

  FileGen(this.displayMap);

  Future<void> genNode(String outPath) async {
    final file = File(outPath);
    final parentDir = file.parent;

    // 确保输出目录存在
    if (!parentDir.existsSync()) {
      parentDir.createSync(recursive: true);
    }

    final nodeParts = <String>[];
    final nodeContents = <String>[];
    final mapWidgetItems = <String>[];

    for (final entry in displayMap.entries) {
      final category = entry.key;
      final nodes = entry.value;

      nodeParts.add("part '$category.g.dart';\n");
      nodeContents.add('    "$category" => _${category}Data,\n');

      // 生成分类数据文件
      final items = <String, dynamic>{};
      for (final node in nodes) {
        items[node.name] = node.valueMap;
        mapWidgetItems.add('    "${node.name}" => const ${node.name}(),\n');
      }

      final nodeFile = File(path.join(parentDir.path, '$category.g.dart'));
      await nodeFile.writeAsString(_singleNodeTemplate(json.encode(items), category));
    }

    // 生成 Widget 映射文件
    final widgetMapFile = File(path.join(parentDir.path, 'widget_display_map.g.dart'));
    await widgetMapFile.writeAsString(_widgetMapTemplate(mapWidgetItems.join()));

    // 生成主入口文件
    await file.writeAsString(_nodeTemplate(nodeContents.join(), nodeParts.join()));
  }

  String _nodeTemplate(String content, String parts) {
    return '''/// ===================================================
/// Power By 张风捷特烈 --- Generated file. Do not edit.
/// github: https://github.com/toly1994328
/// ===================================================
$parts
Map<String, dynamic> queryDisplayNodes(String name) {
  return switch (name) {
$content    _ => {},
  };
}
''';
  }

  String _singleNodeTemplate(String content, String name) {
    content = content.replaceAll(r'$', r'\$');
    return '''/// ===================================================
/// Power By 张风捷特烈 --- Generated file. Do not edit.
/// github: https://github.com/toly1994328
/// ===================================================

part of 'node.g.dart';

Map<String, dynamic> get _${name}Data => $content;''';
  }

  String _widgetMapTemplate(String content) {
    content = content.replaceAll(r'$', r'\$');
    return '''/// ===================================================
/// Power By 张风捷特烈 --- Generated file. Do not edit.
/// github: https://github.com/toly1994328
/// ===================================================

import 'package:flutter/material.dart';
import '../../widgets.dart';

Widget widgetDisplayMap(String key) {
  return switch (key) {
$content    _ => const SizedBox(),
  };
}
''';
  }
}
