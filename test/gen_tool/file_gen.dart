// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-09
// Contact Me:  1981462002@qq.com

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:toly_ui/view/widgets/display_nodes/display_meta/display_meta.dart';

class FileGen {
  final Map<String, List<NodeMeta>> displayMap;

  FileGen(this.displayMap);

  Future<void> genNode(String outPath) async {
    List<String> nodeParts = [];
    List<String> nodeContents = [];
    List<String> mapWidgetItem = [];
    File file = File(outPath);
    displayMap.forEach((k, v) {
      Map<String, dynamic> items = {};
      nodeParts.add("part '$k.g.dart';\n");
      nodeContents.add('    "$k" => _${k}Data,\n');
      for (NodeMeta meta in v) {
        items[meta.name] = meta.valueMap;
        mapWidgetItem.add('    "${meta.name}" => const ${meta.name}(),\n');
      }
      File nodeFile = File(path.join(file.parent.path, '$k.g.dart'));
      String nodeContent = singleNodeTemplate(json.encode(items), k);
      nodeFile.writeAsString(nodeContent);
    });
    File widgetMapFile = File(path.join(file.parent.path, 'widget_display_map.g.dart'));
    widgetMapFile.writeAsString(widgetMapTemplate(mapWidgetItem.join()));
    String content = nodeTemplate(nodeContents.join(), nodeParts.join());
    await file.writeAsString(content);
  }

  String nodeTemplate(String content, String part) {
    return """
/// ===================================================
/// Power By 张风捷特烈 --- Generated file. Do not edit.
/// github: https://github.com/toly1994328
/// ===================================================
$part
Map<String, dynamic>  queryDisplayNodes(String name){
  return switch(name){
$content    _ => {},
  };
}
    """;
  }

  String singleNodeTemplate(String content, String name) {
    content = content.replaceAll(r'$', r'\$');
    return """/// ===================================================
/// Power By 张风捷特烈 --- Generated file. Do not edit.
/// github: https://github.com/toly1994328
/// ===================================================

part of 'node.g.dart';

Map<String, dynamic> get _${name}Data => $content;""";
  }

  String widgetMapTemplate(String content) {
    content = content.replaceAll(r'$', r'\$');
    return """/// ===================================================
/// Power By 张风捷特烈 --- Generated file. Do not edit.
/// github: https://github.com/toly1994328
/// ===================================================

import 'package:flutter/material.dart';
import '../../widgets.dart';

Widget widgetDisplayMap(String key){
  return switch(key){
$content    _ => const SizedBox(),
  };
}
    """;
  }
}
