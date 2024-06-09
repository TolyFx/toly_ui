// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-09
// Contact Me:  1981462002@qq.com

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:toly_ui/view/widgets/display_nodes/display_meta/display_meta.dart';

import 'display_file_parser.dart';
import 'file_gen.dart';

void main() async {
  String dataPath = path.join(
    Directory.current.path,
    'lib',
    'view',
    'widgets',
  );
  Directory dataDir = Directory(dataPath);
  Map<String, List<NodeMeta>> displayMap = {};
  await parserDir(dataDir, displayMap);

  String genPath =
      path.join(Directory.current.path, 'lib', 'view', 'widgets', 'display_nodes', 'gen');
  Directory genDir = Directory(genPath);
  if (!genDir.existsSync()) {
    await genDir.create();
  }
  String out = path.join(genPath, 'node.g.dart');
  FileGen(displayMap).genNode(out);
}

Future<void> parserDir(Directory dir, Map<String, List<NodeMeta>> displayMap) async {
  List<NodeMeta> displays = [];
  List<FileSystemEntity> entity = dir.listSync();
  for (FileSystemEntity e in entity) {
    if (e is File) {
      ParserType ret = await DisplayFileParser(e.path).parser();
      if (ret is NodeMeta) {
        displays.add(ret);
        ret.saveCode();
      }
    } else if (e is Directory) {
      await parserDir(e, displayMap);
    }
  }
  if (displays.isNotEmpty) {
    displayMap[path.basename(dir.path)] = displays;
  }
}
