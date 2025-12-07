import 'dart:async';
import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '动态进度',
  desc: '展示动态更新的进度条。通过定时器模拟任务进度的实时更新，进度值从 0 逐步增长到 1。用户可以直观地看到任务的完成情况，适用于文件下载、数据导入、批量处理等需要实时反馈进度的场景。',
)
class ProgressDemo5 extends StatefulWidget {
  const ProgressDemo5({super.key});

  @override
  State<ProgressDemo5> createState() => _ProgressDemo5State();
}

class _ProgressDemo5State extends State<ProgressDemo5> {
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startProgress();
  }

  void _startProgress() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress += 0.01;
        if (_progress >= 1.0) {
          _progress = 0.0;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LinearProgressIndicator(value: _progress),
        const SizedBox(height: 16),
        Text('${(_progress * 100).toInt()}%'),
      ],
    );
  }
}
