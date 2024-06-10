// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-09
// Contact Me:  1981462002@qq.com

import 'dart:io';

import 'package:path/path.dart' as path;

import '../display_nodes.dart';

class NodeMeta {
  final String code;
  final String name;
  final String filePath;
  final DisplayNode display;

  const NodeMeta({
    required this.filePath,
    required this.code,
    required this.name,
    required this.display,
  });

  String get assetsName => '${path.basenameWithoutExtension(filePath)}.txt';

  String get assetPath => 'assets/code_res/$assetsName';

  Map<String, dynamic> get valueMap => {
        'title': display.title,
        'desc': display.desc,
        'code': assetPath,
      };

  @override
  String toString() {
    return 'DisplayFile{content: $code, display: $display,filePath:$filePath}';
  }

  void saveCode() {
    File codeFile = File(path.join(Directory.current.path, 'assets', 'code_res', assetsName));
    codeFile.writeAsString(code);
  }
}
