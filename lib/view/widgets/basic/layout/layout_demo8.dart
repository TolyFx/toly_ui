import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../utils/box.dart';

class LayoutDemo8 extends StatelessWidget {
  const LayoutDemo8({super.key});

  @override
  Widget build(BuildContext context) {
    const Color color1 = Color(0xffd3dce6);
    const Color color2 = Color(0xffe5e9f2);
    return Column(
      children: [
        Row$(
            gutter: 10.0.rx,
            cells: List.generate(24, (index) => Cell(span: 1.rx, child: const Box2(color: color1))).toList()),
        const SizedBox(height: 12),
        const SizedBox(height: 8),
        Row$(gutter: 10.0.rx, cells: [
          Cell(span: 6.rx, child: const Box(color: color1, text: '')),
          Cell(span: 4.rx, push: 1.rx, child: const Box2(color: color2, text: 'push#1')),
          Cell(span: 8.rx, child: const Box(color: Color(0x660000ff), text: '')),
          Cell(span: 6.rx, pull: 2.rx, child: const Box2(color: Color(0x99e5e9f2), text: 'pull#2')),
        ]),
      ],
    );
  }
}


