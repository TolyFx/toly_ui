// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-09
// Contact Me:  1981462002@qq.com

class DisplayNode {
  final String title;
  final String desc;

  static final RegExp _titleRegex = RegExp(r"""title.*('|")(?<title>.*)('|")""");
  static final RegExp _descRegex = RegExp(r"""desc.*('|")(?<desc>.*)('|")""");

  const DisplayNode({
    required this.title,
    required this.desc,
  });

  factory DisplayNode.fromString(String text) {
    return DisplayNode(
      title: _titleRegex.firstMatch(text)?.namedGroup('title') ?? '',
      desc: _descRegex.firstMatch(text)?.namedGroup('desc') ?? '',
    );
  }

  @override
  String toString() {
    return 'DisplayNode{title: $title, desc: $desc}';
  }
}
