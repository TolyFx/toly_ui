import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

class DeviceFrameDisplay extends StatelessWidget {
  const DeviceFrameDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 50,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(3),
        child: Column(
          children: [
            Container(
              height: 8,
              alignment: Alignment.center,
              child: Container(
                width: 20,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue.shade300, Colors.purple.shade300],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Icon(Icons.phone_android, size: 24, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
