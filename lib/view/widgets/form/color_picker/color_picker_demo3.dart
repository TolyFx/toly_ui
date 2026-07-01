// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'color_picker_trigger.dart';
import 'package:tolyui_color_picker/tolyui_color_picker.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: '禁用',
  desc: '设置 enabled: false 禁用选择器交互，无法点击打开面板。',
)
class ColorPickerDemo3 extends StatelessWidget {
  const ColorPickerDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyPopover(
      placement: Placement.bottom,
      maxWidth: 280,
      overlay: const TolyColorPickerPanel(
        color: Color(0xFF2E70CC),
        enabled: false,
        onChanged: _noop,
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
        onTap: null, // disabled
        child: const ColorPickerTrigger(color: Color(0xFF2E70CC), enabled: false),
      ),
    );
  }

  static void _noop(Color _) {}
}
