// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:tolyui_color/tolyui_color.dart';

/// Ant Design 风格内嵌颜色选择器面板。
///
/// 布局：
/// ┌──────────────────────────────┐
/// │ ■                            │  ← 左上角色块预览
/// │ ┌────────────────┐           │  ← S-V 面板
/// │ │                │           │
/// │ │   S-V 面板      │           │
/// │ │                │           │
/// │ └────────────────┘           │
/// │ ●══════════════●    ■        │  ← 水平色相滑条 + 色预览
/// │ ════════════════●            │  ← 水平透明度滑条
/// │ HEX ∨ [#2E70CC] [100%]       │  ← 底部输入栏
/// └──────────────────────────────┘
class TolyColorPickerPanel extends StatefulWidget {
  final Color color;
  final ValueChanged<Color> onChanged;
  final bool showAlpha;
  final bool showHexInput;
  final double width;

  const TolyColorPickerPanel({
    super.key,
    required this.color,
    required this.onChanged,
    this.showAlpha = true,
    this.showHexInput = true,
    this.width = 280,
  });

  @override
  State<TolyColorPickerPanel> createState() => _TolyColorPickerPanelState();
}

class _TolyColorPickerPanelState extends State<TolyColorPickerPanel> {
  late HSVColor _hsv;
  late double _alpha;
  final TextEditingController _hexController = TextEditingController();
  final FocusNode _hexFocus = FocusNode();

  static const double _panelSize = 196.0;
  static const double _sliderHeight = 12.0;
  static const double _thumbRadius = 9.0;
  static const double _previewSize = 24.0;

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.color);
    _alpha = widget.color.opacity;
    _updateHexText();
    _hexFocus.addListener(_onHexFocusChange);
  }

  @override
  void dispose() {
    _hexController.dispose();
    _hexFocus.removeListener(_onHexFocusChange);
    _hexFocus.dispose();
    super.dispose();
  }

  Color get _color => _hsv.toColor().withValues(alpha: _alpha);

  void _updateHexText() {
    final c = _hsv.toColor();
    _hexController.text =
        '#${c.red.toRadixString(16).padLeft(2, '0')}'
        '${c.green.toRadixString(16).padLeft(2, '0')}'
        '${c.blue.toRadixString(16).padLeft(2, '0')}'
            .toUpperCase();
  }

  void _onHexFocusChange() {
    if (!_hexFocus.hasFocus) _applyHexInput();
  }

  void _applyHexInput() {
    final raw = _hexController.text.trim();
    String hex = raw.startsWith('#') ? raw.substring(1) : raw;
    if (hex.length == 6) {
      try {
        final val = int.parse(hex, radix: 16);
        setState(() {
          _hsv = HSVColor.fromColor(Color(0xFF000000 | val));
          widget.onChanged(_color);
        });
      } catch (_) {}
    }
    _updateHexText();
  }

  void _onSVChanged(HSVColor hsv) {
    setState(() => _hsv = hsv);
    _updateHexText();
    widget.onChanged(_color);
  }

  void _onHueChanged(double hue) {
    setState(() => _hsv = _hsv.withHue(hue));
    _updateHexText();
    widget.onChanged(_color);
  }

  void _onAlphaChanged(double alpha) {
    setState(() => _alpha = alpha);
    widget.onChanged(_color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 10),
          _buildHueSlider(),
          const SizedBox(height: 8),
          if (widget.showAlpha) ...[
            _buildAlphaSlider(),
            const SizedBox(height: 8),
          ],
          if (widget.showHexInput) _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: _previewSize,
          height: _previewSize,
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
        const SizedBox(width: 10),
        _SvPanel(
          size: Size(_panelSize - _previewSize - 10, _panelSize - 4),
          hsv: _hsv,
          onChanged: _onSVChanged,
        ),
      ],
    );
  }

  Widget _buildHueSlider() {
    return Row(
      children: [
        Expanded(child: _HueBar(hue: _hsv.hue, onChanged: _onHueChanged)),
        const SizedBox(width: 8),
        Container(
          width: _previewSize,
          height: _sliderHeight,
          decoration: BoxDecoration(
            color: _hsv.toColor(),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
      ],
    );
  }

  Widget _buildAlphaSlider() {
    return Row(
      children: [
        Expanded(
          child: _AlphaBar(
            baseColor: _hsv.toColor(),
            alpha: _alpha,
            onChanged: _onAlphaChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Text('HEX', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
          Icon(Icons.arrow_drop_down, size: 16, color: Colors.grey.shade500),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 24,
              child: TextField(
                controller: _hexController,
                focusNode: _hexFocus,
                style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                onSubmitted: (_) => _applyHexInput(),
              ),
            ),
          ),
          Text('${(_alpha * 100).round()}%',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

// ─── S-V 面板 ──────────────────────────────────────────

class _SvPanel extends StatelessWidget {
  final Size size;
  final HSVColor hsv;
  final ValueChanged<HSVColor> onChanged;

  const _SvPanel({required this.size, required this.hsv, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (e) => _handle(e.localPosition),
      onPanUpdate: (e) => _handle(e.localPosition),
      child: CustomPaint(
        size: size,
        painter: _SvPainter(hsv),
      ),
    );
  }

  void _handle(Offset pos) {
    final s = (pos.dx / size.width).clamp(0.0, 1.0);
    final v = 1.0 - (pos.dy / size.height).clamp(0.0, 1.0);
    onChanged(hsv.withSaturation(s).withValue(v));
  }
}

class _SvPainter extends CustomPainter {
  final HSVColor hsv;
  _SvPainter(this.hsv);

  static const _thumbRadius = 9.0;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    canvas.drawRect(rect, Paint()..color = HSVColor.fromAHSV(1.0, hsv.hue, 1.0, 1.0).toColor());
    canvas.drawRect(rect, Paint()
      ..shader = LinearGradient(colors: [Colors.white, Colors.white.withOpacity(0)],
          begin: Alignment.centerLeft, end: Alignment.centerRight).createShader(rect));
    canvas.drawRect(rect, Paint()
      ..shader = LinearGradient(colors: [Colors.transparent, Colors.black],
          begin: Alignment.topCenter, end: Alignment.bottomCenter).createShader(rect));

    final cx = hsv.saturation * size.width;
    final cy = (1.0 - hsv.value) * size.height;
    final r = 11.0;
    canvas.drawCircle(Offset(cx, cy), r, Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.white
      ..strokeWidth = 2.5);
    canvas.drawCircle(Offset(cx, cy), r, Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black.withOpacity(0.4)
      ..strokeWidth = 1.0);
  }

  @override
  bool shouldRepaint(covariant _SvPainter old) => old.hsv != hsv;
}

// ─── 水平色相条 ──────────────────────────────────────────

class _HueBar extends StatelessWidget {
  final double hue;
  final ValueChanged<double> onChanged;
  const _HueBar({required this.hue, required this.onChanged});

  static const _sliderHeight = 12.0;
  static const _thumbRadius = 9.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _sliderHeight,
      child: LayoutBuilder(builder: (_, constraints) {
        final w = constraints.maxWidth;
        return GestureDetector(
          onPanDown: (e) => _handle(e.localPosition.dx, w),
          onPanUpdate: (e) => _handle(e.localPosition.dx, w),
          child: CustomPaint(painter: _HueBarPainter(hue), willChange: false),
        );
      }),
    );
  }

  void _handle(double x, double w) {
    onChanged((x / w).clamp(0.0, 1.0) * 360);
  }
}

class _HueBarPainter extends CustomPainter {
  final double hue;
  _HueBarPainter(this.hue);

  static const List<Color> _kHueColors = [
    Color(0xFFFF0000), Color(0xFFFF00FF), Color(0xFF0000FF),
    Color(0xFF00FFFF), Color(0xFF00FF00), Color(0xFFFFFF00),
    Color(0xFFFF0000),
  ];

  static const _thumbRadius = 9.0;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.height / 2));
    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawRect(rect, Paint()
      ..shader = LinearGradient(colors: _kHueColors).createShader(rect));
    canvas.restore();
    canvas.drawRRect(rrect, Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey.shade300
      ..strokeWidth = 0.5);

    final dx = (hue / 360 * size.width).clamp(_thumbRadius, size.width - _thumbRadius);
    final cy = size.height / 2;
    canvas.drawCircle(Offset(dx, cy), _thumbRadius, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(dx, cy), _thumbRadius, Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey.shade600
      ..strokeWidth = 1.2);
  }

  @override
  bool shouldRepaint(covariant _HueBarPainter old) => old.hue != hue;
}

// ─── 水平透明度条 ────────────────────────────────────────

class _AlphaBar extends StatelessWidget {
  final Color baseColor;
  final double alpha;
  final ValueChanged<double> onChanged;
  const _AlphaBar({required this.baseColor, required this.alpha, required this.onChanged});

  static const _sliderHeight = 12.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _sliderHeight,
      child: LayoutBuilder(builder: (_, constraints) {
        final w = constraints.maxWidth;
        return GestureDetector(
          onPanDown: (e) => _handle(e.localPosition.dx, w),
          onPanUpdate: (e) => _handle(e.localPosition.dx, w),
          child: CustomPaint(painter: _AlphaBarPainter(baseColor, alpha), willChange: false),
        );
      }),
    );
  }

  void _handle(double x, double w) { onChanged((x / w).clamp(0.0, 1.0)); }
}

class _AlphaBarPainter extends CustomPainter {
  final Color baseColor;
  final double alpha;
  _AlphaBarPainter(this.baseColor, this.alpha);

  static const _thumbRadius = 9.0;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(size.height / 2));
    canvas.save();
    canvas.clipRRect(rrect);
    const ts = 5.0;
    for (double y = 0; y < rect.height; y += ts) {
      for (double x = 0; x < rect.width; x += ts) {
        final white = ((x ~/ ts + y ~/ ts)) % 2 == 0;
        canvas.drawRect(Rect.fromLTWH(x, y, ts, ts),
            Paint()..color = white ? const Color(0xFFCCCCCC) : Colors.white);
      }
    }
    canvas.drawRect(rect, Paint()
      ..shader = LinearGradient(colors: [baseColor.withOpacity(0.0), baseColor]).createShader(rect));
    canvas.restore();
    canvas.drawRRect(rrect, Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey.shade300
      ..strokeWidth = 0.5);
    final dx = (alpha * size.width).clamp(_thumbRadius, size.width - _thumbRadius);
    final cy = size.height / 2;
    canvas.drawCircle(Offset(dx, cy), _thumbRadius, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(dx, cy), _thumbRadius, Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.grey.shade600
      ..strokeWidth = 1.2);
  }

  @override
  bool shouldRepaint(covariant _AlphaBarPainter old) =>
      old.baseColor != baseColor || old.alpha != alpha;
}
