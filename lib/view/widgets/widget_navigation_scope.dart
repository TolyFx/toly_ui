import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_menu/toly_menu.dart';
import 'package:toly_menu_manager/toly_menu_manager.dart';
import 'package:tolyui_rx_layout/tolyui_rx_layout.dart';

import '../../navigation/menu/menu_repository_impl.dart';

class WidgetNavigationScope extends StatelessWidget {
  final Widget child;

  const WidgetNavigationScope({super.key, required this.child});

  Widget? _buildDrawer(Rx r){
    if(r.index > 1) return null;
    return Material(
      child: _buildMenuBar(),
    );
  }

  PreferredSizeWidget? _buildAppBar(Rx r){
    if(r.index > 1) return null;
    return AppBar(
      toolbarHeight: 56,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    );
  }

  Widget _buildMenuBar(){
    return  SizedBox(
      width: 240,
      child: MenuRouterScope(
        repository: WidgetMenuRepositoryImpl(),
        child: const AppNavMenu(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WindowRespondBuilder(
      builder: (_, r) => Scaffold(
        drawer: _buildDrawer(r),
        appBar: _buildAppBar(r),
        body: Row(
          children: [
            if (r.index > 1) _buildMenuBar(),
            if (r.index > 1) const VerticalDivider(),
            Expanded(child: child),
          ],
        ),
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
    return MenuChangeListener(
      onRouterChanged: (BuildContext ctx, String? path) {
        if (path != null) {
          context.go(path);
        }
      },
      child: TolyMenu(
        // activeItemBackground: Color(0xffe6f7ff),
        // activeColor: Color(0xffe6edf3),
        // backgroundColor: Colors.white,
        // expandBackgroundColor: Colors.white,
        // labelTextStyle: TextStyle(color: Color(0xff2d3a53)),
        state: context.watchMenu,
        onSelect: (menu) {
          print(menu.path);
          context.changeMenu(menu);
        },
      ),
    );
  }

  @override
  void reassemble() {
    context.reassembleMenu();
    super.reassemble();
  }
}
