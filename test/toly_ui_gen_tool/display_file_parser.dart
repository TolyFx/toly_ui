// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-09
// Contact Me:  1981462002@qq.com
import 'dart:io';

import 'display_meta.dart';

/// 解析单个 Dart 源文件，提取 @DisplayNode 注解和类定义
class DisplayFileParser {
  final String filePath;

  static final RegExp _codeRegex = RegExp(
    r'class\s+(?<name>\w+)',
    multiLine: true,
  );

  static final RegExp _classBodyRegex = RegExp(
    r'class\s+(?<name>\w+)(.|\s)*',
    multiLine: true,
  );

  static final RegExp _displayRegex = RegExp(
    r'@DisplayNode\((.|\s)*?\)\s*',
    multiLine: true,
  );

  DisplayFileParser(this.filePath);

  Future<NodeMeta?> parse() async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;

      // 跳过非 _demo 文件
      final fileName = file.uri.pathSegments.last;
      if (!fileName.contains('_demo')) return null;

      final content = await file.readAsString();
      if (!content.contains('@DisplayNode(')) return null;

      return _parseContent(content);
    } catch (e) {
      print('⚠ 解析文件失败 $filePath: $e');
      return null;
    }
  }

  NodeMeta _parseContent(String content) {
    final codeMatch = _classBodyRegex.firstMatch(content);
    final code = codeMatch?.group(0) ?? '';
    final name = _codeRegex.firstMatch(content)?.namedGroup('name') ?? '';

    String displayRaw = '';
    final displayMatch = _displayRegex.firstMatch(content);
    if (displayMatch != null) {
      displayRaw = displayMatch.group(0)!;
      // 去掉 regext 匹配到的尾部空白和 @DisplayNode 头部
      displayRaw = displayRaw
          .replaceFirst(RegExp(r'^@DisplayNode\(\s*'), '')
          .replaceFirst(RegExp(r'\s*\)\s*$'), '')
          .trim();
    }

    return NodeMeta(
      filePath: filePath,
      name: name,
      code: code,
      display: DisplayNode.fromString(displayRaw),
    );
  }
}
