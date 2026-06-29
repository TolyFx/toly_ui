// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-02
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';

class TolyRGBPanel extends StatefulWidget {
  final Color initColor;
  final ValueChanged<Color> onChanged;
  const TolyRGBPanel({super.key, required this.initColor, required this.onChanged});

  @override
  State<TolyRGBPanel> createState() => _TolyRGBPanelState();
}

class _TolyRGBPanelState extends State<TolyRGBPanel> {
  late int _r;
  late int _g;
  late int _b;

  @override
  void initState() {
    super.initState();
    _syncFromColor(widget.initColor);
  }

  @override
  void didUpdateWidget(covariant TolyRGBPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initColor != widget.initColor) {
      _syncFromColor(widget.initColor);
    }
  }

  void _syncFromColor(Color c) {
    _r = c.red;
    _g = c.green;
    _b = c.blue;
  }

  Color get _currentColor => Color.fromARGB(255, _r, _g, _b);

  void _notify() => widget.onChanged(_currentColor);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildChannel('R', _r, Colors.red, (v) => setState(() { _r = v.round(); _notify(); })),
        const SizedBox(height: 4),
        _buildChannel('G', _g, Colors.green, (v) => setState(() { _g = v.round(); _notify(); })),
        const SizedBox(height: 4),
        _buildChannel('B', _b, Colors.blue, (v) => setState(() { _b = v.round(); _notify(); })),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _currentColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'R:$_r  G:$_g  B:$_b',
              style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChannel(String label, int value, Color trackColor, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(width: 20, child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: trackColor))),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 24,
            child: SliderTheme(
              data: _sliderTheme(trackColor),
              child: Slider(
                value: value.toDouble(),
                min: 0,
                max: 255,
                divisions: 255,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
        SizedBox(width: 36, child: Text('$value', style: const TextStyle(fontSize: 12, fontFamily: 'monospace'))),
      ],
    );
  }

  SliderThemeData _sliderTheme(Color c) {
    return SliderThemeData(
      trackHeight: 6,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      activeTrackColor: c,
      inactiveTrackColor: c.withValues(alpha: 0.2),
      thumbColor: c,
      overlayColor: c.withValues(alpha: 0.15),
    );
  }
}
