// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-09
// Contact Me:  1981462002@qq.com
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:toly_ui/view/widgets/display_nodes/display_meta/display_meta.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

class DisplayFileParser {
  final String path;

  final RegExp _codeRegex = RegExp(r'class(.|\s)*');
  final RegExp _nameRegex = RegExp(r'class (?<name>\w+)');
  final RegExp _displayRegex = RegExp(r'@DisplayNode(.|\s)*?\)');

  DisplayFileParser(this.path);

  StreamSubscription<List<int>>? subscription;

  Future<ParserType> parser() async {
    if (!path.contains('_demo')) return SkipParser(filePath: path);
    File file = File(path);
    Completer<ParserType> completer = Completer();
    Stream<List<int>> stream = file.openRead();
    String content = '';
    bool hasDisplay = false;
    subscription = stream.listen((List<int> data) {
      content += utf8.decode(data);
      hasDisplay = content.contains('@DisplayNode(');
      if (!hasDisplay && content.contains('class ')) {
        subscription?.cancel();
        completer.complete(SkipParser(filePath: path));
      }
    }, onDone: () {
      ParserType fileType = SkipParser(filePath: path);
      if (hasDisplay) {
        fileType = _parserContent(path, content);
      }
      completer.complete(fileType);
    });
    return completer.future;
  }

  NodeMeta _parserContent(String filePath, String content) {
    String? code = _codeRegex.firstMatch(content)?.group(0);
    String? display = _displayRegex.firstMatch(content)?.group(0);
    String? name = _nameRegex.firstMatch(content)?.namedGroup('name');
    return NodeMeta(
      filePath: filePath,
      name: name ?? '',
      code: code ?? '',
      display: DisplayNode.fromString(
        display ?? '',
      ),
    );
  }
}
