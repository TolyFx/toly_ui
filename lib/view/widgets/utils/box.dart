import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  final Color color;
  final String? text;

  const Box({super.key, required this.color, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration:
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: text != null ? Text(text!) : null,
    );
  }
}