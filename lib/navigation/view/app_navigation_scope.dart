import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../view/home_page/home_nav_bar.dart';

class AppNavigationScope extends StatelessWidget{
  final Widget child;
  const AppNavigationScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: HomeNavBar(),
      body: Column(
        children: [
          Divider(),
          Expanded(child: child),
        ],
      ),
    );
  }
}