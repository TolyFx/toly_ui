// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-02
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';

import 'toly_hue_panel.dart';
import 'toly_alpha_slider.dart';
import 'toly_hex_input.dart';
import 'toly_color_grid.dart';

/// Ant Design 风格的颜色选择器。
///
/// 整合了 [TolyHuePanel]（HSV 调色面板）、[TolyAlphaSlider]（透明度滑条）、
/// [TolyHexInput]（十六进制输入）和 [TolyColorGrid]（预设色块网格），
/// 提供一个完整的取色体验。
///
/// 可嵌入页面直接使用，也可配合 [showColorPicker] 以弹出层形式使用。
class TolyColorPicker extends StatefulWidget {
  final Color color;
  final ValueChanged<Color> onChanged;
  final bool showAlpha;
  final bool showHexInput;
  final bool showPresets;
  final List<List<Color>>? presets;

  const TolyColorPicker({
    super.key,
    required this.color,
    required this.onChanged,
    this.showAlpha = true,
    this.showHexInput = true,
    this.showPresets = true,
    this.presets,
  });

  @override
  State<TolyColorPicker> createState() => _TolyColorPickerState();
}

class _TolyColorPickerState extends State<TolyColorPicker> {
  late Color _color;
  double _alpha = 1.0;

  @override
  void initState() {
    super.initState();
    _color = widget.color;
    _alpha = widget.color.opacity;
  }

  Color get _colorWithAlpha => _color.withAlpha((_alpha * 255).round());

  void _onHueChanged(Color c) {
    setState(() => _color = c);
    widget.onChanged(_colorWithAlpha);
  }

  void _onAlphaChanged(double a) {
    setState(() => _alpha = a);
    widget.onChanged(_colorWithAlpha);
  }

  void _onHexChanged(Color c) {
    setState(() => _color = c);
    widget.onChanged(_colorWithAlpha);
  }

  void _onPresetChanged(Color c) {
    setState(() {
      _color = c;
      _alpha = c.opacity;
    });
    widget.onChanged(_colorWithAlpha);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── HSV 面板 + 色相条 ──
        SizedBox(
          height: 200,
          child: TolyHuePanel(initColor: _color, onChanged: _onHueChanged),
        ),
        const SizedBox(height: 12),
        // ── Alpha 滑条 ──
        if (widget.showAlpha) ...[
          TolyAlphaSlider(color: _color, alpha: _alpha, onChanged: _onAlphaChanged),
          const SizedBox(height: 12),
        ],
        // ── Hex 输入 ──
        if (widget.showHexInput) ...[
          TolyHexInput(color: _color, onChanged: _onHexChanged),
          const SizedBox(height: 12),
        ],
        // ── 当前色预览 ──
        _buildPreview(),
        // ── 预设色块 ──
        if (widget.showPresets && (widget.presets != null || true)) ...[
          const Divider(height: 20),
          TolyColorGrid(
            selectedColor: _color,
            onChanged: _onPresetChanged,
            colors: widget.presets ?? TolyColorGrid.fullMaterialColors,
          ),
        ],
      ],
    );
  }

  Widget _buildPreview() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _colorWithAlpha,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(color: _color.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          _toHex(_colorWithAlpha),
          style: const TextStyle(fontSize: 14, fontFamily: 'monospace', fontWeight: FontWeight.w500),
        ),
        const SizedBox(width: 8),
        Text(
          'α ${(_alpha * 100).round()}%',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontFamily: 'monospace'),
        ),
      ],
    );
  }

  String _toHex(Color c) =>
      '#${c.alpha.toRadixString(16).padLeft(2, '0')}'
      '${c.red.toRadixString(16).padLeft(2, '0')}'
      '${c.green.toRadixString(16).padLeft(2, '0')}'
      '${c.blue.toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();
}

/// 以弹出层形式展示 [TolyColorPicker]。
///
/// 用法：
/// ```dart
/// final Color? result = await showColorPicker(context, color: Colors.blue);
/// ```
Future<Color?> showColorPicker(
  BuildContext context, {
  Color color = Colors.blue,
  bool showAlpha = true,
  bool showHexInput = true,
  bool showPresets = true,
  List<List<Color>>? presets,
}) {
  Color selected = color;
  return showGeneralDialog<Color>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'ColorPicker',
    barrierColor: Colors.black26,
    pageBuilder: (context, _, __) {
      return Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 4))],
          ),
          width: 340,
          child: TolyColorPicker(
            color: selected,
            showAlpha: showAlpha,
            showHexInput: showHexInput,
            showPresets: showPresets,
            presets: presets,
            onChanged: (c) => selected = c,
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut), child: child);
    },
  ).then((_) => selected);
}
