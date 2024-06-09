import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';
import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: '响应式尺寸盒',
  desc:r'通过 SizedBox$ 设置具有响应式的尺寸盒',
)
class LayoutDemo9 extends StatelessWidget {
  const LayoutDemo9({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: const Color(0xffd3dce6),
        child: SizedBox$(
            child: const Center(child: Text("宽高根据屏幕尺寸变化的盒子")),
            width: (re) => switch (re) {
                  Rx.xs => 200,
                  Rx.sm => 200,
                  Rx.md => 300,
                  Rx.lg => 400,
                  Rx.xl => 500,
                },
            height: (re) => switch (re) { _ => 40.0 * (re.index + 1) }));
  }
}
