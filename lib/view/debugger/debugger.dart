import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';
export 'display/debug_leading_avatar.dart';
export 'display/debug_tail.dart';

enum DebugButtonType {
  outlineDisplay,
  fillDisplay,
  conform,
  cancel,
}

class DebugDisplayButton extends StatefulWidget {
  final String info;
  final VoidCallback? onPressed;
  final DebugButtonType type;
  final FocusNode? focusNode;

  const DebugDisplayButton({
    super.key,
    required this.info,
    this.onPressed,
    this.focusNode,
    this.type = DebugButtonType.outlineDisplay,
  });

  @override
  State<DebugDisplayButton> createState() => _DebugDisplayButtonState();
}

class _DebugDisplayButtonState extends State<DebugDisplayButton> {
  ButtonPalette get palette {
    if (widget.type == DebugButtonType.conform ||
        widget.type == DebugButtonType.fillDisplay) {
      return FillButtonPalette(
        foregroundPalette: Palette.all(Colors.white),
        backgroundPalette: const Palette(
          normal: Color(0xff1890ff),
          hover: Color(0xff40a9ff),
          pressed: Color(0xff096dd9),
        ),
      );
    }

    return outlineStyle;
  }

  ButtonPalette get outlineStyle {
    Map<Brightness, Palette> foreground = {
      Brightness.light: const Palette(
        normal: Color(0xff606266),
        hover: Color(0xff096dd9),
        pressed: Color(0xff096dd9),
      ),
      Brightness.dark: const Palette(
        normal: Color(0xffcfd3dc),
        hover: Color(0xff409eff),
        pressed: Color(0xff409eff),
      ),
    };
    Map<Brightness, Palette> border = {
      Brightness.light: const Palette(
          normal: Color(0xffd9d9d9),
          hover: Color(0x44409eff),
          pressed: Color(0xff096dd9)),
      Brightness.dark: const Palette(
        normal: Color(0xff4c4d4f),
        hover: Color(0xff213d5b),
        pressed: Color(0xff409eff),
      ),
    };
    Map<Brightness, Palette> bg = {
      Brightness.light: const Palette(
          normal: Color(0xff1890ff),
          hover: Color(0xffecf5ff),
          pressed: Color(0xffecf5ff)),
      Brightness.dark: const Palette(
        normal: Colors.transparent,
        hover: Color(0xff18222c),
        pressed: Color(0xff18222c),
      ),
    };
    Brightness brightness = Theme.of(context).brightness;

    return OutlineButtonPalette(
        foregroundPalette: foreground[brightness]!,
        borderPalette: border[brightness]!,
        backgroundPalette: bg[brightness]!);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = ElevatedButton(
      focusNode: widget.focusNode,
      onPressed: widget.onPressed ?? () {},
      style: palette.style,
      child: Text(widget.info),
    );
    if (widget.type == DebugButtonType.cancel ||
        widget.type == DebugButtonType.conform) {
      child = SizedBox(
        height: 24,
        child: child,
      );
    }

    return child;
  }
}
