import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/view/debugger/debugger.dart';
import 'package:tolyui/tolyui.dart';

import '../home_page/home_nav_bar.dart';

class GuideNavigation extends StatefulWidget {
  final Widget child;

  const GuideNavigation({
    super.key,
    required this.child,
  });

  @override
  State<GuideNavigation> createState() => _GuideNavigationState();
}

class _GuideNavigationState extends State<GuideNavigation> with RouterChangeListenerMixin  {
  String activeId = '/guide/start';

  @override
  Widget build(BuildContext context) {
    const List<MenuMeta> navMenus = [
      MenuMeta(icon: Icons.real_estate_agent_rounded, label: "开始使用", router: '/guide/start'),
      MenuMeta(icon: Icons.account_tree, label: "模块树", router: '/guide/modules'),
      MenuMeta(icon: Icons.privacy_tip, label: "设计原则", router: '/guide/principle'),
      MenuMeta(icon: Icons.note_alt, label: "更新日志", router: '/guide/update_log'),
    ];
    return Scaffold(
        body: Row(
      children: [
        TolyRailMenuBar(
          width: 72,
          maxWidth: 360,
          leading: (type) => DebugLeadingAvatar(type: type,),
          menus: navMenus,
          activeId: activeId,
          enableWidthChange: true,
          // backgroundColor: Color(0xff3975c6),
          onSelected: onSelected,
          tail: (type) => DebugTail(type: type),
        ),
        Expanded(child:widget.child,),
      ],
    ));
  }

  void onSelected(String value) {
    context.go(value);
  }

  @override
  void onChangeRoute(String path) {
    setState(() {
      activeId = path;
    });
  }
}
