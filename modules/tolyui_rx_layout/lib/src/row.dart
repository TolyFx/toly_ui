import 'package:flutter/material.dart';

import 'responsive/rx.dart';
import 'responsive/window_respond_builder.dart';

class Row$ extends StatelessWidget {
  final List<Cell> cells;
  final Op<double>? gutter;
  final Op<double>? verticalGutter;
  final WrapAlignment alignment;
  final WrapAlignment runAlignment;
  final WrapCrossAlignment crossAxisAlignment;

  const Row$({
    super.key,
    required this.cells,
    this.gutter,
    this.verticalGutter,
    this.runAlignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.alignment = WrapAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return WindowRespondBuilder(
      builder: (ctx, Rx type) => LayoutBuilder(
        builder: (ctx, cts) => _buildLayout(type, cts.maxWidth),
      ),
    );
  }

  Widget _buildLayout(Rx type, double maxWidth) {
    List<Widget> children = [];
    double gutter = this.gutter?.call(type) ?? 0;
    double runSpacing = verticalGutter?.call(type) ?? 0;

    double unit = (maxWidth - 0.000001 - (cells.length - 1) * gutter) / 24;

    int totalSpan = 0;
    for (int i = 0; i < cells.length; i++) {
      Cell cell = cells[i];
      Widget child = cell.child;

      int span = cell.span?.call(type) ?? 0;
      int offset = cell.offset?.call(type) ?? 0;
      int push = cell.push?.call(type) ?? 0;
      int pull = cell.pull?.call(type) ?? 0;
      int dx = push - pull;
      if (span != 0) {
        child = SizedBox(
          width: unit * span,
          child: child,
        );
        if (push != 0 || pull != 0) {
          child = Transform.translate(
            offset: Offset(dx * unit, 0),
            child: child,
          );
        }
        if (offset != 0) {
          child = Padding(
            padding: EdgeInsets.only(left: unit * offset),
            child: SizedBox(
              width: unit * span,
              child: child,
            ),
          );
        }
        children.add(child);
      }
    }

    return Wrap(
      spacing: gutter,
      runSpacing: runSpacing,
      alignment: alignment,
      crossAxisAlignment: crossAxisAlignment,
      runAlignment: runAlignment,
      children: children,
    );
  }
}

class Cell {
  final Op<int>? span;
  final Op<int>? push;
  final Op<int>? offset;
  final Op<int>? pull;
  final Widget child;

  Cell({
    this.span,
    this.offset,
    this.push,
    this.pull,
    required this.child,
  });
}
