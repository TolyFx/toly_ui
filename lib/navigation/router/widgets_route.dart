import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/view/widgets/navigation/breadcrumb/breadcrumb_display_page.dart';
import 'package:toly_ui/view/widgets/widget_display_page/widget_display_page.dart';
import 'package:toly_ui/view/widgets/widget_navigation_scope.dart';

import '../../view/ecological/ecological_page.dart';
import '../../view/widgets/navigation/drop_menu/drop_menu_display_page.dart';
import '../../view/widgets/navigation/rail_menu_bar/rail_menu_bar_display_page.dart';
import '../../view/widgets/navigation/rail_menu_tree/rail_menu_tree_display_page.dart';
import '../../view/widgets/navigation/tabs/tabs_display_page.dart';
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
                  GoRoute(
                    path: 'breadcrumb',
                    builder: (BuildContext context, GoRouterState state) {
                      return BreadcrumbDisplayPage();
                    },
                  ),
                  GoRoute(
                    path: 'rail_menu_bar',
                    builder: (BuildContext context, GoRouterState state) {
                      return RailMenuBarDisplayPage();
                    },
                  ),
                  GoRoute(
                    path: 'rail_menu_tree',
                    builder: (BuildContext context, GoRouterState state) {
                      return RailMenuTreeDisplayPage();
                    },
                  ),
                  GoRoute(
                    path: 'drop_menu',
                    builder: (BuildContext context, GoRouterState state) {
                      return DropMenuDisplay();
                    },
                  ),
                  GoRoute(
                    path: 'tabs',
                    builder: (BuildContext context, GoRouterState state) {
                      return TabsDisplayPage();
                    },
                  ),
                ]),
            GoRoute(
                path: 'basic',
                builder: (BuildContext context, GoRouterState state) {
                  return EcologicalPage();
                },
                routes: [
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
                  _customRoute('button'),
                  _customRoute('icon'),
                  _customRoute('layout'),
                  _customRoute('link'),
                  _customRoute('text'),
                ]),
            GoRoute(
                path: 'data',
                builder: (BuildContext context, GoRouterState state) {
                  return EcologicalPage();
                },
                routes: [
                  _customRoute('statistics'),
                  _customRoute('collapse'),
                  _customRoute('segmented'),
                  _customRoute('card'),
                  _customRoute('tag'),
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
