import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_watermark/tolyui_watermark.dart';

@DisplayNode(
  title: '内容区域水印',
  desc: '水印可以应用在任何内容区域上，包括文本、图片、列表等。水印层不会阻挡用户交互，内容区域保持完全可操作。',
)
class WatermarkDemo4 extends StatelessWidget {
  const WatermarkDemo4({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyWatermark(
      content: '机密文档',
      color: Colors.red.withOpacity(0.1),
      fontSize: 18,
      rotate: -15,
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '重要通知',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                '这是一份重要的机密文档，包含敏感信息。水印可以有效防止未经授权的传播和使用。'
                '在实际应用中，水印常用于版权保护、文档溯源、防伪标识等场景。',
                style: TextStyle(fontSize: 14, height: 1.6),
              ),
              SizedBox(height: 16),
              Text(
                '水印特点：',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text('• 不影响内容阅读', style: TextStyle(height: 1.8)),
              Text('• 不阻挡用户交互', style: TextStyle(height: 1.8)),
              Text('• 可自定义样式', style: TextStyle(height: 1.8)),
              Text('• 支持文本和图片', style: TextStyle(height: 1.8)),
            ],
          ),
        ),
      ),
    );
  }
}
