import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_watermark/tolyui_watermark.dart';

@DisplayNode(
  title: '水印密度',
  desc: '通过 gapX 和 gapY 参数控制水印的横向和纵向间距，从而调整水印密度。间距越小，水印越密集，防护效果越强。',
)
class WatermarkDemo5 extends StatelessWidget {
  const WatermarkDemo5({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('稀疏 (gap: 200)', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
              TolyWatermark(
                content: 'Toly UI',
                gapX: 200,
                gapY: 200,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('适中 (gap: 100)', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
              TolyWatermark(
                content: 'Toly UI',
                gapX: 100,
                gapY: 100,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('密集 (gap: 50)', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
              TolyWatermark(
                content: 'Toly UI',
                gapX: 50,
                gapY: 50,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
