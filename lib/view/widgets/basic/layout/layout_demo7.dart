import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../utils/box.dart';
import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: 'Cell: 列偏移',
  desc: r'Cell#offset 可以指定分栏偏移的栏数，该属性支持 Rx 响应式变化。',
)
class LayoutDemo7 extends StatelessWidget {
  const LayoutDemo7({super.key});

  @override
  Widget build(BuildContext context) {
    const Color color1 = Color(0xffd3dce6);
    const Color color2 = Color(0xffe5e9f2);
    return Column(
      children: [
        Row$(gutter: 20.0.rx, cells: [
          Cell(span: 6.rx, child: const Box(color: color1)),
          Cell(span: 6.rx, offset: 6.rx, child: const Box(color: color2)),
        ]),
        const SizedBox(height: 12),
        Row$(gutter: 20.0.rx, cells: [
          Cell(span: 6.rx, offset: 6.rx, child: const Box(color: color2)),
          Cell(span: 6.rx, offset: 6.rx, child: const Box(color: color2)),
        ]),
        const SizedBox(height: 12),
        Row$(gutter: 20.0.rx, cells: [
          Cell(span: 12.rx, offset: 6.rx, child: const Box(color: color1)),
        ]),
      ],
    );
  }
}


