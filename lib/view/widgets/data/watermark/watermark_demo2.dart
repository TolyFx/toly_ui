import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_watermark/tolyui_watermark.dart';

@DisplayNode(
  title: '多行水印',
  desc: '通过 contents 属性设置多行文本水印。多行文本会垂直排列，每行之间保持适当间距，适合展示更丰富的水印信息。',
)
class WatermarkDemo2 extends StatelessWidget {
  const WatermarkDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyWatermark(
      contents: const ['Toly UI', 'Happy Coding'],
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
