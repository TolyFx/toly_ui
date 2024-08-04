// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-07-02
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';


import 'rgb_color_painter.dart';

class TolyHuePanel extends StatefulWidget {
  final Color initColor;
  final ValueChanged<Color> onChanged;
  const TolyHuePanel({super.key, required this.initColor, required this.onChanged,});

  @override
  State<TolyHuePanel> createState() => _TolyHuePanelState();
}

class _TolyHuePanelState extends State<TolyHuePanel> {
  late HSVColor _color = HSVColor.fromColor(widget.initColor);
  late Color _trackColor = widget.initColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return GestureDetector(
                    onPanDown: (e)=>_onPanDown(e,constraints.biggest),
                    onPanUpdate: (e)=>_onPanUpdate(e,constraints.biggest),
                    child: CustomPaint(
                    painter: HSVWithHueColorPainter(_color),
                ));

                },
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        RepaintBoundary(
          child: SizedBox(
            height: 200,
            width: 16,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints){
                return Container(
                  child: GestureDetector(
                    onPanDown:(e)=> _onPanDownTrack(e,constraints.biggest),
                    onPanUpdate: (e)=>_onPanUpdateTrack(e,constraints.biggest),
                    child: CustomPaint(
                      painter: HSVTrackPainter(_trackColor),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(
          width: 4,
        ),
        // Container(
        //   width: 16,
        //   height: 150,
        //   color: Colors.red,
        //   child: CustomPaint(
        //     painter: TrackPainter(TrackType.red,HSVColor.fromColor(Colors.red)),
        //   ),
        //
        // )
      ],
    );

  }

  void _onPanDown(DragDownDetails details,Size size) {
    Offset localOffset = details.localPosition;
    double horizontal = localOffset.dx.clamp(0.0,size. width);
    double vertical = localOffset.dy.clamp(0.0, size.height);
    _handleColorRectChange(horizontal / size. width, 1 - vertical / size. height);

  }

  void _handleColorRectChange(double horizontal ,double vertical) {
    _color = _color.withSaturation(horizontal).withValue(vertical);
    setState(() {

    });
    widget.onChanged(_color.toColor());
    // onColorChanged(hsvColor.withSaturation(horizontal).withValue(vertical));
  }



  void _onPanUpdate(DragUpdateDetails details,Size size) {
    Offset localOffset = details.localPosition;
    double horizontal = localOffset.dx.clamp(0.0,size. width);
    double vertical = localOffset.dy.clamp(0.0, size.height);
    _handleColorRectChange(horizontal / size. width, 1 - vertical / size. height);
  }

  void _onPanDownTrack(DragDownDetails details,Size size) {
    double hue = (1-details.localPosition.dy/size.height)*360 ;
    hue = hue.clamp(0,360);
    _trackColor = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
    double s = _color.saturation;
    double v = _color.value;
    _color = HSVColor.fromAHSV(1.0, hue,s, v);
    widget.onChanged(_color.toColor());
    setState(() {

    });
  }

  void _onPanUpdateTrack(DragUpdateDetails details,Size size) {
    double hue = (1-details.localPosition.dy/size.height)*360 ;

    hue = hue.clamp(0,360);
    print(hue);

    _trackColor = HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
    double s = _color.saturation;
    double v = _color.saturation;
    _color = HSVColor.fromAHSV(1.0, hue,s, v);
    widget.onChanged(_color.toColor());
    setState(() {

    });
  }
}

class HSVTrackPainter extends CustomPainter{
  final Color color;


  HSVTrackPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset(4,0) & size;

    final List<Color> colors = [
      const HSVColor.fromAHSV(1.0, 360.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 300.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 240.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 180.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 120.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 60.0, 1.0, 1.0).toColor(),
      const HSVColor.fromAHSV(1.0, 0.0, 1.0, 1.0).toColor(),
    ];
    Gradient gradient = LinearGradient(colors: colors,begin: Alignment.topCenter,end: Alignment.bottomCenter);
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
    double hue = HSVColor.fromColor(color).hue;
    double y = size.height-hue/360*size.height;
    Path p = Path()..moveTo(4, y)..relativeLineTo(-6, 4)..relativeLineTo(0, -8)..close();
    canvas.drawPath(p, Paint()..color=Colors.white);
    canvas.drawPath(p, Paint()..style=PaintingStyle.stroke..strokeWidth=0.5..color=Color(0xff444244));
  }

  @override
  bool shouldRepaint(covariant HSVTrackPainter oldDelegate) {
    return oldDelegate.color!=color;
  }

}
