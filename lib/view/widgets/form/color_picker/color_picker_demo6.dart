// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'color_picker_trigger.dart';
import 'package:tolyui_color_picker/tolyui_color_picker.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: '触发器尺寸',
  desc: 'small / 默认 / large 三种触发器大小。',
)
class ColorPickerDemo6 extends StatelessWidget {
  const ColorPickerDemo6({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        _TriggerSwatch(size: 24),
        SizedBox(width: 8),
        _TriggerSwatch(size: 32),
        SizedBox(width: 8),
        _TriggerSwatch(size: 40),
      ],
    );
  }
}

class _TriggerSwatch extends StatefulWidget {
  final double size;
  const _TriggerSwatch({required this.size});

  @override
  State<_TriggerSwatch> createState() => _TriggerSwatchState();
}

class _TriggerSwatchState extends State<_TriggerSwatch> {
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
      builder: (_, ctrl, __) => GestureDetector(
        onTap: ctrl.open,
        child: ColorPickerTrigger(color: _color, height: widget.size),
      ),
    );
  }
}
