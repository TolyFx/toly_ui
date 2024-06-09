import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../utils/box.dart';
import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title:  r'Row$：水平对齐',
  desc:    r'在水平方向上，单元格有六种对齐方式，通过 justify 参数配置。它具有六种元素，下图自上而下依次是 start、end、center、spaceBetween、spaceAround、spaceEvenly: ',
)
class LayoutDemo5 extends StatelessWidget {
  const LayoutDemo5({super.key});

  @override
  Widget build(BuildContext context) {
    const Color color1 = Color(0xffd3dce6);
    const Color color2 = Color(0xffe5e9f2);
    return Column(
      children: RxJustify.values
          .map((e) =>
          Row$(
              justify: e,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4).rx,
              cells: [
                Cell(span: 4.rx, child: const Box(color: color1)),
                Cell(span: 2.rx, child: const Box(color: color2)),
                Cell(span: 6.rx, child: const Box(color: color1)),
                Cell(span: 6.rx, child: const Box(color: color2)),
              ]))
          .toList(),
    );
  }
}
