import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/app/logic/actions/navigation.dart';
import 'package:toly_ui/app/theme/theme.dart';

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
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 32,
                            )),
                      ),

                          if( cts.maxWidth > 480)
                      Text(
                        "TolyUI",
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ) ,
                    ],
                  ),
                ),
              )

      ),
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
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          trackOutlineWidth: MaterialStateProperty.all(px1),
          inactiveTrackColor: const Color(0xfff2f2f2),
          activeColor: const Color(0xff2c2c2c),
          trackOutlineColor: MaterialStateProperty.all(const Color(0xffdcdfe6)),
          // thumbIcon: MaterialStateProperty.all(const Icon(
          //   Icons.light_mode,
          //   color: Color(0xff606266),
          // )),
          thumbIcon: MaterialStateProperty.all(
              isDark ? const Icon(Icons.dark_mode,color: const Color(0xff2c2c2c),)
                  : const Icon(Icons.light_mode,color: const Color(0xff2c2c2c),)),

          thumbColor: MaterialStateProperty.all(Colors.white),

          onChanged: (v) =>context.read<AppLogic>().toggleThemeModel(v)),
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
  int _activeIndex = -1;

  final List<String> routers = [
    "/guide",
    "/widgets",
    "/ecological",
    '/sponsor'
  ];

  @override
  Widget build(BuildContext context) {
    return TolyMenuBar(
      onTap: (int value) {
        if(value==1){
          context.go('/widgets/basic/layout');
          return;
        }
        if (value >= 0) {
          context.go(routers[value]);
        }
      },
      tabs: ["指南", "组件", "生态", "赞助"],
      activeIndex: _activeIndex,
    );
  }

  @override
  void onChangeRoute(String path) {
    String first = Uri.parse(path).pathSegments.first;
    _activeIndex = routers.indexOf("/$first");
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
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Text(widget.text);
  }
}

mixin RouterChangeListenerMixin<T extends StatefulWidget> on State<T> {
  late GoRouterDelegate _delegate;

  @override
  void initState() {
    super.initState();
    _delegate = GoRouter.of(context).routerDelegate;
    _delegate.addListener(_onChange);
  }

  @override
  void dispose() {
    _delegate.removeListener(_onChange);
    super.dispose();
  }

  void _onChange() {
    RouteMatchBase match = _delegate.currentConfiguration.matches.last;
    onChangeRoute("/${match.matchedLocation}");
  }

  void onChangeRoute(String path);
}
