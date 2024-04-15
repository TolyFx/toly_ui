import 'package:flutter/material.dart';
import 'package:platform_adapter/platform_adapter.dart';

class DeskTopBar extends StatelessWidget {
  const DeskTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DragToMoveWrapper(
      child: const SizedBox(
        height: 36,
        child: Row(
          children: [
            Expanded(child: WindowButtons())
          ],
        ),
      ),
    );
  }
}
