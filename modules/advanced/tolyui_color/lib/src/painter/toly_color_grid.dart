// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-02
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';

class TolyColorGrid extends StatelessWidget {
  final Color? selectedColor;
  final ValueChanged<Color> onChanged;
  final List<List<Color>> colors;

  const TolyColorGrid({
    super.key,
    required this.onChanged,
    this.selectedColor,
    required this.colors,
  });

  static const List<List<Color>> materialColors = [
    [Color(0xFFF44336), Color(0xFFE91E63), Color(0xFF9C27B0), Color(0xFF673AB7), Color(0xFF3F51B5), Color(0xFF2196F3), Color(0xFF03A9F4)],
    [Color(0xFF00BCD4), Color(0xFF009688), Color(0xFF4CAF50), Color(0xFF8BC34A), Color(0xFFCDDC39), Color(0xFFFFEB3B), Color(0xFFFFC107)],
    [Color(0xFFFF9800), Color(0xFFFF5722), Color(0xFF795548), Color(0xFF9E9E9E), Color(0xFF607D8B), Colors.black, Colors.white],
  ];

  static const List<List<Color>> fullMaterialColors = [
    [Colors.white, Color(0xFFEEEEEE), Color(0xFFBDBDBD), Color(0xFF9E9E9E), Color(0xFF616161), Color(0xFF424242), Colors.black],
    [Color(0xFFF44336), Color(0xFFFF5252), Color(0xFFFF8A80), Color(0xFFFFCDD2), Color(0xFFD32F2F), Color(0xFFB71C1C), Color(0xFFFF1744)],
    [Color(0xFFE91E63), Color(0xFFFF4081), Color(0xFFFF80AB), Color(0xFFF8BBD0), Color(0xFFC2185B), Color(0xFF880E4F), Color(0xFFF50057)],
    [Color(0xFF9C27B0), Color(0xFFE040FB), Color(0xFFEA80FC), Color(0xFFE1BEE7), Color(0xFF7B1FA2), Color(0xFF4A148C), Color(0xFF651FFF)],
    [Color(0xFF673AB7), Color(0xFF7C4DFF), Color(0xFFB388FF), Color(0xFFD1C4E9), Color(0xFF512DA8), Color(0xFF311B92), Color(0xFF3D5AFE)],
    [Color(0xFF3F51B5), Color(0xFF536DFE), Color(0xFF8C9EFF), Color(0xFFC5CAE9), Color(0xFF303F9F), Color(0xFF1A237E), Color(0xFF2979FF)],
    [Color(0xFF2196F3), Color(0xFF448AFF), Color(0xFF82B1FF), Color(0xFFBBDEFB), Color(0xFF1976D2), Color(0xFF0D47A1), Color(0xFF00B0FF)],
    [Color(0xFF03A9F4), Color(0xFF40C4FF), Color(0xFF80D8FF), Color(0xFFB3E5FC), Color(0xFF0288D1), Color(0xFF01579B), Color(0xFF00E5FF)],
    [Color(0xFF00BCD4), Color(0xFF18FFFF), Color(0xFF84FFFF), Color(0xFFE0F7FA), Color(0xFF0097A7), Color(0xFF006064), Color(0xFF00E676)],
    [Color(0xFF009688), Color(0xFF64FFDA), Color(0xFFA7FFEB), Color(0xFFE0F2F1), Color(0xFF00796B), Color(0xFF004D40), Color(0xFF76FF03)],
    [Color(0xFF4CAF50), Color(0xFF69F0AE), Color(0xFFB9F6CA), Color(0xFFE8F5E9), Color(0xFF388E3C), Color(0xFF1B5E20), Color(0xFFFFEB3B)],
    [Color(0xFF8BC34A), Color(0xFFB2FF59), Color(0xFFCCFF90), Color(0xFFDCEDC8), Color(0xFF689F38), Color(0xFF33691E), Color(0xFFFFEA00)],
    [Color(0xFFCDDC39), Color(0xFFEEFF41), Color(0xFFF4FF81), Color(0xFFF0F4C3), Color(0xFFAFB42B), Color(0xFF827717), Color(0xFFFFC400)],
    [Color(0xFFFFEB3B), Color(0xFFFFFF00), Color(0xFFFFFF8D), Color(0xFFFFF9C4), Color(0xFFFBC02D), Color(0xFFF57F17), Color(0xFFFF3D00)],
    [Color(0xFFFFC107), Color(0xFFFFD740), Color(0xFFFFE57F), Color(0xFFFFECB3), Color(0xFFFFA000), Color(0xFFFF6F00), Color(0xFFDD2C00)],
    [Color(0xFFFF9800), Color(0xFFFFAB40), Color(0xFFFFCC80), Color(0xFFFFE0B2), Color(0xFFF57C00), Color(0xFFE65100), Color(0xFFFF6D00)],
    [Color(0xFFFF5722), Color(0xFFFF6E40), Color(0xFFFFAB91), Color(0xFFFFCCBC), Color(0xFFD84315), Color(0xFFBF360C), Color(0xFFC6FF00)],
    [Color(0xFF795548), Color(0xFF8D6E63), Color(0xFFBCAAA4), Color(0xFFEFEBE9), Color(0xFF4E342E), Color(0xFF3E2723), Color(0xFF64DD17)],
  ];

  factory TolyColorGrid.material({Color? selectedColor, required ValueChanged<Color> onChanged}) {
    return TolyColorGrid(
      selectedColor: selectedColor,
      onChanged: onChanged,
      colors: materialColors,
    );
  }

  factory TolyColorGrid.fullMaterial({Color? selectedColor, required ValueChanged<Color> onChanged}) {
    return TolyColorGrid(
      selectedColor: selectedColor,
      onChanged: onChanged,
      colors: fullMaterialColors,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: colors.map((row) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: row.map((color) {
            final bool selected = selectedColor?.value == color.value;
            return GestureDetector(
              onTap: () => onChanged(color),
              child: Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: selected ? Colors.white : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: selected
                      ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 4)]
                      : null,
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }


}
