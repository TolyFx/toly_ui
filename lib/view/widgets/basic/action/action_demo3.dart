// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-16
// Contact Me:  1981462002@qq.com

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: 'Action 选择状态',
  desc: '将 selected 置为 true 即可使 Action 处于选中状态。通过 ActionStyle#selectColor 可以设置选择中色：',
)
class ActionDemo3 extends StatefulWidget {
  const ActionDemo3({super.key});

  @override
  State<ActionDemo3> createState() => _ActionDemo3State();
}

class _ActionDemo3State extends State<ActionDemo3> {
  PaintAction _currentAction = PaintAction.move;

  @override
  Widget build(BuildContext context) {
    ActionStyle style = ActionStyle(
      borderRadius: BorderRadius.circular(4),
      padding: const EdgeInsets.all(4),
      backgroundColor: Colors.blue.withOpacity(0.1),
      border: Border.all(color: context.isDark ? Colors.blueAccent : Colors.blue),
      selectColor: Colors.blue.withOpacity(0.2),
    );

    return Wrap(
        spacing: 6,
        children: PaintAction.values.map((e) {
          return TolyAction(
            tooltip: e.tooltip,
            style: style,
            selected: _currentAction == e,
            onTap: () => onTapAction(e),
            child: Icon(e.icon, size: 20),
          );
        }).toList());
  }

  void onTapAction(PaintAction action) {
    $message.success(message: '${action.tooltip}动作已选中!');
    setState(() {
      _currentAction = action;
    });
  }
}

enum PaintAction {
  move('移动', CupertinoIcons.move),
  pen('画笔', CupertinoIcons.pencil_outline),
  brush('笔刷', CupertinoIcons.paintbrush),
  clip('魔棒', CupertinoIcons.wand_rays),
  lock('锁定', CupertinoIcons.lock),
  ;

  final String tooltip;
  final IconData icon;
  const PaintAction(this.tooltip, this.icon);
}
