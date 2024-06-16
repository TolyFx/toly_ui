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
  title: 'Action 基本使用',
  desc: 'Action 可以触发事件，悬浮时有背景色和 Tooltip 提示；可以通过 toolTipPlacement 指定提示信息的位置：',
)
class ActionDemo1 extends StatelessWidget {
  const ActionDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: [
        TolyAction(
          tooltip: '设置',
          onTap: () => $message.success(message: '打开设置行为触发!'),
          child: Icon(
            Icons.settings,
            size: 20,
          ),
        ),
        TolyAction(
          tooltip: '复制',
          onTap: () => $message.success(message: '复制行为触发!'),
          child: Icon(
            Icons.copy_all_outlined,
            size: 20,
          ),
        ),
        TolyAction(
          tooltip: '查看代码',
          onTap: () => $message.success(message: '查看代码行为触发!'),
          child: Icon(
            Icons.code,
            size: 20,
          ),
        ),
        TolyAction(
          tooltip: '赞助',
          toolTipPlacement: Placement.top,
          onTap: () => AppRoute.sponsor.go(context),
          child: Icon(
            Icons.monetization_on_rounded,
            size: 20,
          ),
        ),
      ],
    );
  }
}
