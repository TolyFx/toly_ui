// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-16
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';
import 'package:toly_ui/navigation/router/app_router.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: 'Action 自定义样式',
  desc: '可以通过 ActionStyle 定制间距、背景色、边线、圆角半径属性：',
)
class ActionDemo2 extends StatelessWidget {
  const ActionDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    ActionStyle style = ActionStyle(
      borderRadius: BorderRadius.circular(4),
      padding: const EdgeInsets.all(4),
      backgroundColor: Colors.blue.withOpacity(0.2),
      border: Border.all(color: Colors.blue),
    );

    return Wrap(
      spacing: 6,
      children: [
        TolyAction(
          tooltip: '设置',
          style: style,
          onTap: () => $message.success(message: '打开设置行为触发!'),
          child: Icon(
            Icons.settings,
            size: 20,
          ),
        ),
        TolyAction(
          tooltip: '复制',
          style: style,
          onTap: () => $message.success(message: '复制行为触发!'),
          child: Icon(
            Icons.copy_all_outlined,
            size: 20,
          ),
        ),
        TolyAction(
          tooltip: '查看代码',
          style: style,
          onTap: () => $message.success(message: '查看代码行为触发!'),
          child: Icon(
            Icons.code,
            size: 20,
          ),
        ),
        TolyAction(
          tooltip: '赞助',
          style: style,
          toolTipPlacement: Placement.top,
          onTap: () => AppRoute.sponsor.go(context),
          child: Icon(
            Icons.monetization_on_rounded,
            size: 20,
          ),
        ),
        TolyAction(
          tooltip: '结构',
          onTap: null,
          child: Icon(
            Icons.account_tree_sharp,
            size: 20,
          ),
        ),
      ],
    );
  }
}
