// import 'package:flutter/material.dart';
//
// import 'row.dart';
// import 'responsive/rx.dart';
// import 'responsive/window_respond_builder.dart';
//
//
// class SizedBox$ extends StatelessWidget {
//   final Widget? child;
//   final Op<double> width;
//   final Op<double> height;
//
//   const SizedBox$({
//     super.key,
//      this.child,
//     required this.width,
//     required this.height,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return WindowRespondBuilder(
//       builder: (BuildContext context, Rx type) {
//         return SizedBox(
//           width: width(type),
//           height: height(type),
//           child: child,
//         );
//       },
//     );
//   }
// }
