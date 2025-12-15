import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_watermark/tolyui_watermark.dart';

@DisplayNode(
  title: '自定义样式',
  desc: '通过 color、fontSize、fontWeight、rotate、gapX、gapY 等属性自定义水印样式。可以调整水印的颜色、字号、旋转角度和间距，满足不同场景的视觉需求。',
)
class WatermarkDemo3 extends StatelessWidget {
  const WatermarkDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyWatermark(
      content: 'Toly UI',
      color: Colors.blue.withOpacity(0.15),
      fontSize: 20,
      fontWeight: FontWeight.bold,
      rotate: -30,
      gapX: 120,
      gapY: 120,
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
