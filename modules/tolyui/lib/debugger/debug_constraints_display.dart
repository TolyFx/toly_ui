import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../data/cons.dart';

class DebugConstraintsDisplay extends StatelessWidget {
  final Widget? child;
  final bool showConstraints;
  final bool showBorder;
  final bool showColor;
  final Color color;

  const DebugConstraintsDisplay({
    super.key,
     this.child,
    this.color = Colors.blue,
    this.showConstraints = true,
     this.showBorder = true,
     this.showColor= true,
  });

  @override
  Widget build(BuildContext context) {
    if (isRelease) return child??const SizedBox();

    return LayoutBuilder(builder: (ctx, cts) {
      return Container(
        width: cts.maxWidth,
        height: cts.maxHeight,
        decoration: BoxDecoration(
            border: showBorder?Border.all(color: color):null,
            color: showColor? color.withOpacity(0.05):null),
        child: showConstraints?Stack(
          children: [
            child??const SizedBox(),
            Positioned(
              right: 0,
              top: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Text(
                  display(cts),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            )
          ],
        ):null,
      );
    });
  }

  String display(BoxConstraints constraints) {
    final String annotation =
        constraints.isNormalized ? '' : '; NOT NORMALIZED';
    if (constraints.minWidth == double.infinity &&
        constraints.minHeight == double.infinity) {
      return 'BoxConstraints\n(biggest$annotation)';
    }
    if (constraints.minWidth == 0 &&
        constraints.maxWidth == double.infinity &&
        constraints.minHeight == 0 &&
        constraints.maxHeight == double.infinity) {
      return 'BoxConstraints\n(unconstrained$annotation)';
    }

    return 'BoxConstraints:\n'
        'W:[${constraints.minWidth.toStringAsFixed(1)},${constraints.maxWidth.toStringAsFixed(1)}]\n'
        'H:[${constraints.minHeight.toStringAsFixed(1)},${constraints.maxHeight.toStringAsFixed(1)}]';
  }
}
