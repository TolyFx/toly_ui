// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-09
// Contact Me:  1981462002@qq.com
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'display_meta.dart';

class DisplayFileParser {
  final String path;

  static final RegExp _codeRegex = RegExp(r'class (?<name>\w+)(.|\s)*');
  static final RegExp _displayRegex = RegExp(r'@DisplayNode(.|\s)*?\)');

  DisplayFileParser(this.path);

  StreamSubscription<List<int>>? subscription;

  Future<NodeMeta?> parser() async {
    if (!path.contains('_demo')) return null;
    File file = File(path);
    String content = await file.readAsString();
    bool hasDisplay = content.contains('@DisplayNode(');
    if (!hasDisplay) return null;
    return _parserContent(path, content);
  }

  NodeMeta _parserContent(String filePath, String content) {
    RegExpMatch? codeMatch = _codeRegex.firstMatch(content);
    String? code = codeMatch?.group(0);
    String? name = codeMatch?.namedGroup('name');
    String? display = _displayRegex.firstMatch(content)?.group(0);
    return NodeMeta(
      filePath: filePath,
      name: name ?? '',
      code: code ?? '',
      display: DisplayNode.fromString(display ?? ''),
    );
  }
}
