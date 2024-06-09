import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../utils/box.dart';
import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title:'响应式布局',
  desc: '参照了 Bootstrap 的 响应式设计，预设了五个响应尺阶：xs、sm、md、lg 和 xl。支持响应式的参数都可以感知尺阶设置数值，比如 span 跨度、gutter 间距等。',
)
class LayoutDemo3 extends StatelessWidget {
  const LayoutDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return Row$(
      gutter: 20.rx,
      cells: [
        Cell(
            span: (re) => switch (re) {
                  Rx.xs => 8,
                  Rx.sm => 6,
                  Rx.md => 4,
                  Rx.lg => 3,
                  Rx.xl => 1,
                },
            child: const Box(color: Color(0xffd3dce6))),
        Cell(
            span: (re) => switch (re) {
                  Rx.xs => 4,
                  Rx.sm => 6,
                  Rx.md => 8,
                  Rx.lg => 9,
                  Rx.xl => 11,
                },
            child: const Box(color: Color(0xffe5e9f2))),
        Cell(
            span: (re) => switch (re) {
                  Rx.xs => 12,
                  Rx.sm => 6,
                  Rx.md => 8,
                  Rx.lg => 9,
                  Rx.xl => 11,
                },
            child: const Box(color: Color(0xffd3dce6))),
        Cell(
            span: (re) => switch (re) {
                  Rx.xs => 0,
                  Rx.sm => 6,
                  Rx.md => 4,
                  Rx.lg => 3,
                  Rx.xl => 1,
                },
            child: const Box(color: Color(0xffd3dce6))),
      ],
    );
  }
}
