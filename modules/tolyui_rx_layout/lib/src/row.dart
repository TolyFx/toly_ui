import 'package:flutter/material.dart';

import 'responsive/rx.dart';
import 'responsive/window_respond_builder.dart';

enum RxAlign {
  top,
  bottom,
  middle,
}

enum RxJustify {
  start,
  end,
  center,
  spaceBetween,
  spaceAround,
  spaceEvenly,
}

class Row$ extends StatelessWidget {
  final List<Cell> cells;
  final Op<num>? gutter;
  final Op<double>? verticalGutter;
  final Op<EdgeInsetsGeometry>? padding;
  final RxAlign align;
  final RxJustify justify;

  const Row$({
    super.key,
    required this.cells,
    this.gutter,
    this.padding,
    this.verticalGutter,
    this.justify = RxJustify.start,
    this.align = RxAlign.top,
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
    num gutter = this.gutter?.call(type) ?? 0;
    double runSpacing = verticalGutter?.call(type) ?? 0;
    double? ph = padding?.call(type).horizontal ?? 0;

    double unit = (maxWidth - 0.000001 - ph) / 24;
    unit -= gutter - gutter / 24;

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
          width: unit * span + (span - 1) * gutter,
          child: child,
        );
        if (push != 0 || pull != 0) {
          child = Transform.translate(
            offset: Offset(dx * unit + dx  * gutter, 0),
            child: child,
          );
        }
        if (offset != 0) {
          child = Padding(
            padding: EdgeInsets.only(
                left: unit * offset + (offset - 1) * gutter + gutter),
            child: SizedBox(
              width: unit * span + (span - 1) * gutter,
              child: child,
            ),
          );
        }
        children.add(child);
      }
    }

    Widget result = Wrap(
      spacing: gutter.toDouble(),
      runSpacing: runSpacing,
      alignment: WrapAlignment.values[justify.index],
      crossAxisAlignment: WrapCrossAlignment.values[align.index],
      children: children,
    );
    if (padding != null) {
      result = Padding(
        padding: padding!(type),
        child: result,
      );
    }
    return SizedBox(width: maxWidth, child: result);
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
