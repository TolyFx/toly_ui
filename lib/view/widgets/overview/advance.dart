import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

class ColorDisplay extends StatelessWidget {
  const ColorDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12.0),
      child: TolyHuePanel(
        initColor: Colors.red,
        onChanged: (Color value) {},
      ),
    );
  }
}
