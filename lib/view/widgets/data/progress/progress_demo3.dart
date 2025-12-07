import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '不确定进度',
  desc: '展示不确定进度的加载状态。当无法预知任务完成时间时，使用不确定进度条持续显示动画效果，告知用户系统正在处理。适用于网络请求、后台任务等无法准确预估完成时间的场景。',
)
class ProgressDemo3 extends StatelessWidget {
  const ProgressDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        LinearProgressIndicator(),
        SizedBox(height: 24),
        CircularProgressIndicator(),
      ],
    );
  }
}
