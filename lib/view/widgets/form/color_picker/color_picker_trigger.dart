// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Ant Design 风格 ColorPicker 触发器。
///
/// 统一的有边框圆角容器，内部放置色块；[showText] 为 true 时追加 HEX 文本。
class ColorPickerTrigger extends StatelessWidget {
  final Color color;
  final bool cleared;
  final bool showText;
  final double height;
  final bool enabled;

  const ColorPickerTrigger({
    super.key,
    required this.color,
    this.cleared = false,
    this.showText = false,
    this.height = 32,
    this.enabled = true,
  });

  String get _hex {
    final r = color.red.toRadixString(16).padLeft(2, '0');
    final g = color.green.toRadixString(16).padLeft(2, '0');
    final b = color.blue.toRadixString(16).padLeft(2, '0');
    return '#$r$g$b'.toUpperCase();
  }

  static const _borderColor = Color(0xFFD9D9D9);
  static const _clearColor = Color(0xFFFA5555);

  // Ant: colorBgContainerDisabled
  static const _disabledBg = Color(0xFFF5F5F5);

  // Ant: colorTextDisabled
  static const _disabledText = Color(0xFFBFBFBF);

  @override
  Widget build(BuildContext context) {
    const padding = 3.0;
    final swatchSize = height - padding * 2;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: Container(
        constraints: BoxConstraints(minWidth: height, minHeight: height),
        padding: const EdgeInsets.all(padding),
        decoration: BoxDecoration(
          color: enabled ? Colors.white : _disabledBg,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: _borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBlock(swatchSize),
            if (showText) ...[
              const SizedBox(width: 8),
              Text(
                cleared ? '' : _hex,
                style: TextStyle(
                  fontSize: height * 0.375,
                  color: enabled ? const Color(0xFF262626) : _disabledText,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBlock(double size) {
    if (cleared) return _buildClearBlock(size);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildClearBlock(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: _borderColor),
      ),
      child: Center(
        child: Transform.rotate(
          angle: -45 * math.pi / 180,
          child: Container(width: size * 1.1, height: 1, color: _clearColor),
        ),
      ),
    );
  }
}
