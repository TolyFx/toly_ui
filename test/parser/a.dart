// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-16
// Contact Me:  1981462002@qq.com

String a = """@DisplayNode(
  title: "可从资源文件和网络加载图片2",
  desc:
      'Image.asset加载资源图片,指定路径;\nImage.network加载资源网络图片，指定链接。\nImage.file加载资源文件图片，指定路径。\nImage.memory加载内存图片，指定字节数组：',
)""";

void main() {
  RegExp descRegex = RegExp(r"""desc(.|\s)*?('|")()(?<desc>.*?)('|"),""", dotAll: true);
  RegExpMatch? match = descRegex.firstMatch(a);
  print(match?.namedGroup('desc'));
}
