import 'package:flutter/material.dart';
import 'responsive/rx.dart';
import 'responsive/window_respond_builder.dart';


class Padding$ extends StatelessWidget {
  final Widget? child;
  final Op<EdgeInsetsGeometry> padding;

  const Padding$({
    super.key,
     this.child,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return WindowRespondBuilder(
      builder: (BuildContext context, Rx type) {
        return Padding(
          padding: padding(type),
          child: child,
        );
      },
    );
  }
}
