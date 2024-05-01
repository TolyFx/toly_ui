
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/navigation/view/empty404/widget404.dart';
import 'package:toly_ui/view/home_page/home_page.dart';
import 'package:toly_ui/view/widgets/basic/text/text_display_page.dart';
import 'package:toly_ui/view/widgets/widget_navigation_scope.dart';

import '../../view/ecological/ecological_page.dart';
import '../../view/guide/guide_page.dart';
import '../../view/sponsor/sponsor_page.dart';
import '../../view/widgets/basic/button/button_display_page.dart';
import '../../view/widgets/basic/icon/icon_display_page.dart';
import '../../view/widgets/basic/layout/layout_display_page.dart';
import '../../view/widgets/basic/link/link_display_page.dart';
import '../../view/widgets/widgets_page.dart';
import '../view/app_navigation_scope.dart';
import 'widgets_route.dart';

 RouteBase get appRoutes => GoRoute(
  path: '/',
  redirect: (_, __) => null,
  routes: [
    ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return AppNavigationScope(
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: 'home',
            builder: (BuildContext context, GoRouterState state) {
              return HomePage();
            },
          ),
          GoRoute(
            path: 'guide',
            builder: (BuildContext context, GoRouterState state) {
              return GuidePage();
            },
          ),
          GoRoute(
            path: 'sponsor',
            builder: (BuildContext context, GoRouterState state) {
              return SponsorPage();
            },
          ),
          widgetsRoute,

          GoRoute(
            path: 'ecological',
            builder: (BuildContext context, GoRouterState state) {
              return EcologicalPage();
            },
          ),
        ]),
    // GoRoute(
    //   path: 'splash',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const AppStartListener<AppState>(
    //       child: SplashPage(),
    //     );
    //   },
    // ),
    GoRoute(
      path: '404',
      builder: (BuildContext context, GoRouterState state) {
        return Widget404();
      },
    ),
    // deskNavRoute
  ],
);
