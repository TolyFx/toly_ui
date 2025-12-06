//
// import 'package:flutter/material.dart';
// import 'package:fx_string/fx_string.dart';
//
// /// create by 星星 on 2024/5/24
// /// contact me by email 1395723441@qq.com
// /// 说明:
//
// class TolyStatistics extends StatefulWidget {
//   final String title;
//   final TextStyle? titleStyle;
//   final TextStyle? valueStyle;
//   final bool enableSeparator;
//
//   /// [value] Animation
//   final bool enableAnimation;
//
//   /// [value] sum substance
//   final num value;
//   final Widget? prefix;
//   final Widget? suffix;
//
//   const TolyStatistics({
//     super.key,
//     required this.title,
//     this.value = 0,
//     this.suffix,
//     this.titleStyle,
//     this.valueStyle,
//     this.enableSeparator = true,
//     this.prefix,
//     this.enableAnimation = false,
//   });
//
//   @override
//   State<TolyStatistics> createState() => _TolyStatisticsState();
// }
//
// class _TolyStatisticsState extends State<TolyStatistics>
//     with SingleTickerProviderStateMixin {
//   AnimationController? valueAnimationController;
//
//   @override
//   void initState() {
//     if (widget.enableAnimation) {
//       valueAnimationController = AnimationController(
//           vsync: this, duration: const Duration(milliseconds: 500));
//       if (widget.enableAnimation) valueAnimationController?.forward();
//     }
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     TextStyle titleStyle =
//         widget.titleStyle ?? const TextStyle(color: Colors.grey, fontSize: 12);
//     TextStyle valueStyle = widget.valueStyle ??
//         Theme.of(context).textTheme.bodyMedium ??
//         const TextStyle();
//     Widget value = Text("${widget.value}", style: valueStyle);
//     if (widget.enableAnimation) {
//       value = AnimatedBuilder(
//         animation: valueAnimationController!,
//         builder: (BuildContext context, Widget? child) => Text(calcValue),
//       );
//     }
//     Widget optimizedValue = Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (widget.prefix != null) widget.prefix!,
//         value,
//         if (widget.suffix != null) widget.suffix!
//       ],
//     );
//
//     return Column(
//       children: [
//         Text(widget.title, style: titleStyle),
//         const SizedBox(height: 5),
//         optimizedValue,
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     valueAnimationController?.dispose();
//     super.dispose();
//   }
//
//   String get calcValue {
//     String ret = "${(widget.value * valueAnimationController!.value).toInt()}";
//     return ret.separator();
//   }
// }
