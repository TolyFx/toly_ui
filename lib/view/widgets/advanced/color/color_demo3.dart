import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '颜色值展示与输入',
  desc: '使用 TolyHexInput 支持直接输入十六进制颜色值（6 位），配合 TolyAlphaSlider 调整透明度。右侧面板实时展示当前颜色的 HEX、RGB 及 Flutter Color 写法，方便开发时复制使用。',
)
class ColorDemo3 extends StatefulWidget {
  const ColorDemo3({super.key});

  @override
  State<ColorDemo3> createState() => _ColorDemo3State();
}

class _ColorDemo3State extends State<ColorDemo3> {
  Color _color = Colors.blue;
  double _alpha = 1.0;

  Color get _colorWithAlpha => _color.withAlpha((_alpha * 255).round());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HexInput
          TolyHexInput(
            color: _color,
            onChanged: (v) => setState(() => _color = v),
          ),
          const SizedBox(height: 12),
          // AlphaSlider
          TolyAlphaSlider(
            color: _color,
            alpha: _alpha,
            onChanged: (v) => setState(() => _alpha = v),
          ),
          const SizedBox(height: 16),
          // Preview + Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _colorWithAlpha,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: _colorWithAlpha.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('HEX ', _toHex(_colorWithAlpha)),
                  _infoRow('RGB ', '(${_color.red}, ${_color.green}, ${_color.blue})'),
                  _infoRow('α   ', (_alpha * 100).round().toString()),
                  _infoRow('AHEX', _toAHex(_colorWithAlpha)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontFamily: 'monospace')),
          Text(value, style: const TextStyle(fontSize: 12, fontFamily: 'monospace')),
        ],
      ),
    );
  }

  String _toHex(Color c) =>
      '#${c.red.toRadixString(16).padLeft(2, '0')}${c.green.toRadixString(16).padLeft(2, '0')}${c.blue.toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();

  String _toAHex(Color c) =>
      '#${c.alpha.toRadixString(16).padLeft(2, '0')}${c.red.toRadixString(16).padLeft(2, '0')}${c.green.toRadixString(16).padLeft(2, '0')}${c.blue.toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();
}
