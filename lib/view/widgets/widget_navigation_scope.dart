
import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

import 'widget_rail_menu/widget_rai_menu.dart';

class WidgetNavigationScope extends StatefulWidget {
  final Widget child;

  const WidgetNavigationScope({super.key, required this.child});

  @override
  State<WidgetNavigationScope> createState() => _WidgetNavigationScopeState();
}

class _WidgetNavigationScopeState extends State<WidgetNavigationScope> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget? _buildDrawer(Rx r){
    if(r.index > 1) return null;
    return Material(
      child: const AppNavMenu(),
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WindowRespondBuilder(
      builder: (_, r) => Scaffold(
        drawer: _buildDrawer(r),
        appBar: _buildAppBar(r),
        body: Row(
          children: [
            if (r.index > 1) const AppNavMenu(),
            // if (r.index > 1) const VerticalDivider(),
            Expanded(child: widget.child),
          ],
        ),
      ),
    );
  }
}

