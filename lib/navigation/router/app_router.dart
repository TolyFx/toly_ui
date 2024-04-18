import 'package:app_boot_starter/app_boot_starter.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/view/home_page/home_page.dart';
import 'package:toly_ui/view/widgets/widget_navigation_scope.dart';

import '../../main.dart';
import '../../view/ecological/ecological_page.dart';
import '../../view/guide/guide_page.dart';
import '../../view/sponsor/sponsor_page.dart';
import '../../view/widgets/basic/button/button_display_page.dart';
import '../../view/widgets/basic/layout/layout_display_page.dart';
import '../../view/widgets/basic/link/link_display_page.dart';
import '../../view/widgets/widgets_page.dart';
import '../view/app_navigation_scope.dart';
import 'desk_router.dart';

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
          ShellRoute(
              builder: (BuildContext context, GoRouterState state, Widget child) {
                return WidgetNavigationScope(
                  child: child,
                );
              },
              routes: [
            GoRoute(
              path: 'widgets',
              builder: (BuildContext context, GoRouterState state) {
                return WidgetsPage();
              },
              routes: [
                GoRoute(
                  path: 'basic',
                  builder: (BuildContext context, GoRouterState state) {
                    return EcologicalPage();
                  },
                  routes: [
                    GoRoute(
                      path: 'button',
                      builder: (BuildContext context, GoRouterState state) {
                        return ButtonDisplayPage();
                      },
                    ),
                    GoRoute(
                      path: 'layout',
                      builder: (BuildContext context, GoRouterState state) {
                        return LayoutDisPlayPage();
                      },
                    ),
                    GoRoute(
                      path: 'link',
                      builder: (BuildContext context, GoRouterState state) {
                        return LinkDisplayPage();
                      },
                    ),
                  ]
                ),
              ]
            ),
          ]),

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
    // GoRoute(
    //   path: 'start_error',
    //   builder: (BuildContext context, GoRouterState state) {
    //     return AppStartFixListener<AppState>(
    //       child: ErrorPage(
    //         error: state.extra.toString(),
    //       ),
    //     );
    //   },
    // ),
    // deskNavRoute
  ],
);
