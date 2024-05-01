import 'package:flutter/material.dart';

class InputDemo2 extends StatelessWidget {
  const InputDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    double height = 32;
    TextStyle style = TextStyle(fontSize: 14, height: 1);
    double borderWidth = 1;
    Color focusedColor = Colors.blue;
    Color unFocusedColor = Color(0xffd9d9d9);
    OutlineInputBorder focusedBorder = OutlineInputBorder(borderSide: BorderSide(color: focusedColor, width: borderWidth));
    OutlineInputBorder border = OutlineInputBorder(borderSide: BorderSide(color: unFocusedColor, width: borderWidth));

    return SizedBox(
        width: 250,
        child: TextField(
          enabled: false,
          cursorHeight: style.fontSize,
          cursorWidth: 1,
          style: style,
          decoration: InputDecoration(
            // isDense: true,
            hintText: 'please input',
            // hintStyle: style.copyWith(color: unFocusedColor),
            constraints: BoxConstraints.tight(Size(0, height)),
            // contentPadding: EdgeInsets.only(top: 8),
            contentPadding: EdgeInsets.only(top: 0,right: 12,left: 12),
            focusedBorder: focusedBorder,
            enabledBorder: border,
            hoverColor: focusedColor,
            border: border,
          ),
        ));
  }
}
