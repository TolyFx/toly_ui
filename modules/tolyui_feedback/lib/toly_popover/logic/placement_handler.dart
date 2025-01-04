//
// import 'package:flutter/cupertino.dart';
//
// import '../../toly_tooltip/tooltip_placement.dart';
//
// /// [size] : 父容器尺寸
// /// [childSize] : 子组件尺寸
// Offset handleOffset(Size size, Size childSize){
//   print("===${size}=====${childSize}========");
//
//   bool outBottom = target.dy > size.height - (childSize.height + boxSize.height / 2 + gap);
//   bool outTop = target.dy < childSize.height + boxSize.height / 2;
//   bool outLeft = target.dx < childSize.width + boxSize.width / 2 + gap;
//   bool outRight =
//       target.dx > size.width - (childSize.width + boxSize.width / 2 + gap);
//
//   Placement effectPlacement =
//   shiftPlacement(outTop, outBottom, outLeft, outRight);
//
//   Offset center =
//   target.translate(-childSize.width / 2, -childSize.height / 2);
//   double halfWidth = (childSize.width - boxSize.width) / 2;
//   double halfLeftWidth = (childSize.width + boxSize.width) / 2 + gap;
//   double halfHeight = (childSize.height - boxSize.height) / 2;
//
//   double verticalHeight = (childSize.height + boxSize.height) / 2 + gap;
//
//   Offset translation = switch (effectPlacement) {
//     Placement.top => Offset(0, -verticalHeight),
//     Placement.topStart => Offset(halfWidth, -verticalHeight),
//     Placement.topEnd => Offset(-halfWidth, -verticalHeight),
//     Placement.bottom => Offset(0, verticalHeight),
//     Placement.bottomStart => Offset(halfWidth, verticalHeight),
//     Placement.bottomEnd => Offset(-halfWidth, verticalHeight),
//     Placement.left => Offset(-halfLeftWidth, 0),
//     Placement.leftStart => Offset(-halfLeftWidth, halfHeight),
//     Placement.leftEnd => Offset(-halfLeftWidth, -halfHeight),
//     Placement.right => Offset(halfLeftWidth, 0),
//     Placement.rightStart => Offset(halfLeftWidth, halfHeight),
//     Placement.rightEnd => Offset(halfLeftWidth, -halfHeight),
//     Placement.overflow => Offset.zero,
//   };
//   Offset result = center + translation;
//
//   double dx = 0;
//   double endEdgeDx = result.dx + childSize.width - size.width;
//   if (endEdgeDx > 0) {
//     result = result.translate(-endEdgeDx, 0);
//     dx = -endEdgeDx;
//   }
//   double startEdgeDy = result.dx;
//   if (startEdgeDy < 0) {
//     result = result.translate(-startEdgeDy, 0);
//     dx = -startEdgeDy;
//   }
//
//   if (offsetCalculator != null) {
//     // effectPlacement,boxSize,childSize,gap
//     result += offsetCalculator!(Calculator(
//         placement: effectPlacement,
//         boxSize: boxSize,
//         overlaySize: childSize,
//         gap: gap));
//   }
//
//   if (effectPlacement != placement || dx != 0) {
//     scheduleMicrotask(() {
//       onPlacementShift(PlacementShift(effectPlacement, dx));
//     });
//   }
// }