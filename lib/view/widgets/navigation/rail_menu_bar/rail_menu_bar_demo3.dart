import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: 'FlutterUnit 的导航菜单',
  desc:
      '关于 TolyRailMenuBar 结合导航 2.0 的实际使用方式，可参考其在 FlutterUnit 中的使用: \nhttps://github.com/toly1994328/FlutterUnit/blob/master/lib/navigation/views/desk',
)
class RailMenuBarDemo3 extends StatefulWidget {
  const RailMenuBarDemo3({super.key});

  @override
  State<RailMenuBarDemo3> createState() => _RailMenuBarDemo2State();
}

class _RailMenuBarDemo2State extends State<RailMenuBarDemo3> {
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
      height: 480,
      child: TolyRailMenuBar(
        cellBuilder: FlutterUnitMenuCell.create,
        width: 130,
        gap: 8,
        padding: EdgeInsets.zero,
        backgroundColor: const Color(0xff2C3036),
        leading: (type) => const MenuBarLeading(),
        tail: (type) => const MenuBarTail(),
        menus: navMenus,
        activeId: activeId,
        enableWidthChange: false,
        // backgroundColor: Color(0xff3975c6),
        onSelected: onSelected,
      ),
    );
  }

  void onSelected(String path) {
    setState(() {
      activeId = path;
    });
  }
}

final Tween<double> _widthTween = Tween(begin: 0.82, end: 0.95);
final Tween<double> _sizeTween = Tween(begin: 18.0, end: 22.0);
final Tween<double> _fontSizeTween = Tween(begin: 14.0, end: 15);

class FlutterUnitMenuCell extends StatelessWidget {
  final MenuMeta menu;
  final DisplayMeta display;

  const FlutterUnitMenuCell.create(this.menu, this.display, {super.key});

  Color? get foregroundColor => display.selected ? Colors.white : Colors.white70;

  @override
  Widget build(BuildContext context) {
    double height = 42;

    double anim = display.rate;
    Color? color =
        ColorTween(begin: Colors.white.withAlpha(33), end: Theme.of(context).primaryColor)
            .transform(anim);

    double iconSize = _sizeTween.transform(anim);
    double fontSize = _fontSizeTween.transform(anim);

    TextStyle style = TextStyle(color: foregroundColor, fontSize: fontSize);
    Radius radius = Radius.circular(height / 2);
    BorderRadius br = BorderRadius.only(topRight: radius, bottomRight: radius);
    IconData? icon;
    if(menu is IconMenu){
      icon = (menu as IconMenu).icon;
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: color, borderRadius: br),
        width: _widthTween.transform(anim) * 130,
        height: height,
        child: Wrap(
          spacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Icon(icon, color: foregroundColor, size: iconSize),
            Text(menu.label, style: style),
          ],
        ),
      ),
    );
  }
}

class MenuBarLeading extends StatelessWidget {
  const MenuBarLeading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: [
          Wrap(
            direction: Axis.vertical,
            spacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/me.webp'),
              ),
              Text('张风捷特烈', style: TextStyle(color: Colors.white70))
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Wrap(
              spacing: 12,
              children: [
                Icon(Icons.satellite_sharp, color: Colors.white),
                Icon(Icons.account_balance_wallet, color: Colors.white),
                Icon(Icons.security, color: Colors.white),
              ],
            ),
          ),
          Divider(color: Colors.white, height: 1, endIndent: 20),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class MenuBarTail extends StatelessWidget {
  const MenuBarTail({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Divider(indent: 20, color: Colors.white, height: 1),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Wrap(
            spacing: 12,
            children: [
              Icon(Icons.settings, color: Colors.white),
              Icon(Icons.icecream_sharp, color: Colors.white),
              Icon(Icons.dark_mode, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }
}
