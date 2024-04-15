import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toly_menu/toly_menu.dart';
import 'package:toly_menu_manager/ext/ext.dart';
import 'package:toly_menu_manager/toly_menu_manager.dart';

import '../../navigation/menu/menu_repository_impl.dart';

class WidgetNavigationScope extends StatelessWidget {
  final Widget child;

  const WidgetNavigationScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 240,
            child: MenuRouterScope(
              repository: WidgetMenuRepositoryImpl(),
              child: AppNavMenu(),
            ),
          ),
          VerticalDivider(),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class AppNavMenu extends StatefulWidget {
  const AppNavMenu({super.key});

  @override
  State<AppNavMenu> createState() => _AppNavMenuState();
}

class _AppNavMenuState extends State<AppNavMenu> {
  @override
  Widget build(BuildContext context) {
    return TolyMenu(
      activeColor: Color(0xffe6edf3),
      backgroundColor: Colors.white,
      expandBackgroundColor: Colors.white,
      labelTextStyle: TextStyle(color: Color(0xff2d3a53)),
      state: context.watchMenu,
      onSelect: (menu) => context.changeMenu(menu),
    );
  }

  @override
  void reassemble() {
    context.loadMenu();
    super.reassemble();
  }
}
