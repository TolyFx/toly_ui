import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

import '../../../debugger/debugger.dart';

@DisplayNode(
  title: 'TolyUI 默认样式',
  desc: '左侧是支持拖拽拉伸，点击选中时条目背景色、字号、指示器动画变化。\n中间是禁止拖拽拉伸的设置案例。\n右间是自定义动画参数的配置案例。',
)
class RailMenuBarDemo1 extends StatefulWidget {
  const RailMenuBarDemo1({super.key});

  @override
  State<RailMenuBarDemo1> createState() => _RailMenuBarDemo1State();
}

class _RailMenuBarDemo1State extends State<RailMenuBarDemo1> {
  String activeId = '/guide/start';

  List<MenuMeta> navMenus =  [
    IconMenu( Icons.real_estate_agent_rounded, label: "开始使用", route: '/guide/start'),
    IconMenu( Icons.account_tree, label: "模块树", route: '/guide/modules'),
    IconMenu( Icons.privacy_tip, label: "设计原则", route: '/guide/principle'),
    IconMenu( Icons.note_alt, label: "更新日志", route: '/guide/update_log'),
  ];

  Color get backgroundColor {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? Color(0xff191a1c) : Color(0xfff6f7f8);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Row(
        children: [
          display1(),
          const SizedBox(width: 24),
          display2(),
          const SizedBox(width: 24),
          display3(),
        ],
      ),
    );
  }

  Widget display1() => TolyRailMenuBar(
        width: 72,
        maxWidth: 200,
        leading: (type) => DebugLeadingAvatar(type: type),
        menus: navMenus,
        activeId: activeId,
        enableWidthChange: true,
        backgroundColor: backgroundColor,
        onSelected: onSelected,
        tail: (type) => DebugTail(type: type),
      );

  Widget display2() => TolyRailMenuBar(
        width: 72,
        leading: (type) => DebugLeadingAvatar(
          type: type,
        ),
        menus: navMenus,
        activeId: activeId,
        enableWidthChange: false,
        backgroundColor: backgroundColor,
        onSelected: onSelected,
        tail: (type) => DebugTail(type: type),
      );

  Widget display3() => TolyRailMenuBar(
        width: 72,
        maxWidth: 240,
        widthTypeParser: (width) => width > 150 ? MenuWidthType.large : MenuWidthType.small,
        backgroundColor: backgroundColor,
        animationConfig: const AnimationConfig(
            duration: Duration(milliseconds: 500),
            curve: Curves.fastEaseInToSlowEaseOut,
            type: AnimTickType.hove),
        leading: (type) => DebugLeadingAvatar(
          type: type,
        ),
        menus: navMenus,
        enableWidthChange: true,
        activeId: activeId,
        onSelected: onSelected,
        tail: (type) => DebugTail(type: type),
      );

  void onSelected(String path) {
    setState(() {
      activeId = path;
    });
  }
}
