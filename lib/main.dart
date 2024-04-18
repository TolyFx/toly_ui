import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/app/res/toly_icon.dart';

import 'app/logic/app_state/app_logic.dart';
import 'app/logic/app_state/app_state.dart';
import 'app/theme/theme.dart';
import 'app/view/app_scope.dart';
import 'navigation/router/app_router.dart';
import 'view/home_page/home_nav_bar.dart';

void main() {
  runApp( AppScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/home',
    routes: <RouteBase>[appRoutes],
    onException: (BuildContext ctx, GoRouterState state, GoRouter router) {
      router.go('/404', extra: state.uri.toString());
    },
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppState state = context.watch<AppLogic>().state;
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: 'TolyUI',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: state.themeMode,
      // home: const MyHomePage(title: 'TolyUI'),
    );
  }
}




