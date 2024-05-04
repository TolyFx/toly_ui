import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  final Color color;
  final String? text;
  final double height;

  const Box({super.key, required this.color, this.text, this.height = 32});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      alignment: Alignment.center,
      decoration:
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: text != null ? Text(text!) : null,
    );
  }
}

class Box2 extends StatelessWidget {
  final Color color;
  final String? text;

  const Box2({super.key, required this.color, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, border: Border.all()),
      child: text != null ? Text(text!) : null,
    );
  }
}
