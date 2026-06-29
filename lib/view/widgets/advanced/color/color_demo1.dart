import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: 'HSV 调色盘',
  desc: 'TolyHuePanel 展示 HSV 方形调色盘：左侧为饱和度和明度面板、右侧为色相滑条。支持设置初始色 initColor，通过 onChanged 回调实时获取选中的颜色。',
)
class ColorDemo1 extends StatefulWidget {
  const ColorDemo1({super.key});

  @override
  State<ColorDemo1> createState() => _ColorDemo1State();
}

class _ColorDemo1State extends State<ColorDemo1> {
  Color _color = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 200,
          width: 300,
          child: TolyHuePanel(
            initColor: _color,
            onChanged: (v) => setState(() => _color = v),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade300, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: _color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _colorToHex(_color),
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'monospace',
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _colorToHex(Color c) =>
      '#${c.alpha.toRadixString(16).padLeft(2, '0')}${c.red.toRadixString(16).padLeft(2, '0')}${c.green.toRadixString(16).padLeft(2, '0')}${c.blue.toRadixString(16).padLeft(2, '0')}'
          .toUpperCase();
}
