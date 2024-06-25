import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/view/widgets/widget_display_page/widget_display_page.dart';
import 'package:toly_ui/view/widgets/widget_navigation_scope.dart';

import '../../view/ecological/ecological_page.dart';
import '../../view/widgets/overview/overview_page.dart';
import '../../view/widgets/widgets_page.dart';
import '../view/empty404/widget404.dart';

RouteBase get widgetsRoute => ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return WidgetNavigationScope(
            child: child,
          );
        },
        routes: [
          GoRoute(path: 'widgets', redirect: _widgetRedirect, routes: [
            GoRoute(
              path: "overview",
              builder: (BuildContext context, GoRouterState state) {
                return OverviewPage();
              },
            ),
            GoRoute(
                path: "navigation",
                builder: (BuildContext context, GoRouterState state) {
                  return WidgetsPage();
                },
                routes: [
                  _customRoute('breadcrumb'),
                  _customRoute('rail_menu_bar'),
                  _customRoute('rail_menu_tree'),
                  _customRoute('drop_menu'),
                  _customRoute('tabs'),
                ]),
            GoRoute(
                path: 'basic',
                builder: (BuildContext context, GoRouterState state) {
                  return EcologicalPage();
                },
                routes: [
                  _customRoute('action'),
                  _customRoute('button'),
                  _customRoute('icon'),
                  _customRoute('layout'),
                  _customRoute('link'),
                  _customRoute('text'),
                ]),
            GoRoute(
                path: 'form',
                builder: (BuildContext context, GoRouterState state) {
                  return EcologicalPage();
                },
                routes: [
                  _customRoute('input'),
                  _customRoute('select'),
                ]),
            GoRoute(
                path: 'data',
                builder: (BuildContext context, GoRouterState state) {
                  return EcologicalPage();
                },
                routes: [
                  _customRoute('avatar'),
                  _customRoute('pagination'),
                  _customRoute('badge'),
                  _customRoute('image'),
                  _customRoute('statistics'),
                  _customRoute('collapse'),
                  _customRoute('segmented'),
                  _customRoute('card'),
                  _customRoute('tag'),
                  _customRoute('slideshow'),
                ]),
            GoRoute(
                path: 'feedback',
                builder: (BuildContext context, GoRouterState state) {
                  return EcologicalPage();
                },
                routes: [
                  _customRoute('popover'),
                  _customRoute('tooltip'),
                  _customRoute('message'),
                  _customRoute('notification'),
                  _customRoute('shortcuts'),
                ]),
            GoRoute(
              path: '404',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return CustomTransitionPage(
                    key: ValueKey(state.extra),
                    // transitionDuration: const Duration(milliseconds: 500),
                    // reverseTransitionDuration: const Duration(milliseconds: 500),
                    child: Widget404(),
                    transitionsBuilder: (BuildContext context, Animation<double> animation,
                        Animation<double> secondaryAnimation, Widget child) {
                      return CupertinoPageTransition(
                        primaryRouteAnimation: animation,
                        secondaryRouteAnimation: secondaryAnimation,
                        linearTransition: true,
                        child: child,
                      );
                    });
              },
            ),
          ]),
        ]);

String? _widgetRedirect(_, state) {
  if (state.fullPath == '/widgets') {
    return '/widgets/overview';
  }
  return null;
}

GoRoute _customRoute(String path) => GoRoute(
      path: path,
      builder: (BuildContext context, GoRouterState state) {
        return WidgetDisplayPage(
          name: path,
        );
      },
    );
