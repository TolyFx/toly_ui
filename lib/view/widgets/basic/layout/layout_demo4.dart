import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../utils/box.dart';

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
