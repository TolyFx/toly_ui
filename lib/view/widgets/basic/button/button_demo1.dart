import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: '填充样式',
  desc: '按钮的填充样式。通过 FillButtonPalette 调色形成样式, 提供 elevation 设置按钮的阴影深度，默认为 0。',
)
class ButtonDemo1 extends StatelessWidget {
  const ButtonDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text("Conform"),
          style: FillButtonPalette(
            foregroundPalette: Palette.all(Colors.white),
            backgroundPalette: const Palette(
              normal: Color(0xff1890ff),
              hover: Color(0xff40a9ff),
              pressed: Color(0xff096dd9),
            ),
          ).style,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text("Delete"),
          style: FillButtonPalette(
            borderRadius: BorderRadius.circular(40),
            foregroundPalette: Palette.all(Colors.white),
            backgroundPalette: const Palette(
              normal: Color(0xfff56c6c),
              hover: Color(0xfff89898),
              pressed: Color(0xffc45656),
            ),
          ).style,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text("Success"),
          style: FillButtonPalette(
            elevation: 2,
            foregroundPalette: Palette.all(Colors.white),
            backgroundPalette: const Palette(
              normal: Color(0xfff67c23a),
              hover: Color(0xff95d475),
              pressed: Color(0xff529b2e),
            ),
          ).style,
        ),
      ],
    );
  }
}
