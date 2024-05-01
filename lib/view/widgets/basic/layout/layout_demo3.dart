import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../utils/box.dart';

class LayoutDemo3 extends StatelessWidget {
  const LayoutDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row$(
          gutter: (_) => 20,
          cells: [
            Cell(span: (_) => 16, child: const Box(color: Color(0xff99a9bf))),
            Cell(span: (_) => 8, child: const Box(color: Color(0xff99a9bf))),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Row$(
          gutter: (_) => 20.0,
          cells: [
            Cell(span: (_) => 8, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: (_) => 8, child: const Box(color: Color(0xffe5e9f2))),
            Cell(span: (_) => 4, child: const Box(color: Color(0xffe5e9f2))),
            Cell(span: (_) => 4, child: const Box(color: Color(0xffe5e9f2))),
          ],
        ),
        const SizedBox(height: 12),
        Row$(
          gutter: (_) => 20,
          cells: [
            Cell(span: (_) => 4, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: (_) => 16, child: const Box(color: Color(0xffe5e9f2))),
            Cell(span: (_) => 4, child: const Box(color: Color(0xffd3dce6))),
          ],
        ),
      ],
    );
  }
}
