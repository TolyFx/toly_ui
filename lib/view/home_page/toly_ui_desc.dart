import 'package:flutter/material.dart';
import 'package:wrapper/wrapper.dart';

import '../../app/res/toly_icon.dart';
import '../../app/theme/theme.dart';
import 'dart:ui' as ui;

class TolyUIDesc extends StatelessWidget {
  const TolyUIDesc({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness==Brightness.dark;
    Color lineColor = isDark? Color(0xff193761):Color(0xfff2f2f2);
    return DecoratedBox(
      decoration:  HomeTopBgDecoration(lineColor),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 100.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'TolyUI Design',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 38),
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              'Flutter 全平台应用开发组件库',
              style: TextStyle(fontSize: 20, color: Color(0xff515a6e)),
            ),
            SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                spacing: 24,
                runSpacing: 18,

                children: [
                  RepaintBoundary(
                    child: ElevatedButton.icon(

                        style: TextButton.styleFrom(

                            enableFeedback: false,
                            backgroundColor: Theme.of(context).primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6),

                            ),
                            foregroundColor: Colors.white,
                            splashFactory: NoSplash.splashFactory,
                            surfaceTintColor: Colors.transparent
                        ),
                        icon: RotatedBox(
                            quarterTurns: 2, child: Icon(Icons.transit_enterexit,size: 20,)),
                        onPressed: () {},
                        label: Text('开始使用')),
                  ),
                  Wrap(
                    spacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      RepaintBoundary(
                        child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                                enableFeedback: false,
                                side: BorderSide(color: Theme.of(context).primaryColor),
                                // backgroundColor: Theme.of(context).primaryColor,
                                elevation: 0,
                                shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)
                                ),
                                // shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                // foregroundColor: Colors.white,
                                splashFactory: NoSplash.splashFactory,
                                surfaceTintColor: Colors.transparent
                            ),
                            icon:Icon(TolyIcon.iconGithub,size: 18,),
                            onPressed: () {},
                            label: Text('Star')),
                      ),
                      Wrapper(
                        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                        color: Theme.of(context).primaryColor,
                        strokeWidth: px1*2,
                        spineType: SpineType.left,
                        spineHeight: 8,
                        angle: 60,
                        offset: 10,
                        // fromEnd: false,
                        child: Text("1004",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                      )

                    ],
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}

class HomeTopBgDecoration extends Decoration {
  final Color lineColor;
  const HomeTopBgDecoration(this.lineColor);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return HomeTopBoxPainter(lineColor);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeTopBgDecoration &&
          runtimeType == other.runtimeType &&
          lineColor == other.lineColor;

  @override
  int get hashCode => lineColor.hashCode;
}

class HomeTopBoxPainter extends BoxPainter {
  final Color lineColor;

  HomeTopBoxPainter(this.lineColor);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    print(configuration);
    canvas.save();
    canvas.translate(0, offset.dy);
    Size? size = configuration.size;
    if (size == null) return;
    Paint girdPaint = Paint()
      ..style = PaintingStyle.stroke
      ..shader = ui.Gradient.linear(
          Offset(0, 0),
          Offset(0, size.height),
          [lineColor, lineColor, lineColor.withOpacity(0)],
          [0, 0.618, 1]);
    Path path = Path();
    double step = 15;
    for (double i = step; i < size.width; i += step) {
      // path.moveTo(0, step * i);
      // path.relativeLineTo(size.width, 0);
      path.moveTo(i, 0);
      path.relativeLineTo(0, size.height);
    }
    for (double i = step; i < size.height; i += step) {
      path.moveTo(0, i);
      path.relativeLineTo(size.width, 0);
    }
    canvas.drawPath(path, girdPaint);
    canvas.restore();

  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is HomeTopBoxPainter && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}
