// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:tolyui_color_picker/tolyui_color_picker.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import 'color_picker_trigger.dart';

import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: '受控模式',
  desc: '左侧色块使用 onChanged 实时同步颜色，右侧色块使用 onChangeComplete 仅在松手或输入确认时同步。',
)
class ColorPickerDemo2 extends StatefulWidget {
  const ColorPickerDemo2({super.key});

  @override
  State<ColorPickerDemo2> createState() => _ColorPickerDemo2State();
}

class _ColorPickerDemo2State extends State<ColorPickerDemo2> {
  Color _color = const Color(0xFF2E70CC);
  Color _completeColor = const Color(0xFF2E70CC);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildSwatch(
          color: _color,
          onChanged: (c) => setState(() => _color = c),
        ),
        const SizedBox(width: 8),
        _buildSwatch(
          color: _completeColor,
          onChangeComplete: (c) => setState(() => _completeColor = c),
        ),
      ],
    );
  }

  Widget _buildSwatch({
    required Color color,
    ValueChanged<Color>? onChanged,
    ValueChanged<Color>? onChangeComplete,
  }) {
    return TolyPopover(
      placement: Placement.bottom,
      maxWidth: 280,
      overlay: TolyColorPickerPanel(
        color: color,
        onChanged: (c) => onChanged?.call(c),
        onChangeComplete: (c) => onChangeComplete?.call(c),
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
          child: ColorPickerTrigger(color: color),
        ),
    );
  }
}
