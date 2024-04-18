import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_menu/toly_menu.dart';
import 'package:toly_menu_manager/ext/ext.dart';
import 'package:toly_menu_manager/toly_menu_manager.dart';

import '../../navigation/menu/menu_repository_impl.dart';
import 'basic/layout/layout_display_page.dart';

class WidgetNavigationScope extends StatelessWidget {
  final Widget child;

  const WidgetNavigationScope({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return WindowRespondBuilder(
      builder: (_,re)=>Scaffold(
        drawer: re.index>1?null: Material(
          child: SizedBox(
            width: 240,
            child: MenuRouterScope(
              repository: WidgetMenuRepositoryImpl(),
              child: AppNavMenu(),
            ),
          ),
        ),
        appBar: re.index>1?null:      AppBar(
          toolbarHeight: 56,
          leading: Builder(
            builder: (BuildContext context) { return IconButton(
              icon: Icon(Icons.menu), onPressed: () {
                Scaffold.of(context).openDrawer();
            },
            ); },

          ),
        ),
        body: Row(
          children: [
            if(re.index>1)
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
        if(path!=null){
          context.go(path);
        }
      },
      child: TolyMenu(
        activeColor: Color(0xffe6edf3),
        backgroundColor: Colors.white,
        expandBackgroundColor: Colors.white,
        labelTextStyle: TextStyle(color: Color(0xff2d3a53)),
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
    context.loadMenu();
    super.reassemble();
  }
}
