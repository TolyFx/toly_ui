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
  title: 'Color 基本使用',
  desc: 'TolyHuePanel 可以展示 Hue 调色盘，支持设置初始色，以及监听有颜色变化回调:',
)
class ColorDemo1 extends StatelessWidget {
  const ColorDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 320,
      child: TolyHuePanel(
        initColor: Colors.red,
        onChanged: (v) {
          // setState(() {
          //   _color = v;
          // });
          // logic.setPaintColor(v);
        },
      ),
    );
  }
}
