import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

class LayoutDemo1 extends StatelessWidget {
  const LayoutDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row$(
          cells: [
            Cell(span: (_) => 24, child: const Box(color: Color(0xff99a9bf)))
          ],
        ),
        const SizedBox(height: 12),
        Row$(
          cells: [
            Cell(span: (_) => 12, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: (_) => 12, child: const Box(color: Color(0xffe5e9f2))),
          ],
        ),
        const SizedBox(height: 12),
        Row$(
          cells: [
            Cell(span: (_) => 8, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: (_) => 8, child: const Box(color: Color(0xffe5e9f2))),
            Cell(span: (_) => 8, child: const Box(color: Color(0xffd3dce6))),
          ],
        ),
        const SizedBox(height: 12),
        Row$(
          cells: [
            Cell(span: (_) => 6, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: (_) => 6, child: const Box(color: Color(0xffe5e9f2))),
            Cell(span: (_) => 6, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: (_) => 6, child: const Box(color: Color(0xffe5e9f2))),
          ],
        ),
      ],
    );
  }
}

class Box extends StatelessWidget {
  final Color color;
  final String? text;

  const Box({super.key, required this.color, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: text != null ? Text(text!) : null,
    );
  }
}
