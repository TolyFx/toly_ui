import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

class ButtonDemo4 extends StatelessWidget {
  const ButtonDemo4({super.key});

  @override
  Widget build(BuildContext context) {
    Palette foreground = const Palette(normal: Color(0xff606266), hover: Color(0xff096dd9), pressed: Color(0xff096dd9));
    Palette border = const Palette(normal: Color(0xffd9d9d9), hover: Color(0x44409eff), pressed: Color(0xff096dd9));
    Palette bg = const Palette(normal: Color(0xff1890ff), hover: Color(0xffecf5ff), pressed: Color(0xffecf5ff));

    return Wrap(
      spacing: 20,
      children: [
        ElevatedButton(
          onPressed: null,
          child: Wrap(
            spacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
            Icon(Icons.search,size: 16,),
            Text("Search"),
          ],),
          style: FillButtonPalette(
            disable: true,
            foregroundPalette: Palette.all(Colors.white),
            backgroundPalette: const Palette(
              normal: Color(0xff1890ff),
              hover: Color(0xff40a9ff),
              pressed: Color(0xff096dd9),
            ),
          ).style,
        ),
        ElevatedButton(
          onPressed: null,
          child: Wrap(
            spacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text("Upload"),
              Icon(Icons.upload_outlined,size: 16,),
            ],),
          style: OutlineButtonPalette(
            borderPalette: border,
            disable: true,
            foregroundPalette: foreground,
            borderRadius: BorderRadius.circular(40),
            backgroundPalette: bg,
          ).style,
        ),
        ElevatedButton(
          onPressed: null,
          child: Wrap(
            spacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text("Delete"),
              Icon(Icons.delete,size: 16,),
            ],),
          style: OutlineButtonPalette(
            disable: true,
            borderPalette: const Palette(
              normal: Color(0xffd9d9d9),
              hover: Color(0xfff56c6c),
              pressed: Color(0xfff56c6c),
            ),
            foregroundPalette: const Palette(
              normal: Color(0xff606266),
              hover: Color(0xfff56c6c),
              pressed: Color(0xfff56c6c),
            ),
            borderRadius: BorderRadius.circular(40),
            dashGap: 2,
            backgroundPalette: const Palette.all(Colors.white),
          ).style,
        ),
      ],
    );
  }
}
