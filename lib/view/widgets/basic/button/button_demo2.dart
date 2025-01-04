import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';
import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: '边线样式',
  desc: '按钮的边线样式。通过 OutlineButtonPalette 调色形成样式, dashGap 可以指定虚线的间隔。',
)
class ButtonDemo2 extends StatelessWidget {
  const ButtonDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    Palette foreground = const Palette(normal: Color(0xff606266), hover: Color(0xff096dd9), pressed: Color(0xff096dd9));
    Palette border = const Palette(normal: Color(0xffd9d9d9), hover: Color(0x44409eff), pressed: Color(0xff096dd9));
    Palette bg = const Palette(normal: Color(0xff1890ff), hover: Color(0xffecf5ff), pressed: Color(0xffecf5ff));

    return Wrap(
      spacing: 20,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text("Cancel"),
          style: OutlineButtonPalette(
            foregroundPalette: foreground,
            borderPalette: border,
            backgroundPalette: bg,
          ).style,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text("Cancel"),
          style: OutlineButtonPalette(
            borderPalette: border,
            foregroundPalette: foreground,
            borderRadius: BorderRadius.circular(40),
            backgroundPalette: bg,
          ).style,
        ),
        ElevatedButton(
          onPressed: () {},
          style: OutlineButtonPalette(
            borderPalette: border,
            foregroundPalette: foreground,
            borderRadius: BorderRadius.circular(20),
            step: 2,
            span: 2,
            backgroundPalette: bg,
          ).style,
          child: Text("Cancel"),
        ),
      ],
    );
  }
}
