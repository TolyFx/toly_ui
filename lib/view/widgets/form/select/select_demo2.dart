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
  title: '菜单条目样式',
  desc: '可以通过 DropMenuCellStyle 类型的 cellStyle 属性，配置下拉条目的样式效果，和 DropMenu 一致：',
)
class SelectDemo2 extends StatefulWidget {
  const SelectDemo2({super.key});

  @override
  State<SelectDemo2> createState() => _SelectDemo2State();
}

const List<String> kWeekZH =  ['星期一','星期二','星期三','星期四','星期五','星期六','星期日'];
const List<String> kWeekEN =  ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

const Map<int,List<String> > kWeekMap = {
  0:kWeekZH,
  1:kWeekEN,
};

class _SelectDemo2State extends State<SelectDemo2> {
  int _activeLocal = 0;
  List<String> local = ['中文简体','English'];
  int _activeDay = 0;

  @override
  Widget build(BuildContext context) {
    List<String> days = kWeekMap[_activeLocal]!;

    DropMenuCellStyle lightStyle = const DropMenuCellStyle(
      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 1),
      borderRadius: BorderRadius.all(Radius.circular(6)),
      foregroundColor: Color(0xff1f1f1f),
      backgroundColor: Colors.transparent,
      disableColor: Color(0xffbfbfbf),
      hoverBackgroundColor: Color(0xfff5f5f5),
      hoverForegroundColor: Color(0xff1f1f1f),
      // textStyle: TextStyle(fontSize: 14)
    );

    return Wrap(
      spacing: 12,
      children: [
        TolySelect(
          fontSize: 14,
          cellStyle: lightStyle,
          data: local,
          selectIndex: _activeLocal,
          iconSize: 16,
          height: 32,
          width: 120,
          padding: EdgeInsets.symmetric(horizontal: 8),
          onSelected: (int index) async {
            String type = local[index];
            $message.success(message: '已选择:$type!');
            setState(() {
              _activeLocal = index;
            });
          },
        ),
        TolySelect(
          fontSize: 14,
          cellStyle: lightStyle,
          data: days,
          selectIndex: _activeDay,
          iconSize: 16,
          height: 32,
          width: 120,
          maxHeight: 160,
          padding: EdgeInsets.symmetric(horizontal: 8),
          onSelected: (int index) async {
            String type = days[index];
            $message.success(message: '已选择:$type!');
            setState(() {
              _activeDay = index;
            });
          },
        ),
      ],
    );
  }
}

