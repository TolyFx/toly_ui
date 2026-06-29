import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: 'RGB 调色面板',
  desc: 'TolyRGBPanel 通过 R/G/B 三个独立滑条精确调色。每个通道范围 0~255，滑条颜色随当前值联动变化。底部实时显示当前色值和 RGB 数值，适合需要数字精确控制的场景。',
)
class ColorDemo2 extends StatefulWidget {
  const ColorDemo2({super.key});

  @override
  State<ColorDemo2> createState() => _ColorDemo2State();
}

class _ColorDemo2State extends State<ColorDemo2> {
  Color _color = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TolyRGBPanel(
        initColor: _color,
        onChanged: (v) => setState(() => _color = v),
      ),
    );
  }
}
