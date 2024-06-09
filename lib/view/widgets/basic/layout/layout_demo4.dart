import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../utils/box.dart';
import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title:  r'Row$：间隔与边距',
  desc:r'提供 gutter 属性来指水平方向单元格间距；'
  r'单元格跨度总数超出 24，会自动换行，提供 verticalGutter 属性来指定列竖直方向间距；'
  r'padding 属性可以设计响应式的内边距；'
  r'这三个属性都支持 Rx 响应式变化。',
)
class LayoutDemo4 extends StatelessWidget {
  const LayoutDemo4({super.key});

  @override
  Widget build(BuildContext context) {
    const Color color1 = Color(0xffd3dce6);
    const Color color2 = Color(0xffe5e9f2);
    return Row$(
        gutter: 16.0.rx,
        verticalGutter: 12.0.rx,
        padding: const EdgeInsets.symmetric(horizontal: 40).rx,
        cells: [
          Cell(span: 6.rx, child: const Box(color: color1, text: 'Toly')),
          Cell(span: 5.rx, child: const Box(color: color2, text: 'UI')),
          Cell(span: 7.rx, child: const Box(color: color1, text: 'Responsive')),
          Cell(span: 6.rx, child: const Box(color: color2, text: 'Layout')),
          Cell(span: 11.rx, child: const Box(color: color2, text: '11')),
          Cell(span: 4.rx, child: const Box(color: color2, text: '4')),
          Cell(span: 3.rx, child: const Box(color: color2, text: '3')),
          Cell(span: 6.rx, child: const Box(color: color2, text: '6')),
        ]);
  }
}
