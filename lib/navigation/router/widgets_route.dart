import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/view/widgets/feedback/message/message_display_page.dart';
import 'package:toly_ui/view/widgets/feedback/popover/popover_display_page.dart';
import 'package:toly_ui/view/widgets/widget_navigation_scope.dart';

import '../../view/ecological/ecological_page.dart';
import '../../view/widgets/basic/button/button_display_page.dart';
import '../../view/widgets/feedback/notification/notification_display_page.dart';
import '../../view/widgets/feedback/tooltip/tooltip_display_page.dart';
import '../../view/widgets/basic/icon/icon_display_page.dart';
import '../../view/widgets/basic/layout/layout_display_page.dart';
import '../../view/widgets/basic/link/link_display_page.dart';
import '../../view/widgets/basic/text/text_display_page.dart';
import '../../view/widgets/form/input/input_display_page.dart';
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
          GoRoute(
              path: 'widgets',
              builder: (BuildContext context, GoRouterState state) {
                return WidgetsPage();
              },
              routes: [
                GoRoute(
                    path: "dashboard",
                    builder: (BuildContext context, GoRouterState state) {
                      return WidgetsPage();
                    },
                    routes: [
                      GoRoute(
                        path: 'overview',
                        builder: (BuildContext context, GoRouterState state) {
                          return OverviewPage();
                        },
                      ),
                      GoRoute(
                        path: 'statistics',
                        builder: (BuildContext context, GoRouterState state) {
                          return IconDisplayPage();
                        },
                      ),
                    ]),
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
                        path: 'icon',
                        builder: (BuildContext context, GoRouterState state) {
                          return IconDisplayPage();
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
                      GoRoute(
                        path: 'text',
                        builder: (BuildContext context, GoRouterState state) {
                          return TextDisplayPage();
                        },
                      ),
                    ]),
                GoRoute(
                    path: 'form',
                    builder: (BuildContext context, GoRouterState state) {
                      return EcologicalPage();
                    },
                    routes: [
                      GoRoute(
                        path: 'input',
                        builder: (BuildContext context, GoRouterState state) {
                          return InputDisplayPage();
                        },
                      ),
                      GoRoute(
                        path: 'icon',
                        builder: (BuildContext context, GoRouterState state) {
                          return IconDisplayPage();
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
                      GoRoute(
                        path: 'text',
                        builder: (BuildContext context, GoRouterState state) {
                          return TextDisplayPage();
                        },
                      ),
                    ]),
                GoRoute(
                    path: 'feedback',
                    builder: (BuildContext context, GoRouterState state) {
                      return EcologicalPage();
                    },
                    routes: [
                      GoRoute(
                        path: 'popover',
                        builder: (BuildContext context, GoRouterState state) {
                          return PopoverDisplayPage();
                        },
                      ),
                      GoRoute(
                        path: 'tooltip',
                        builder: (BuildContext context, GoRouterState state) {
                          return TooltipDisplayPage();
                        },
                      ),
                      GoRoute(
                        path: 'message',
                        builder: (BuildContext context, GoRouterState state) {
                          return MessageDisplayPage();
                        },
                      ),     GoRoute(
                        path: 'notification',
                        builder: (BuildContext context, GoRouterState state) {
                          return NotificationDisplayPage();
                        },
                      ),
                    ]),
                GoRoute(
                  path: '404',
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return CustomTransitionPage(
                        key: ValueKey(state.extra),
                        // transitionDuration: const Duration(milliseconds: 500),
                        // reverseTransitionDuration: const Duration(milliseconds: 500),
                        child: Widget404(),
                        transitionsBuilder: (BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child) {
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
