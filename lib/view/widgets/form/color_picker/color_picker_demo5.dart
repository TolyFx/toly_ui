// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:tolyui_color_picker/tolyui_color_picker.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import 'color_picker_trigger.dart';

import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: '清除颜色',
  desc: '开启 allowClear 后面板右上角显示清除按钮，点击后触发器显示清空图标，重新选色即恢复。',
)
class ColorPickerDemo5 extends StatefulWidget {
  const ColorPickerDemo5({super.key});

  @override
  State<ColorPickerDemo5> createState() => _ColorPickerDemo5State();
}

class _ColorPickerDemo5State extends State<ColorPickerDemo5> {
  Color _color = const Color(0xFF2E70CC);
  bool _cleared = true;

  @override
  Widget build(BuildContext context) {
    return TolyPopover(
      placement: Placement.bottom,
      maxWidth: 280,
      overlay: TolyColorPickerPanel(
        color: _color,
        allowClear: true,
        onChanged: (c) {
          setState(() {
            _color = c;
            _cleared = false;
          });
        },
        onClear: () => setState(() => _cleared = true),
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
        child: _cleared
            ? const ColorPickerTrigger(color: Colors.transparent, cleared: true)
            : ColorPickerTrigger(color: _color),
      ),
    );
  }
}
