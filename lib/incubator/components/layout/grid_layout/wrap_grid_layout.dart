import 'dart:math';

import 'package:flutter/material.dart';

enum ExpandType {
  spacing,
  width,
}

class Wrap$ extends StatelessWidget {
  final double maxWidth;
  final double height;
  final double spacing;
  final double runSpacing;
  final ExpandType expandType;
  final EdgeInsetsGeometry? padding;
  final List<Widget> children;

  const Wrap$({
    super.key,
    required this.maxWidth,
    required this.height,
    this.spacing = 0,
    this.expandType = ExpandType.width,
    this.padding,
    this.runSpacing = 0,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: padding ?? EdgeInsets.symmetric(horizontal: spacing),
        child: LayoutBuilder(
          builder: (ctx, cts) {
            int count = (cts.maxWidth + spacing) ~/ maxWidth;
            double effectSpacing = spacing;
            count = min(count, children.length);
            double width = (cts.maxWidth / count) - spacing * (count - 1);
            if (expandType == ExpandType.width) {
              width = min(width, maxWidth);
            }
            if (expandType == ExpandType.spacing) {
              width = maxWidth;
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
}
