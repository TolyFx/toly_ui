// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'color_picker_trigger.dart';
import 'package:tolyui_color_picker/tolyui_color_picker.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: '悬停触发',
  desc: '通过 MouseRegion 监听鼠标进入/离开事件，实现 hover 触发弹出面板。',
)
class ColorPickerDemo7 extends StatefulWidget {
  const ColorPickerDemo7({super.key});

  @override
  State<ColorPickerDemo7> createState() => _ColorPickerDemo7State();
}

class _ColorPickerDemo7State extends State<ColorPickerDemo7> {
  Color _color = const Color(0xFF2E70CC);

  @override
  Widget build(BuildContext context) {
    return TolyPopover(
      placement: Placement.bottom,
      maxWidth: 280,
      overlay: TolyColorPickerPanel(
        color: _color,
        onChanged: (c) => setState(() => _color = c),
      ),
      overlayDecorationBuilder: (_) => BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      builder: (_, ctrl, __) => MouseRegion(
        onEnter: (_) => ctrl.open(),
        onExit: (_) => ctrl.close(),
        child: ColorPickerTrigger(color: _color),
      ),
    );
  }
}
