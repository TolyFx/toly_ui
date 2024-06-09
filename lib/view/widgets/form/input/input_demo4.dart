import 'package:flutter/material.dart';

class InputDemo4 extends StatelessWidget {
  const InputDemo4({super.key});

  @override
  Widget build(BuildContext context) {
    double height = 32;
    TextStyle style = TextStyle(fontSize: 14, height: 1);
    Color focusedColor = Colors.blue;
    Color unFocusedColor = Color(0xffd9d9d9);
    CustomBorder focusedBorder = CustomBorder(focusedColor);
    CustomBorder border = CustomBorder(unFocusedColor);
    return SizedBox(
        width: 250,
        child: TextField(
          cursorHeight: style.fontSize,
          cursorWidth: 1,
          style: style,
          // decoration: null
          decoration: InputDecoration(
            hintText: 'Please Input',
            hintStyle: style.copyWith(color: unFocusedColor),
            border: border,
            constraints: BoxConstraints.tight(Size(0, height)),
            contentPadding: EdgeInsets.only(top: -20 + (height - 14) / 2, left: 12, right: 12),
            focusedBorder: focusedBorder,
            enabledBorder: border,
            hoverColor: focusedColor,
            // border: border,
          ),
        ));
  }
}

class CustomBorder extends InputBorder {
  final Color color;

  const CustomBorder(this.color);

  @override
  InputBorder copyWith({BorderSide? borderSide, Color? color}) {
    return CustomBorder(
      color ?? this.color,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRect(rect);
  }

  @override
  bool get isOutline => false;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(0, 0), 4, paint);
    canvas.drawCircle(rect.bottomRight, 4, paint);
    Path path = Path()
      ..relativeLineTo(rect.width, 0)
      ..moveTo(0, rect.height)
      ..relativeLineTo(rect.width, 0);
    canvas.drawPath(path, paint..style = PaintingStyle.stroke);
  }

  @override
  ShapeBorder scale(double t) => this;
}
