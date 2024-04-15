import 'package:flutter/material.dart';

class XYGridLayout extends StatelessWidget {
  final List<Widget> children;
  final int len;
  final EdgeInsetsGeometry padding;
  final double xSpacing;
  final double ySpacing;
  final bool land;

  final int x;
  final int y;

  const XYGridLayout({
    Key? key,
    required this.children,
    required this.x,
    required this.y,
    this.xSpacing = 6,
    this.land = false,
    this.ySpacing = 6,
     this.padding = const EdgeInsets.all(6), required this.len,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(len==1){
      return children.first;
    }

    return Padding(
      padding: padding,
      child: LayoutBuilder(builder: (ctx, cts) {
        double width = cts.maxWidth;
        double height = cts.maxHeight;
        int rowCount = x;
        int columnCount = y;

        if(len==2){
          if(land){
            rowCount = 2;
            columnCount = 1;
          }else{
            rowCount = 1;
            columnCount = 2;
          }

        }

        double boxWith = (width -(rowCount-1)*xSpacing)/rowCount;
        double boxHeight = (height - (columnCount-1)*ySpacing)/columnCount;
        return Wrap(
          spacing: xSpacing,
          runSpacing: ySpacing,
          children: List.generate(children.length, (index) => Container(
            width: boxWith,
            height: boxHeight,
            child: children[index],
          )),
        );
      }),
    );
  }
}
