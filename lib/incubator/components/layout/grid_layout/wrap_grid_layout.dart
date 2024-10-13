import 'dart:math';

import 'package:flutter/material.dart';

enum ExpandType {
  spacing,
  width, // 宽度延伸
  limitWidth, // 限制最大宽度为 measureWidth
}

class Wrap$ extends StatelessWidget {
  final double measureWidth;
  final double height;
  final double spacing;
  final double runSpacing;
  final ExpandType expandType;
  final EdgeInsetsGeometry? padding;
  final List<Widget> children;
  final AlignmentGeometry alignment;

  const Wrap$({
    super.key,
    required this.measureWidth,
    required this.height,
    this.alignment = Alignment.center,
    this.spacing = 0,
    this.expandType = ExpandType.width,
    this.padding,
    this.runSpacing = 0,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding ?? EdgeInsets.symmetric(horizontal: spacing),
        child: LayoutBuilder(
          builder: (ctx, cts) {

            int count = (cts.maxWidth + spacing) ~/ measureWidth;
            double effectSpacing = spacing;
            if(expandType!=ExpandType.width){
              count = min(count, children.length);

            }
            // double width = (cts.maxWidth / count) - spacing * (count - 1);
            double width = (cts.maxWidth-spacing * (count - 1))/count ;
            if (expandType == ExpandType.limitWidth) {
              width = min(width, measureWidth);
            }
            if (expandType == ExpandType.spacing) {
              width = measureWidth;
              effectSpacing = (cts.maxWidth - width * count) / (count);
            }

            return Wrap(
              runSpacing: runSpacing,
              spacing: effectSpacing,
              children: children
                  .map((e) => SizedBox(
                        width: width,
                        height: height,
                        child: e,
                      ))
                  .toList(),
            );
          },
        ),
      ),
    );
  }

  /// 以 [measureWidth] 度量，得到每行承载的个数
  ///
  // (double,double) calcSize(double layoutWidth){
  //   int count = (layoutWidth + spacing) ~/ measureWidth;
  //   double effectSpacing = spacing;
  //   count = min(count, children.length);
  //   double width = (layoutWidth / count) - spacing * (count - 1);
  // }

}
