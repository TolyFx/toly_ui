// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:tolyui_color_picker/tolyui_color_picker.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: '自定义触发器',
  desc: '不使用默认触发器，改用自定义按钮。按钮背景色实时跟随选中颜色。',
)
class ColorPickerDemo8 extends StatefulWidget {
  const ColorPickerDemo8({super.key});

  @override
  State<ColorPickerDemo8> createState() => _ColorPickerDemo8State();
}

class _ColorPickerDemo8State extends State<ColorPickerDemo8> {
  Color _color = const Color(0xFF1677FF);

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
      builder: (_, ctrl, __) => GestureDetector(
        onTap: ctrl.open,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'Pick Color',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
