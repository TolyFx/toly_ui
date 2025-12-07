import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '基础进度条',
  desc: '展示进度条的基本用法。通过 value 属性控制进度百分比，取值范围 0.0 到 1.0。线性进度条适用于文件上传、任务处理、数据加载等需要展示完成进度的场景。',
)
class ProgressDemo1 extends StatelessWidget {
  const ProgressDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        LinearProgressIndicator(value: 0.3),
        SizedBox(height: 16),
        LinearProgressIndicator(value: 0.6),
        SizedBox(height: 16),
        LinearProgressIndicator(value: 0.9),
      ],
    );
  }
}
