import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/navigation/view/empty404/widget404.dart';
import 'package:toly_ui/view/home_page/home_page.dart';

import '../../view/ecological/ecological_page.dart';
import '../../view/sponsor/sponsor_page.dart';
import '../view/app_navigation_scope.dart';
import 'guide_route.dart';
import 'widgets_route.dart';

enum AppRoute {
  root('/', '/'),
  home('home', '/home'),
  sponsor('sponsor', '/sponsor'),
  ecological('ecological', '/ecological'),
  error('404', '/404'),
  ;

  final String path;
  final String name;

  const AppRoute(this.name, this.path);

  void go(BuildContext context) {
    context.go(path);
  }
}

RouteBase get appRoutes => GoRoute(
      path: AppRoute.root.name,
      redirect: _widgetHome,
      routes: [
        ShellRoute(
            builder: (BuildContext context, GoRouterState state, Widget child) {
              return AppNavigationScope(
                child: child,
              );
            },
            routes: [
              GoRoute(
                path: AppRoute.home.name,
                builder: (BuildContext context, GoRouterState state) {
                  return HomePage();
                },
              ),
              // GoRoute(
              //   path: 'guide',
              //   builder: (BuildContext context, GoRouterState state) {
              //     return GuideNavigation();
              //   },
              // ),
              guideRoute,
              GoRoute(
                path: AppRoute.sponsor.name,
                builder: (BuildContext context, GoRouterState state) {
                  return SponsorPage();
                },
              ),
              widgetsRoute,
              GoRoute(
                path: AppRoute.ecological.name,
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
          path: AppRoute.error.name,
          builder: (BuildContext context, GoRouterState state) {
            return Widget404();
          },
        ),
        // deskNavRoute
      ],
    );

String? _widgetHome(_, state) {
  if (state.fullPath == '/') {
    return AppRoute.home.path;
  }
  return null;
}
