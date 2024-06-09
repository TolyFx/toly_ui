Map<String, dynamic> get displayNodes => {
      'InputDemo1': {
        'title': '基础用法',
        'desc': '通过 Flutter 内置的 TextField 组件展示输入框。',
        'code': """class InputDemo1 extends StatelessWidget {
  const InputDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    double height = 32;
    TextStyle style = const TextStyle(fontSize: 14, height: 1);
    double width = 1;
    Color focusedColor = Colors.blue;
    Color unFocusedColor = const Color(0xffd9d9d9);
    OutlineInputBorder focusedBorder = OutlineInputBorder(borderSide: BorderSide(color: focusedColor, width: width));
    OutlineInputBorder border = OutlineInputBorder(borderSide: BorderSide(color: unFocusedColor, width: width));

    return SizedBox(
        width: 250,
        child: TextField(
          cursorHeight: style.fontSize,
          cursorWidth: 1,
          style: style,
          decoration: InputDecoration(
            hintText: 'please input',
            hintStyle: style.copyWith(color: unFocusedColor),
            constraints: BoxConstraints.tight(Size(0, height)),
            contentPadding: EdgeInsets.only(top: 0,right: 12,left: 12),
            focusedBorder: focusedBorder,
            enabledBorder: border,
            hoverColor: focusedColor,
            border: border,
          ),
        ));
  }
}"""
      },
      'InputDemo2': {
        'title': '禁用输入',
        'desc': 'enabled 置为 false 可禁用输入',
        'code': """import 'package:flutter/material.dart';

class InputDemo2 extends StatelessWidget {
  const InputDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    double height = 32;
    TextStyle style = TextStyle(fontSize: 14, height: 1);
    double borderWidth = 1;
    Color focusedColor = Colors.blue;
    Color unFocusedColor = Color(0xffd9d9d9);
    OutlineInputBorder focusedBorder =
        OutlineInputBorder(borderSide: BorderSide(color: focusedColor, width: borderWidth));
    OutlineInputBorder border =
        OutlineInputBorder(borderSide: BorderSide(color: unFocusedColor, width: borderWidth));
    bool enable = false;

    Widget child = TextField(
      enabled: enable,
      cursorHeight: style.fontSize,
      cursorWidth: 1,
      style: style,
      decoration: InputDecoration(
        hintText: 'please input',
        constraints: BoxConstraints.tight(Size(0, height)),
        contentPadding: EdgeInsets.only(top: 0, right: 12, left: 12),
        focusedBorder: focusedBorder,
        enabledBorder: border,
        hoverColor: focusedColor,
        border: border,
      ),
    );

    if (!enable) {
      child = MouseRegion(
        cursor: SystemMouseCursors.forbidden,
        child: IgnorePointer(child: child),
      );
    }
    return SizedBox(
      width: 250,
      child: child,
    );
  }
}
"""
      },
      'InputDemo3': {
        'title': '组合输入框',
        'desc': '可以通过 Wrap/Row 等组件，组合输入框和其他组件。如下：前置标签',
        'code': """class InputDemo3 extends StatelessWidget {
  const InputDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    double height = 32;
    TextStyle style = const TextStyle(fontSize: 14, height: 1);
    double borderWidth = 1;
    Color focusedColor = Colors.blue;
    Color unFocusedColor = const Color(0xffd9d9d9);
    OutlineInputBorder focusedBorder = OutlineInputBorder(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
        borderSide: BorderSide(color: focusedColor, width: borderWidth));
    OutlineInputBorder border = OutlineInputBorder(
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
        borderSide: BorderSide(color: unFocusedColor, width: borderWidth));
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 32,
          // width: 70,
          padding: const EdgeInsets.symmetric(horizontal: 12),

          child: const Center(
              child: Text(
            'Http://',
            style: TextStyle(color: Color(0xff909399), fontSize: 14),
          )),
          decoration: BoxDecoration(
              color: const Color(0xfff5f7fa),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
              border: Border(
                top: BorderSide(color: unFocusedColor),
                left: BorderSide(color: unFocusedColor),
                bottom: BorderSide(color: unFocusedColor),
                // right: BorderSide(),
              )),
        ),
        SizedBox(
            width: 250,
            child: TextField(
              cursorHeight: style.fontSize,
              cursorWidth: 1,
              style: style,
              decoration: InputDecoration(
                // isDense: true,
                hintText: 'Please Input',
                hintStyle: style.copyWith(color: unFocusedColor),
                constraints: BoxConstraints.tight(Size(0, height)),
                // contentPadding: EdgeInsets.only(top: 8),
                contentPadding: const EdgeInsets.only(top: 0, right: 12, left: 12),
                focusedBorder: focusedBorder,
                enabledBorder: border,
                hoverColor: focusedColor,
                border: border,
              ),
            )),
      ],
    );
  }
}"""
      },
      'InputDemo4': {
        'title': '自定义装饰线',
        'desc': '可以通过 Wrap/Row 等组件，组合输入框和其他组件。如下：前置标签',
        'code': """class InputDemo4 extends StatelessWidget {
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
}"""
      },
    };
