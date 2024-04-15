import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/app/theme/theme.dart';

import '../../app/res/toly_icon.dart';
import '../../incubator/components/toly_tab_bar.dart';

class HomeNavBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:(ctx,cts)=> AppBar(
        actions: [
          AppNavTabs(),
          const SizedBox(width: 12,),

          Transform.scale(
            scale: 0.85,
            child: Switch(value: false,
                overlayColor:  MaterialStateProperty.all(Colors.transparent),
                trackOutlineWidth: MaterialStateProperty.all(px1),
                inactiveTrackColor: Color(0xfff2f2f2),
                trackOutlineColor: MaterialStateProperty.all(Color(0xffdcdfe6)),
                thumbIcon: MaterialStateProperty.all(const Icon(Icons.light_mode,color: Color(0xff606266),)),
                thumbColor:  MaterialStateProperty.all(Colors.white),
                onChanged: (v) {

                }),
          ),
          if(cts.maxWidth>400)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.translate),
          ),
          if(cts.maxWidth>400)
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(TolyIcon.iconGithub),
            ),
          )
        ],
        leading: GestureDetector(
          onTap: (){
            context.go('/home');
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Image.asset('assets/images/logo.png')),
          ),
        ),
        titleSpacing: 0,
        title: cts.maxWidth>400? GestureDetector(
          onTap: (){
            context.go('/home');
          },
          child:Text(
            "TolyUI",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ):null,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


class AppNavTabs extends StatefulWidget {
  const AppNavTabs({super.key});

  @override
  State<AppNavTabs> createState() => _AppNavTabsState();
}

class _AppNavTabsState extends State<AppNavTabs> with RouterChangeListenerMixin{

  int _activeIndex =-1;

  final List<String> routers = ["/guide", "/widgets", "/ecological",'/sponsor'];

  @override
  Widget build(BuildContext context) {
    return TolyTabBar(
        onTap: (int value) {

          // setState(() {
          //   _activeIndex = value;
          // });
          if(value>=0){
            context.go(routers[value]);
          }
        },
        tabs: ["指南", "组件", "生态","赞助"],
        activeIndex: _activeIndex,
    );
  }


  @override
  void onChangeRoute(String path) {
    print("====onChangeRoute==${path}==========");
    _activeIndex = routers.indexOf("/$path");
    setState(() {

    });
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
  late GoRouterDelegate _delegate ;

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
    onChangeRoute(match.matchedLocation);
  }

  void onChangeRoute(String path);
}
