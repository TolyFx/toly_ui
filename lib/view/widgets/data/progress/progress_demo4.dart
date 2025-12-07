import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '自定义颜色',
  desc: '展示自定义颜色的进度条。通过 color 属性设置进度条颜色，backgroundColor 设置背景色。不同的颜色可以表达不同的状态含义，如绿色表示正常、橙色表示警告、红色表示错误，帮助用户快速识别任务状态。',
)
class ProgressDemo4 extends StatelessWidget {
  const ProgressDemo4({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(
          value: 0.7,
          color: Colors.green,
          backgroundColor: Colors.green.withAlpha(50),
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: 0.5,
          color: Colors.orange,
          backgroundColor: Colors.orange.withAlpha(50),
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: 0.3,
          color: Colors.red,
          backgroundColor: Colors.red.withAlpha(50),
        ),
      ],
    );
  }
}
