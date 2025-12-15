import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_watermark/tolyui_watermark.dart';

@DisplayNode(
  title: '基础水印',
  desc: '最简单的用法，通过 content 属性设置水印文本内容。水印会以默认样式平铺在子组件上方，不影响子组件的交互。',
)
class WatermarkDemo1 extends StatelessWidget {
  const WatermarkDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyWatermark(
      content: 'Toly UI',
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
