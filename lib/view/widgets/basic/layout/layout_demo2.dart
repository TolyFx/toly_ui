import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../utils/box.dart';

class LayoutDemo2 extends StatelessWidget {
  const LayoutDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    List<Cell> cells = [
      Cell(span: (_) => 6, child: const Box(color: Color(0xffd3dce6))),
      Cell(span: (_) => 6, child: const Box(color: Color(0xffe5e9f2))),
      Cell(span: (_) => 6, child: const Box(color: Color(0xffd3dce6))),
      Cell(span: (_) => 6, child: const Box(color: Color(0xffe5e9f2))),
    ];
    return Column(
      children: [
        Row$(
          gutter: (_) => 20,
          cells: cells,
        ),
        const SizedBox(height: 12),
        Row$(
          gutter: (re) => switch (re) {
            Rx.xs => 10.0,
            Rx.sm => 20.0,
            Rx.md => 30.0,
            Rx.lg => 40.0,
            Rx.xl => 50.0,
          },
          cells: cells,
        ),
      ],
    );
  }
}
