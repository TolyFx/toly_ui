// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:tolyui_color/tolyui_color.dart';

/// Ant Design 风格内嵌颜色选择器面板。
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
  final TextEditingController _alphaController = TextEditingController();
  final FocusNode _alphaFocus = FocusNode();

  static const double _sliderHeight = 12.0;
  static const double _thumbRadius = 9.0;
  static const double _previewSize = 24.0;

  @override
  void initState() {
    super.initState();
    _hsv = HSVColor.fromColor(widget.color);
    _alpha = widget.color.opacity;
    _updateTexts();
    _hexFocus.addListener(_onHexFocusChange);
    _alphaFocus.addListener(_onAlphaFocusChange);
  }

  @override
  void dispose() {
    _hexController.dispose();
    _hexFocus.removeListener(_onHexFocusChange);
    _hexFocus.dispose();
    _alphaController.dispose();
    _alphaFocus.removeListener(_onAlphaFocusChange);
    _alphaFocus.dispose();
    super.dispose();
  }

  Color get _color => _hsv.toColor().withValues(alpha: _alpha);

  void _updateTexts() {
    final c = _hsv.toColor();
    _hexController.text =
        '#${c.red.toRadixString(16).padLeft(2, '0')}'
        '${c.green.toRadixString(16).padLeft(2, '0')}'
        '${c.blue.toRadixString(16).padLeft(2, '0')}'
            .toUpperCase();
    _alphaController.text = '${(_alpha * 100).round()}';
  }

  void _onHexFocusChange() {
    if (!_hexFocus.hasFocus) _applyHexInput();
  }

  void _onAlphaFocusChange() {
    if (!_alphaFocus.hasFocus) _applyAlphaInput();
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
    _updateTexts();
  }

  void _applyAlphaInput() {
    final raw = int.tryParse(_alphaController.text.trim());
    if (raw != null) {
      setState(() => _alpha = (raw.clamp(0, 100) / 100));
      widget.onChanged(_color);
    }
    _updateTexts();
  }

  void _onSVChanged(HSVColor hsv) {
    setState(() => _hsv = hsv);
    _updateTexts();
    widget.onChanged(_color);
  }

  void _onHueChanged(double hue) {
    setState(() => _hsv = _hsv.withHue(hue));
    _updateTexts();
    widget.onChanged(_color);
  }

  void _onAlphaChanged(double alpha) {
    setState(() => _alpha = alpha);
    _updateTexts();
    widget.onChanged(_color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSvPanel(),
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

  Widget _buildSvPanel() {
    return LayoutBuilder(
      builder: (_, constraints) {
        final w = constraints.maxWidth;
        return ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: _SvPanel(
            size: Size(w, 160),
            hsv: _hsv,
            onChanged: _onSVChanged,
          ),
        );
      },
    );
  }

  Widget _buildHueSlider() {
    return Row(
      children: [
        Expanded(child: _HueBar(hue: _hsv.hue, onChanged: _onHueChanged)),
        const SizedBox(width: 8),
        Container(
          width: _previewSize,
          height: _previewSize,
          decoration: BoxDecoration(
            color: _hsv.toColor(),
            borderRadius: BorderRadius.circular(4),
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
        const SizedBox(width: 8),
        Container(
          width: _previewSize,
          height: _previewSize,
          decoration: BoxDecoration(
            color: _color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade300),
          ),
        ),
      ],
    );
  }

  Widget _buildInputBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('HEX', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
        Icon(Icons.arrow_drop_down, size: 18, color: Colors.grey.shade500),
        const SizedBox(width: 6),
        Expanded(
          child: SizedBox(
            height: 28,
            child: TextField(
              controller: _hexController,
              focusNode: _hexFocus,
              style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade300)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.blue)),
                isDense: true,
              ),
              onSubmitted: (_) => _applyHexInput(),
            ),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 52,
          height: 28,
          child: TextField(
            controller: _alphaController,
            focusNode: _alphaFocus,
            style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              suffixText: '%',
              suffixStyle: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              contentPadding: const EdgeInsets.only(right: 2, left: 6),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.grey.shade300)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(color: Colors.blue)),
              isDense: true,
            ),
            onSubmitted: (_) => _applyAlphaInput(),
          ),
        ),
      ],
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
