// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-09
// Contact Me:  1981462002@qq.com

import 'dart:io';

import 'package:path/path.dart' as path;

import '../display_nodes.dart';

sealed class ParserType {
  final String filePath;

  const ParserType({required this.filePath});
}

class SkipParser extends ParserType {
  const SkipParser({required super.filePath});
}

class NodeMeta extends ParserType {
  final String code;
  final String name;
  final DisplayNode display;

  const NodeMeta({
    required super.filePath,
    required this.code,
    required this.name,
    required this.display,
  });

  // factory DisplayMeta.fromMap(dynamic map){
  //   return DisplayMeta(filePath: map['code'], code: '', name: name, display: display);
  // }

  String get assetPath => 'assets/code_res/${path.basenameWithoutExtension(filePath)}.txt';

  Map<String, dynamic> toJson() => {
        name: {
          'title': display.title,
          'desc': display.desc,
          'code': assetPath,
        }
      };

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
    File codeFile =
        File(path.join(Directory.current.path, 'assets', 'code_res', path.basename(assetPath)));
    codeFile.writeAsString(code);
  }
}
