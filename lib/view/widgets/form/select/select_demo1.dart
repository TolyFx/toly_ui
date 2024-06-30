// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-26
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '选择器基本使用',
  desc: '当选项过多时，使用下拉菜单展示并选择内容。data是菜单的数据项，selectIndex 是数据的激活索引，onSelected 回调点击菜单项的事件。下方左侧指定尺寸，右侧自适应内容宽度：',
)
class SelectDemo1 extends StatefulWidget {
  const SelectDemo1({super.key});

  @override
  State<SelectDemo1> createState() => _SelectDemo1State();
}

class _SelectDemo1State extends State<SelectDemo1> {
  int _activeIndex = 0;
  List<String> data = MainAxisAlignment.values.map((e) => e.name).toList();
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: [
        TolySelect(
          fontSize: 14,
          data: data,
          selectIndex: _activeIndex,
          iconSize: 16,
          height: 32,
          width: 140,
          padding: EdgeInsets.symmetric(horizontal: 8),
          onSelected: (int index) async {
            String type = data[index];
            $message.success(message: '已选择:$type!');
            setState(() {
              _activeIndex = index;
            });
          },
        ),
        TolySelect(
          fontSize: 14,
          data: data,
          selectIndex: _activeIndex,
          shrinkWidth: true,
          iconSize: 16,
          height: 32,
          padding: EdgeInsets.symmetric(horizontal: 8,vertical: 7),
          labelPadding: EdgeInsets.only(right: 8),
          onSelected: (int index) async {
            String type = data[index];
            $message.success(message: '已选择:$type!');
            setState(() {
              _activeIndex = index;
            });
          },
        ),
      ],
    );
  }
}


