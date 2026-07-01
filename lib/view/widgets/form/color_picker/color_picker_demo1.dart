// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:tolyui_color_picker/tolyui_color_picker.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import 'color_picker_trigger.dart';
import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: '基本使用',
  desc: '点击色块通过 Popover 弹出颜色拾取面板。默认纯色块触发器，showText: true 可显示 HEX 文本。',
)
class ColorPickerDemo1 extends StatefulWidget {
  const ColorPickerDemo1({super.key});

  @override
  State<ColorPickerDemo1> createState() => _ColorPickerDemo1State();
}

class _ColorPickerDemo1State extends State<ColorPickerDemo1> {
  Color _color1 = const Color(0xFF2E70CC);
  Color _color2 = const Color(0xFF2E70CC);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TolyPopover(
          placement: Placement.bottom,
          maxWidth: 280,
          overlay: TolyColorPickerPanel(
            color: _color1,
            onChanged: (c) => setState(() => _color1 = c),
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
            child: ColorPickerTrigger(color: _color1),
          ),
        ),
        const SizedBox(width: 16),
        TolyPopover(
          placement: Placement.bottom,
          maxWidth: 280,
          overlay: TolyColorPickerPanel(
            color: _color2,
            onChanged: (c) => setState(() => _color2 = c),
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
            child: ColorPickerTrigger(color: _color2, showText: true),
          ),
        ),
      ],
    );
  }
}
