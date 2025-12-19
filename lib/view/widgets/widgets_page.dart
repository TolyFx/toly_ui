import 'package:flutter/material.dart';

class WidgetsPage extends StatelessWidget {
  const WidgetsPage({super.key});

  ///      maxCrossAxisExtent: 320,
//       mainAxisSpacing: 10,
//       mainAxisExtent: 240,
//       crossAxisSpacing: 10,

  @override
  Widget build(BuildContext context) {
    // return Scaffold(body: const Center(child: Text('WidgetsPage')));
    return const Scaffold(
      body: Center(
          // child: DebugConstraintsDisplay(
          //   color: Color(0xff00ffff),
          //   showBorder: true,
          //   showColor: true,
          // ),
          ),
    );
  }
}
