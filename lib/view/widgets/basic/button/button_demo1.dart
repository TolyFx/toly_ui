import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/basic/button/button_demo2.dart';
import 'package:tolyui/tolyui.dart';

import 'palette.dart';


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
