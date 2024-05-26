import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/app/logic/actions/navigation.dart';
import 'package:toly_ui/app/theme/theme.dart';
import 'package:tolyui_navigation/src/tabs/toly_tabs.dart';
import 'package:toly_ui/incubator/ext/go_router/listener.dart';
import 'package:tolyui/tolyui.dart';

import '../../app/logic/app_state/app_logic.dart';
import '../../app/res/toly_icon.dart';
import '../../incubator/components/toly_tab_bar.dart';

class HomeNavBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, cts) => AppBar(
          actions: [
            const AppNavMenus(),
            const SizedBox(
              width: 12,
            ),
            const AppThemeSwitch(),
            if (cts.maxWidth > 400)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.translate),
              ),
            if (cts.maxWidth > 400)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    jumpUrl('https://github.com/TolyFx/toly_ui');
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Icon(TolyIcon.iconGithub),
                  ),
                ),
              )
          ],
          titleSpacing: 0,
          title: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => goHome(context),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: SvgPicture.asset(
                          'assets/images/logo.svg',
                          width: 30,
                        )),
                  ),
                  if (cts.maxWidth > 480)
                    Text(
                      "TolyUI",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                ],
              ),
            ),
          )),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AppThemeSwitch extends StatelessWidget {
  const AppThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Transform.scale(
      scale: 0.85,
      child: Switch(
          value: isDark,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          trackOutlineWidth: WidgetStateProperty.all(px1),
          inactiveTrackColor: const Color(0xfff2f2f2),
          activeColor: const Color(0xff2c2c2c),
          trackOutlineColor: WidgetStateProperty.all(const Color(0xffdcdfe6)),
          // thumbIcon: MaterialStateProperty.all(const Icon(
          //   Icons.light_mode,
          //   color: Color(0xff606266),
          // )),
          thumbIcon: WidgetStateProperty.all(isDark
              ? const Icon(
                  Icons.dark_mode,
                  color: const Color(0xff2c2c2c),
                )
              : const Icon(
                  Icons.light_mode,
                  color: const Color(0xff2c2c2c),
                )),
          thumbColor: WidgetStateProperty.all(Colors.white),
          onChanged: (v) => context.read<AppLogic>().toggleThemeModel(v)),
    );
  }
}

class AppNavMenus extends StatefulWidget {
  const AppNavMenus({super.key});

  @override
  State<AppNavMenus> createState() => _AppNavMenusState();
}

class _AppNavMenusState extends State<AppNavMenus>
    with RouterChangeListenerMixin {
  String _activeId = '';

  List<MenuMeta> items = const [
    MenuMeta(label: '指南', router: '/guide'),
    MenuMeta(label: '组件', router: '/widgets'),
    MenuMeta(label: '生态', router: '/ecological'),
    MenuMeta(label: '赞助', router: '/sponsor'),
  ];

  @override
  void initState() {
    super.initState();
    _activeId = items.first.id;
  }

  @override
  Widget build(BuildContext context) {
    return TolyTabs(
      showDivider: false,
      labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
      tabs: items,
      activeId: _activeId,
      onSelect: (menu) => context.go(menu.id),
    );
  }

  @override
  void onChangeRoute(String path) {
    String first = Uri.parse(path).pathSegments.first;
    _activeId = "/$first";
    setState(() {});
  }
}

class HoveTextButton extends StatefulWidget {
  final String text;
  final VoidCallback onPress;

  const HoveTextButton({
    super.key,
    required this.text,
    required this.onPress,
  });

  @override
  State<HoveTextButton> createState() => _HoveTextButtonState();
}

class _HoveTextButtonState extends State<HoveTextButton> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.text);
  }
}
