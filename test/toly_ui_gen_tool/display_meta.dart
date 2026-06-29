// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-09
// Contact Me:  1981462002@qq.com

import 'dart:io';

import 'package:path/path.dart' as path;

/// @DisplayNode 注解数据
class DisplayNode {
  final String title;
  final String desc;

  static final RegExp _titleRegex = RegExp(
    r"""title\s*:\s*(['"])(?<title>.*?)\1""",
    multiLine: true,
    dotAll: true,
  );

  static final RegExp _descRegex = RegExp(
    r"""desc\s*:\s*(['"])(?<desc>.*?)\1""",
    multiLine: true,
    dotAll: true,
  );

  const DisplayNode({required this.title, required this.desc});

  factory DisplayNode.fromString(String text) {
    final tMatch = _titleRegex.firstMatch(text);
    final dMatch = _descRegex.firstMatch(text);
    return DisplayNode(
      title: tMatch?.namedGroup('title') ?? '',
      desc: dMatch?.namedGroup('desc') ?? '',
    );
  }

  @override
  String toString() => 'DisplayNode{title: $title, desc: $desc}';
}

/// 组件元数据（源码 + 注解）
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

  String get _assetFileName => '${path.basenameWithoutExtension(filePath)}.txt';

  String assetPath(String codeResDir) =>
      '$codeResDir/$_assetFileName';

  Map<String, dynamic> toJson() => {
        name: {
          'title': display.title,
          'desc': display.desc,
          'code': assetPath('assets/code_res'),
        }
      };

  Map<String, dynamic> get valueMap => {
        'title': display.title,
        'desc': display.desc,
        'code': assetPath('assets/code_res'),
      };

  @override
  String toString() => 'NodeMeta{name: $name, title: ${display.title}, file: $filePath}';

  void saveCode({String codeResDir = 'assets/code_res'}) {
    final dir = Directory(path.join(Directory.current.path, codeResDir));
    if (!dir.existsSync()) dir.createSync(recursive: true);
    File(path.join(dir.path, _assetFileName)).writeAsStringSync(code);
  }
}
