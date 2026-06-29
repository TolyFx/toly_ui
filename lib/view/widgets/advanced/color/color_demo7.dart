// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:tolyui_color_picker/tolyui_color_picker.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

class ColorDemo7 extends StatefulWidget {
  const ColorDemo7({super.key});

  @override
  State<ColorDemo7> createState() => _ColorDemo7State();
}

class _ColorDemo7State extends State<ColorDemo7> {
  Color _color = const Color(0xFF2E70CC);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TolyPopover + TolyColorPickerPanel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('点击色块弹出颜色面板', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: [
            _buildSwatch(32),
            _buildSwatch(40),
          ],
        ),
      ],
    );
  }

  Widget _buildSwatch(double size) {
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
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(size / 6),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
      ),
    );
  }
}
