// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-10
// Contact Me:  1981462002@qq.com
import 'package:flutter/material.dart';
import 'package:toly_ui/app/logic/actions/navigation.dart';
import 'package:tolyui/tolyui.dart';

class IconPitchUse extends StatelessWidget {
  const IconPitchUse({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(
          '如何使用 Iconfont 的图标?',
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(
          height: 12,
        ),
        Text('使用 toly 命令行工具生成代码，便于在 Flutter 项目中使用 iconfont 图标。 '),
        SizedBox(
          height: 8,
        ),
        TolyLink(
          text: '文章介绍: Flutter 图标字体代码生成器',
          style: TextStyle(color: Colors.blue),
          href: 'https://juejin.cn/post/7323408577709293602',
          onTap: jumpUrl,
        ),
        TolyLink(
          text: '视频介绍: Flutter 图标字体代码生成器',
          style: TextStyle(color: Colors.blue),
          href: 'https://www.bilibili.com/video/BV1Pa4y127V6/',
          onTap: jumpUrl,
        ),
      ],
    );
  }
}
