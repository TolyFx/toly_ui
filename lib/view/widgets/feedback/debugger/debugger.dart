import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

enum DebugButtonType {
  outlineDisplay,
  fillDisplay,
  conform,
  cancel,
}

class DebugDisplayButton extends StatelessWidget {
  final String info;
  final VoidCallback? onPressed;
  final DebugButtonType type;

  const DebugDisplayButton({
    super.key,
    required this.info,
    this.onPressed,
    this.type = DebugButtonType.outlineDisplay,
  });

  ButtonPalette get palette {
    if(type == DebugButtonType.conform||type ==DebugButtonType.fillDisplay){
      return FillButtonPalette(
        foregroundPalette: Palette.all(Colors.white),
        backgroundPalette: const Palette(
          normal: Color(0xff1890ff),
          hover: Color(0xff40a9ff),
          pressed: Color(0xff096dd9),
        ),
      );
    }


    Palette foreground = const Palette(
        normal: Color(0xff606266),
        hover: Color(0xff096dd9),
        pressed: Color(0xff096dd9));
    Palette border = const Palette(
        normal: Color(0xffd9d9d9),
        hover: Color(0x44409eff),
        pressed: Color(0xff096dd9));
    Palette bg = const Palette(
        normal: Color(0xff1890ff),
        hover: Color(0xffecf5ff),
        pressed: Color(0xffecf5ff));
    return OutlineButtonPalette(
      foregroundPalette: foreground,
      borderPalette: border,
      backgroundPalette: bg,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = ElevatedButton(
      onPressed: onPressed ?? () {},
      style: palette.style,
      child: Text(info),
    );
    if(type == DebugButtonType.cancel||type == DebugButtonType.conform){
      child = SizedBox(
        height: 24,
        child: child,
      );
    }

      return child;
  }
}
