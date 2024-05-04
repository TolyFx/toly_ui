import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../utils/box.dart';

class LayoutDemo6 extends StatelessWidget {
  const LayoutDemo6({super.key});

  @override
  Widget build(BuildContext context) {
    const Color color1 = Color(0xffd3dce6);
    const Color color2 = Color(0xffe5e9f2);
    return Column(
        children: RxAlign.values
        .map((e) => Row$(
        align: e,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6).rx,
        cells: [
          Cell(span: 6.rx, child: const Box(color: color1,height: 20,)),
          Cell(span: 4.rx, child: const Box(color: color2, height: 42)),
          Cell(span: 8.rx, child: const Box(color: color1, height: 52)),
          Cell(span: 6.rx, child: const Box(color: color2)),
        ]))
    .toList());
  }
}


