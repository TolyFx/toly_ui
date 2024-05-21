import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:toly_menu/toly_menu.dart';
import 'package:toly_menu_manager/toly_menu_manager.dart';
import 'package:toly_ui/view/home_page/home_nav_bar.dart';
import 'package:tolyui/tolyui.dart';
import 'package:tolyui_rx_layout/tolyui_rx_layout.dart';

import '../../navigation/menu/menu_repository_impl.dart';
import '../../navigation/menu/widget_menus.dart';

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
    return  MenuRouterScope(
      repository: WidgetMenuRepositoryImpl(),
      child: const AppNavMenu(),
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
            // if (r.index > 1) const VerticalDivider(),
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

class _AppNavMenuState extends State<AppNavMenu> with RouterChangeListenerMixin{
  late MenuTreeMeta _menuMeta;

  @override
  void initState() {
    super.initState();
    _initTreeMeta();
  }

  @override
  Widget build(BuildContext context) {

    Color expandBackgroundColor = context.isDark?Colors.black:Colors.transparent;
    Color backgroundColor = context.isDark?Color(0xff001529):Colors.white;

    return TolyRailMenuTree(
      enableWidthChange: true,
      maxWidth: 360,
      width: 240,
      meta: _menuMeta,
      backgroundColor: backgroundColor,
      activeColor: const Color(0xffe6edf3),
      activeItemBackground: Colors.red,
      expandBackgroundColor: expandBackgroundColor,
      onSelect: _onSelect,
    );

    // return MenuChangeListener(
    //   onRouterChanged: (BuildContext ctx, String? path) {
    //     if (path != null) {
    //       context.go(path);
    //     }
    //   },
    //   child: TolyMenu(
    //     // activeItemBackground: Color(0xffe6f7ff),
    //     // activeColor: Color(0xffe6edf3),
    //     // backgroundColor: Colors.white,
    //     // expandBackgroundColor: Colors.white,
    //     // labelTextStyle: TextStyle(color: Color(0xff2d3a53)),
    //     state: context.watchMenu,
    //     onSelect: (menu) {
    //       print(menu.path);
    //       context.changeMenu(menu);
    //     },
    //   ),
    // );
  }

  void _initTreeMeta() {
    MenuNode root = MenuNode.fromMap(widgetMenus);
    _menuMeta = MenuTreeMeta(
      expandMenus: ['/dashboard'],
      activeMenu: root.find('/dashboard/home'),
      root: root,
    );
  }

  void _onSelect(MenuNode menu) {
    if(menu.isLeaf){
      context.go(menu.id);
    }else{
      _menuMeta = _menuMeta.select(menu, singleExpand: true);
      setState(() {});
    }

  }

  @override
  void reassemble() {
    context.reassembleMenu();
    super.reassemble();
  }

  @override
  void onChangeRoute(String path) {
    _menuMeta = _menuMeta.selectPath(path, singleExpand: true);
    print(path);
    setState(() {});
  }
}
