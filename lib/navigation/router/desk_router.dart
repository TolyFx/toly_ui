//
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:toly_menu_manager/view/menu_router_scope.dart';
//
// import '../../view/home_page/home_page.dart';
// import '../menu/menu_repository_impl.dart';
// import '../view/app_desk_navigation.dart';
// import 'transition/fade_page_transitions_builder.dart';
//
// final RouteBase deskNavRoute = ShellRoute(
//     builder: (BuildContext context, GoRouterState state, Widget child) {
//       return MenuRouterScope(
//         repository: AsyncMenuRepositoryImpl(),
//         child: AppDeskNavigation(content: child),
//       );
//     },
//     routes: [
//       GoRoute(
//           path: 'dashboard',
//           redirect: (_, state) {
//             if (state.fullPath == '/dashboard') {
//               return '/dashboard/home';
//             }
//             return null;
//           },
//           routes: [
//             GoRoute(
//               path: 'home',
//               builder: (BuildContext context, GoRouterState state) {
//                 return const HomePage();
//               },
//             ),
//             GoRoute(
//               path: 'collect',
//               builder: (BuildContext context, GoRouterState state) {
//                 return const HomePage();
//               },
//             )
//           ]),
//       GoRoute(
//         path: 'calc',
//         builder: (_,__)=>Text("暂未实现"),
//         routes: [
//           GoRoute(
//             path: 'calculator',
//             builder: (BuildContext context, GoRouterState state) {
//               return HomePage();
//             },
//           ),
//           // GoRoute(
//           //   path: 'date',
//           //   builder: (BuildContext context, GoRouterState state) {
//           //     return DateCalculator();
//           //   },
//           // ),
//         ]
//       ),
//
//       GoRoute(
//         path: 'text/gen/secret',
//         builder: (BuildContext context, GoRouterState state) {
//           return HomePage();
//         },
//       ),
//       GoRoute(
//         path: 'text/gen/word',
//         builder: (BuildContext context, GoRouterState state) {
//           return HomePage();
//         },
//       ),
//       GoRoute(
//         path: 'text/:name',
//         pageBuilder: (BuildContext context, GoRouterState state) {
//           return CustomTransitionPage(
//             key: ValueKey(state.uri.path),
//               // transitionDuration: const Duration(milliseconds: 500),
//               // reverseTransitionDuration: const Duration(milliseconds: 500),
//               child: Text(''),
//               transitionsBuilder: (BuildContext context,
//                   Animation<double> animation,
//                   Animation<double> secondaryAnimation,
//                   Widget child) {
//                 return FadeTransition(
//                   opacity: animation.drive(CurveTween(curve: Curves.easeIn)),
//                   child: child,
//                 );
//               });
//         },
//       ),
//     ]);
