// import 'dart:ui';
//
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
//
// abstract class ButtonPalette {
//   final Palette backgroundPalette;
//   final Palette foregroundPalette;
//   final BorderRadius borderRadius;
//   final EdgeInsetsGeometry padding;
//   final bool disable;
//
//   ButtonPalette({
//     required this.backgroundPalette,
//     required this.foregroundPalette,
//     required this.borderRadius,
//     required this.padding,
//     this.disable = false,
//   });
//
//   ButtonStyle get style;
// }
//
// class FillButtonPalette extends ButtonPalette {
//   final double elevation;
//
//   FillButtonPalette({
//     required super.backgroundPalette,
//     super.borderRadius = const BorderRadius.all(Radius.circular(4)),
//     super.padding = const EdgeInsets.symmetric(horizontal: 16),
//     this.elevation = 0,
//     super.disable,
//     required super.foregroundPalette,
//   });
//
//   @override
//   ButtonStyle get style {
//
//     Color? getColor(Set<MaterialState> states) {
//       Color color= backgroundPalette.normal;
//       if (states.contains(MaterialState.pressed)) {
//         color = backgroundPalette.pressed;
//       } else {
//         const Set<MaterialState> interactiveStates = <MaterialState>{
//           MaterialState.hovered,
//           MaterialState.focused,
//         };
//         if (states.any(interactiveStates.contains)) {
//           color = backgroundPalette.hover;
//         }
//       }
//       color = disable ? color.withOpacity(_kDisableOpacity) : color;
//       return color;
//     }
//
//     Color? getForegroundColorColor(Set<MaterialState> states) {
//       Color color= foregroundPalette.normal;
//       if (states.contains(MaterialState.pressed)) {
//         color = foregroundPalette.pressed;
//       } else {
//         const Set<MaterialState> interactiveStates = <MaterialState>{
//           MaterialState.hovered,
//           MaterialState.focused,
//         };
//         if (states.any(interactiveStates.contains)) {
//           color = foregroundPalette.hover;
//         }
//       }
//       color = disable ? color.withOpacity(_kDisableOpacity) : color;
//       return color;
//     }
//
//     Color? getBackgroundColor(Set<MaterialState> states) {
//       Color color = backgroundPalette.normal;
//       color = disable ? color.withOpacity(_kDisableOpacity) : color;
//       return color;
//     }
//
//
//     return ButtonStyle(
//       elevation: MaterialStatePropertyAll(elevation),
//       overlayColor: MaterialStateProperty.resolveWith(getColor),
//       foregroundColor: MaterialStateProperty.resolveWith(getForegroundColorColor),
//       backgroundColor: MaterialStateProperty.resolveWith(getBackgroundColor),
//       shape: MaterialStateProperty.all(
//           RoundedRectangleBorder(borderRadius: borderRadius)),
//       padding: MaterialStateProperty.all(padding),
//     );
//   }
// }
//
// double _kDisableOpacity = 0.7;
//
// class OutlineButtonPalette extends ButtonPalette {
//   final Palette borderPalette;
//   final double borderWidth;
//   final double dashGap;
//
//   OutlineButtonPalette({
//     required super.backgroundPalette,
//     super.disable,
//     super.borderRadius = const BorderRadius.all(Radius.circular(4)),
//     super.padding = const EdgeInsets.symmetric(horizontal: 16),
//     required this.borderPalette,
//     this.borderWidth = 1,
//     this.dashGap = 0,
//     required super.foregroundPalette,
//   });
//
//   @override
//   ButtonStyle get style {
//     Color? getColor(Set<MaterialState> states) {
//       if(disable){
//         return backgroundPalette.normal.withOpacity(_kDisableOpacity);
//       }
//       Color color= backgroundPalette.normal;
//       if (states.contains(MaterialState.pressed)) {
//         color = backgroundPalette.pressed;
//       } else {
//         const Set<MaterialState> interactiveStates = <MaterialState>{
//           MaterialState.hovered,
//           MaterialState.focused,
//         };
//         if (states.any(interactiveStates.contains)) {
//           color = backgroundPalette.hover;
//         }
//       }
//       if(disable){
//         color = color.withOpacity(_kDisableOpacity);
//       }
//       return color;
//     }
//
//     Color? getForegroundColor(Set<MaterialState> states) {
//
//       Color color = foregroundPalette.normal;
//       if (states.contains(MaterialState.pressed)) {
//         color = foregroundPalette.pressed;
//       } else {
//         const Set<MaterialState> interactiveStates = <MaterialState>{
//           MaterialState.hovered,
//           MaterialState.focused,
//         };
//         if (states.any(interactiveStates.contains)) {
//           color = foregroundPalette.hover;
//         }
//       }
//       if(disable){
//         color = color.withOpacity(_kDisableOpacity);
//       }
//       return color;
//
//     }
//
//     OutlinedBorder? getOutlineColor(Set<MaterialState> states) {
//
//       Color color = borderPalette.normal;
//
//       if (states.contains(MaterialState.pressed)) {
//         color = borderPalette.pressed;
//       } else {
//         const Set<MaterialState> interactiveStates = <MaterialState>{
//           MaterialState.hovered,
//           MaterialState.focused,
//         };
//         if (states.any(interactiveStates.contains)) {
//           color = borderPalette.hover;
//         }
//       }
//       if(disable){
//         color = color.withOpacity(_kDisableOpacity);
//       }
//
//       if (dashGap == 0) {
//         return RoundedRectangleBorder(
//             borderRadius: borderRadius,
//             side: BorderSide(width: borderWidth, color: color));
//       }
//
//       return DashOutlineShapeBorder(
//           dashGap: dashGap,
//           borderRadius: borderRadius,
//           side: BorderSide(width: borderWidth, color: color));
//     }
//
//     return ButtonStyle(
//       elevation: const MaterialStatePropertyAll(0),
//       overlayColor: MaterialStateProperty.resolveWith(getColor),
//       // side: MaterialStateProperty.resolveWith((getSide)),
//       foregroundColor: MaterialStateProperty.resolveWith(getForegroundColor),
//       backgroundColor: MaterialStateProperty.all(Colors.transparent),
//       shape: MaterialStateProperty.resolveWith(getOutlineColor),
//       padding: MaterialStateProperty.all(padding),
//     );
//   }
// }
//
// class DashOutlineShapeBorder extends OutlinedBorder {
//   const DashOutlineShapeBorder({
//     super.side,
//     this.borderRadius = BorderRadius.zero,
//     required this.dashGap,
//   });
//
//   /// The radii for each corner.
//   final BorderRadiusGeometry borderRadius;
//   final double dashGap;
//
//   @override
//   ShapeBorder scale(double t) {
//     return DashOutlineShapeBorder(
//       side: side.scale(t),
//       borderRadius: borderRadius * t,
//       dashGap: dashGap * t,
//     );
//   }
//
//   @override
//   ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
//     if (a is DashOutlineShapeBorder) {
//       return DashOutlineShapeBorder(
//         side: BorderSide.lerp(a.side, side, t),
//         borderRadius:
//             BorderRadiusGeometry.lerp(a.borderRadius, borderRadius, t)!,
//         dashGap: lerpDouble(a.dashGap, dashGap, t) ?? 0,
//       );
//     }
//     return super.lerpFrom(a, t);
//   }
//
//   @override
//   ShapeBorder? lerpTo(ShapeBorder? b, double t) {
//     if (b is DashOutlineShapeBorder) {
//       return DashOutlineShapeBorder(
//         side: BorderSide.lerp(side, b.side, t),
//         borderRadius:
//             BorderRadiusGeometry.lerp(borderRadius, b.borderRadius, t)!,
//         dashGap: lerpDouble(dashGap, b.dashGap, t) ?? 0,
//       );
//     }
//     return super.lerpTo(b, t);
//   }
//
//   /// Returns a copy of this RoundedRectangleBorder with the given fields
//   /// replaced with the new values.
//   @override
//   DashOutlineShapeBorder copyWith(
//       {BorderSide? side, BorderRadiusGeometry? borderRadius, double? dashGap}) {
//     return DashOutlineShapeBorder(
//       side: side ?? this.side,
//       borderRadius: borderRadius ?? this.borderRadius,
//       dashGap: dashGap ?? this.dashGap,
//     );
//   }
//
//   @override
//   Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
//     final RRect borderRect = borderRadius.resolve(textDirection).toRRect(rect);
//     final RRect adjustedRect = borderRect.deflate(side.strokeInset);
//     return Path()..addRRect(adjustedRect);
//   }
//
//   @override
//   Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
//     return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
//   }
//
//   @override
//   void paintInterior(Canvas canvas, Rect rect, Paint paint,
//       {TextDirection? textDirection}) {
//     if (borderRadius == BorderRadius.zero) {
//       canvas.drawRect(rect, paint);
//     } else {
//       canvas.drawRRect(
//           borderRadius.resolve(textDirection).toRRect(rect), paint);
//     }
//   }
//
//   @override
//   bool get preferPaintInterior => true;
//
//   @override
//   void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
//     final Paint paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = side.width
//       ..color = side.color;
//     Path path = getOuterPath(rect);
//
//     // final PathMetrics pms = path.computeMetrics();
//     //
//     // // final double partLength =
//     // //     step + span * (pointCount + 1) + pointCount * pointLineLength;
//     //
//     // pms.forEach((PathMetric pm) {
//     //   final int count = pm.length ~/ dashGap;
//     //   for (int i = 0; i < count; i++) {
//     //     canvas.drawPath(
//     //       pm.extractPath(dashGap * i, dashGap * i + dashGap),
//     //       paint,
//     //     );
//     //   }
//     //   final double tail = pm.length % dashGap;
//     //   canvas.drawPath(pm.extractPath(pm.length - tail, pm.length), paint);
//     // });
//
//     DashPainter(step: 2).paint(canvas, path, paint);
//     // canvas.drawPath(path, paint);
//
//     // switch (side.style) {
//     //   case BorderStyle.none:
//     //     break;
//     //   case BorderStyle.solid:
//     //     if (side.width == 0.0) {
//     //       canvas.drawRRect(borderRadius.resolve(textDirection).toRRect(rect), side.toPaint());
//     //     } else {
//     //       final Paint paint = Paint()
//     //         ..color = side.color;
//     //       final RRect borderRect = borderRadius.resolve(textDirection).toRRect(rect);
//     //       final RRect inner = borderRect.deflate(side.strokeInset);
//     //       final RRect outer = borderRect.inflate(side.strokeOutset);
//     //       canvas.drawDRRect(outer, inner, paint);
//     //     }
//     // }
//   }
//
//   @override
//   bool operator ==(Object other) {
//     if (other.runtimeType != runtimeType) {
//       return false;
//     }
//     return other is DashOutlineShapeBorder &&
//         other.side == side &&
//         other.borderRadius == borderRadius;
//   }
//
//   @override
//   int get hashCode => Object.hash(side, borderRadius);
//
//   @override
//   String toString() {
//     return '${objectRuntimeType(this, 'DashOutlineShapeBorder')}($side, $borderRadius)';
//   }
// }
//
// // [step] the length of solid line 每段实线长
// // [span] the space of each solid line  每段空格线长
// // [pointCount] the point count of dash line  点划线的点数
// // [pointWidth] the point width of dash line  点划线的点划长
//
// class DashPainter {
//   const DashPainter({
//     this.step = 2,
//     this.span = 2,
//     this.pointCount = 0,
//     this.pointWidth,
//   });
//
//   final double step;
//   final double span;
//   final int pointCount;
//   final double? pointWidth;
//
//   void paint(Canvas canvas, Path path, Paint paint) {
//     final PathMetrics pms = path.computeMetrics();
//     final double pointLineLength = pointWidth ?? paint.strokeWidth;
//     final double partLength =
//         step + span * (pointCount + 1) + pointCount * pointLineLength;
//
//     pms.forEach((PathMetric pm) {
//       final int count = pm.length ~/ partLength;
//       for (int i = 0; i < count; i++) {
//         canvas.drawPath(
//           pm.extractPath(partLength * i, partLength * i + step),
//           paint,
//         );
//         for (int j = 1; j <= pointCount; j++) {
//           final start =
//               partLength * i + step + span * j + pointLineLength * (j - 1);
//           canvas.drawPath(
//             pm.extractPath(start, start + pointLineLength),
//             paint,
//           );
//         }
//       }
//       final double tail = pm.length % partLength;
//       canvas.drawPath(pm.extractPath(pm.length - tail, pm.length), paint);
//     });
//   }
// }
//
// class Palette {
//   final Color hover;
//   final Color normal;
//   final Color pressed;
//
//   const Palette({
//     required this.hover,
//     required this.normal,
//     required this.pressed,
//   });
//
//   const Palette.all(Color color)
//       : hover = color,
//         normal = color,
//         pressed = color;
// }
