// import 'package:flutter/material.dart';
//
// import 'responsive/rx.dart';
// import 'responsive/window_respond_builder.dart';
//
// class Row$ extends StatelessWidget {
//   final List<Cell> cells;
//   final Op<double>? gutter;
//
//
//   const Row$({
//     super.key,
//     required this.cells,
//     this.gutter,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return WindowRespondBuilder(
//       builder: (BuildContext context, Rx type) => LayoutBuilder(
//         builder: (ctx, cts) => _buildLayout(type, cts.maxWidth),
//       ),
//     );
//   }
//
//   Widget _buildLayout(Rx type, double maxWidth) {
//     List<Widget> children = [];
//
//     int totalSpan = 0;
//     for (int i = 0; i < cells.length; i++) {
//       Cell cell = cells[i];
//       Widget child = cell.child;
//
//       int span = cell.span?.call(type)??0;
//
//       if (span != 0) {
//         children.add(Expanded(
//           flex: span,
//           child: child,
//         ));
//
//         double? gutter = this.gutter?.call(type);
//
//         if (gutter != null && gutter != 0) {
//           children.add(SizedBox(width: gutter));
//         }
//       }
//       totalSpan += span;
//     }
//
//     if (totalSpan < 24) {
//       children.add(Spacer(
//         flex: 24 - totalSpan,
//       ));
//     }
//     return Row(
//       children: children,
//     );
//   }
// }
//
// // typedef ReParser<T> = T Function(Re re, T value);
//
// class Cell {
//   final Op<int>? span;
//   final Op<double>? push;
//   final Op<double>? pull;
//   final Widget child;
//
//   Cell({
//     this.span,
//     this.push,
//     this.pull,
//     required this.child,
//   });
// }
