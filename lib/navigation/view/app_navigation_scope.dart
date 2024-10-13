import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../view/home_page/home_nav_bar.dart';

class AppNavigationScope extends StatefulWidget{
  final Widget child;
  const AppNavigationScope({super.key, required this.child});

  @override
  State<AppNavigationScope> createState() => _AppNavigationScopeState();
}

class _AppNavigationScopeState extends State<AppNavigationScope> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeNavBar(),
      body: Column(
        children: [
          Divider(),
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}