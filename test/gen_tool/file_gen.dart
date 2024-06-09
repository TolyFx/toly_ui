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

  Future<void> genNode(String filePath) async {
    List<String> parts = [];
    List<String> displayItems = [];
    File file = File(filePath);
    displayMap.forEach((k, v) {
      Map<String, dynamic> items = {};
      parts.add("part '$k.g.dart';\n");
      displayItems.add('    "$k" => _${k}Data,\n');
      for (NodeMeta meta in v) {
        // item += '${json.encode(meta)},';
        items[meta.name] = meta.valueMap;
      }
      File nodeFile = File(path.join(file.parent.path, '$k.g.dart'));
      String nodeContent = nodeTemp(json.encode(items), k);
      nodeFile.writeAsString(nodeContent);
    });

    String content = temp(displayItems.join(), parts.join());
    await file.writeAsString(content);
  }

  String temp(String content, String part) {
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

  String nodeTemp(String content, String name) {
    return """/// ===================================================
/// Power By 张风捷特烈 --- Generated file. Do not edit.
/// github: https://github.com/toly1994328
/// ===================================================

part of 'node.g.dart';

Map<String, dynamic> get _${name}Data => $content;""";
  }
}
