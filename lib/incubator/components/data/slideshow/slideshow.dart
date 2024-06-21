import 'package:flutter/material.dart';

//指示器样式 底部 侧面 切换的箭头
//高度自适应，自定义
//卡片模式
//垂直排列

typedef SlideshowChange = Widget Function(int index);

enum ShowType {
  card,
  normal,
}

enum Direction {
  horizontal,
  vertical,
}

class TolySlideshow extends StatefulWidget {
  //幻灯片切换
  final SlideshowChange? onChange;

  //底部指示器眼样子
  final Widget indicator;
  final double? height;
  final int initIndex;

  //自动播放
  final bool autoPlay;

  //自动切换的间隔
  final Duration interval;

  //显示指示器
  final bool showArrow;

  //卡片还是幻灯片
  final ShowType type;

  //是否循环
  final bool loop;

//方向

  final Direction direction;

  const TolySlideshow(
      {super.key,
      this.onChange,
      this.height,
      required this.initIndex,
      required this.autoPlay,
      required this.interval,
      required this.showArrow,
      required this.type,
      required this.loop,
      required this.direction, required this.indicator});

  @override
  State<TolySlideshow> createState() => _TolySlideshowState();
}

class _TolySlideshowState extends State<TolySlideshow> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
