import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

import '../../../debugger/debugger.dart';

@DisplayNode(
  title: '自定义菜单项样式',
  desc: '通过 cellBuilder 可以感知框架内部数据，自定义构建菜单项。如下是三个不同风格的导航菜单。',
)
class RailMenuBarDemo2 extends StatefulWidget {
  const RailMenuBarDemo2({super.key});

  @override
  State<RailMenuBarDemo2> createState() => _RailMenuBarDemo2State();
}

class _RailMenuBarDemo2State extends State<RailMenuBarDemo2> {
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
      height: 440,
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
        cellBuilder: (menu, display) => QiWeiMenuCell(
          menu: menu,
          display: display,
        ),
        width: 68,
        maxWidth: 240,
        padding: EdgeInsets.symmetric(horizontal: 6),
        backgroundColor: Color(0xff3975c6),
        leading: (type) => DebugLeadingAvatar(
          type: type,
          brightness: Brightness.dark,
        ),
        menus: navMenus,
        activeId: activeId,
        enableWidthChange: true,
        // backgroundColor: Color(0xff3975c6),
        onSelected: onSelected,
      );

  Widget display2() => TolyRailMenuBar(
        cellBuilder: (menu, display) => BilibliMenuCell(
          menu: menu,
          display: display,
        ),
        animationConfig:
            AnimationConfig(type: AnimTickType.hove, duration: Duration(milliseconds: 250)),
        width: 68,
        maxWidth: 240,
        padding: EdgeInsets.symmetric(horizontal: 6),
        backgroundColor: Color(0xfff6f7f8),
        leading: (t) => Container(
          height: 56,
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xff9499a0),
            size: 20,
          ),
        ),
        tail: (t) => Container(
          height: 64,
          child: Icon(
            Icons.settings,
            color: Color(0xff9499a0),
            size: 24,
          ),
        ),
        menus: navMenus,
        activeId: activeId,
        enableWidthChange: false,
        // backgroundColor: Color(0xff3975c6),
        onSelected: onSelected,
      );

  Widget display3() => TolyRailMenuBar(
        width: 64,
        gap: 10,
        maxWidth: 200,
        cellStyle: const MenuCellStyle(
          showIndicator: false,
          hideActiveText: false,
          height: 56,
          heightLarge: 46,
          hoverColor: Color(0xff4b5569),
          activeColor: Colors.white,
          foregroundColor: Color(0xffc2c5cc),
          iconSize: 20,
        ),
        animationConfig: AnimationConfig(type: AnimTickType.hove),
        leading: (type) => DebugLeadingAvatar(type: type, brightness: Brightness.dark),
        menus: navMenus,
        activeId: activeId,
        enableWidthChange: true,
        backgroundColor: Color(0xff384359),
        onSelected: onSelected,
        tail: (type) => DebugTail(
          type: type,
          dark: true,
        ),
      );

  void onSelected(String path) {
    setState(() {
      activeId = path;
    });
  }
}

class QiWeiMenuCell extends StatelessWidget {
  final MenuMeta menu;
  final DisplayMeta display;

  const QiWeiMenuCell({
    super.key,
    required this.menu,
    required this.display,
  });

  Color? get foregroundColor {
    return display.selected ? Colors.white : const Color(0xffafc8e8);
  }

  Color? get backgroundColor {
    if (display.hovered && display.selected) return const Color(0xff578acf);
    if (display.hovered) return const Color(0xff427cc9);
    if (display.selected) return const Color(0xff4c83cc);
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    bool largeWidth = display.widthType == MenuWidthType.large;
    TextStyle style = TextStyle(color: foregroundColor, fontSize: largeWidth ? 14 : 11);
    BorderRadius br = const BorderRadius.all(Radius.circular(6));
    IconData? icon;
    if(menu is IconMenu){
      icon = (menu as IconMenu).icon;
    }
    return Container(
      alignment: largeWidth ? Alignment.centerLeft : Alignment.center,
      padding: largeWidth ? const EdgeInsets.symmetric(horizontal: 12) : null,
      decoration: BoxDecoration(color: backgroundColor, borderRadius: br),
      height: largeWidth ? 42 : 56,
      child: Wrap(
        spacing: 6,
        direction: largeWidth ? Axis.horizontal : Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(icon, color: foregroundColor, size: 18),
          Text(menu.label, style: style),
        ],
      ),
    );
  }
}

class BilibliMenuCell extends StatelessWidget {
  final MenuMeta menu;
  final DisplayMeta display;

  const BilibliMenuCell({
    super.key,
    required this.menu,
    required this.display,
  });

  ColorTween get foregroundTween => ColorTween(
        begin: const Color(0xff61666d),
        end: const Color(0xffff6699),
      );

  ColorTween get textTween =>
      ColorTween(begin: const Color(0xff9499a0), end: const Color(0xffff6699));

  Color? get foregroundColor => foregroundTween.transform(display.rate);

  Color? get textColor => textTween.transform(display.rate);

  @override
  Widget build(BuildContext context) {
    bool largeWidth = display.widthType == MenuWidthType.large;
    TextStyle style = TextStyle(color: textColor, fontSize: 12);
    IconData? icon;
    if(menu is IconMenu){
      icon = (menu as IconMenu).icon;
    }
    return Container(
      alignment: largeWidth ? Alignment.centerLeft : Alignment.center,
      height: 64,
      child: Wrap(
        spacing: 6,
        direction: largeWidth ? Axis.horizontal : Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Icon(icon, color: foregroundColor, size: 24),
          Text(menu.label, style: style),
        ],
      ),
    );
  }
}
