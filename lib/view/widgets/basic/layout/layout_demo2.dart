import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../display_nodes/display_nodes.dart';
import '../../utils/box.dart';
@DisplayNode(
  title: '混合布局',
  desc:'通过基础的 1/24 分栏任意扩展组合形成较为复杂的混合布局。',
)
class LayoutDemo2 extends StatelessWidget {
  const LayoutDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row$(
          gutter: 20.rx,
          cells: [
            Cell(span: 16.rx, child: const Box(color: Color(0xff99a9bf))),
            Cell(span: 8.rx, child: const Box(color: Color(0xff99a9bf))),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Row$(
          gutter: 20.rx,
          cells: [
            Cell(span: 8.rx, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: 8.rx, child: const Box(color: Color(0xffe5e9f2))),
            Cell(span: 4.rx, child: const Box(color: Color(0xffe5e9f2))),
            Cell(span: 4.rx, child: const Box(color: Color(0xffe5e9f2))),
          ],
        ),
        const SizedBox(height: 12),
        Row$(
          gutter: 20.rx,
          cells: [
            Cell(span: 4.rx, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: 16.rx, child: const Box(color: Color(0xffe5e9f2))),
            Cell(span: 4.rx, child: const Box(color: Color(0xffd3dce6))),
          ],
        ),
      ],
    );
  }
}
