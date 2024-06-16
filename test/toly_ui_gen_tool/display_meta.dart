// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-09
// Contact Me:  1981462002@qq.com

import 'dart:io';

import 'package:path/path.dart' as path;

class DisplayNode {
  final String title;
  final String desc;


  static RegExp titleRegex = RegExp(r"""title(.|\n)*?('|")()(?<title>.*?)('|"),""",dotAll: true);
  static RegExp descRegex = RegExp(r"""desc(.|\n)*?('|")()(?<desc>.*?)('|"),""",dotAll: true);

  const DisplayNode({
    required this.title,
    required this.desc,
  });

  factory DisplayNode.fromString(String text) {
    return DisplayNode(
      title: titleRegex.firstMatch(text)?.namedGroup('title') ?? '',
      desc: descRegex.firstMatch(text)?.namedGroup('desc') ?? '',
    );
  }

  @override
  String toString() {
    return 'DisplayNode{title: $title, desc: $desc}';
  }
}


class NodeMeta {
  final String filePath;
  final String code;
  final String name;
  final DisplayNode display;

  const NodeMeta({
    required this.filePath,
    required this.code,
    required this.name,
    required this.display,
  });

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
    return 'NodeMeta{content: $code, display: $display,filePath:$filePath}';
  }

  void saveCode() {
    File codeFile =
        File(path.join(Directory.current.path, 'assets', 'code_res', path.basename(assetPath)));
    codeFile.writeAsString(code);
  }
}
