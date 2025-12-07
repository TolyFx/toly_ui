import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '圆形进度条',
  desc: '展示圆形进度指示器。圆形进度条通过环形的填充来表示进度，视觉上更加紧凑。适用于仪表盘、统计数据、加载状态等需要在有限空间内展示进度的场景。',
)
class ProgressDemo2 extends StatelessWidget {
  const ProgressDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircularProgressIndicator(value: 0.25),
        CircularProgressIndicator(value: 0.5),
        CircularProgressIndicator(value: 0.75),
      ],
    );
  }
}
