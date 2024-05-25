import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toly_ui/incubator/ext/go_router/path.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import 'app/logic/app_state/app_logic.dart';
import 'app/logic/app_state/app_state.dart';
import 'app/theme/theme.dart';
import 'app/view/app_scope.dart';
import 'navigation/router/app_router.dart';

void main() {
  runApp(AppScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoRouter _router = GoRouter(
    initialLocation: '/home',
    routes: <RouteBase>[appRoutes],
    onException: (BuildContext ctx, GoRouterState state, GoRouter router) {
      String parent = state.uri.pathSegments.first;
      print("onException::${state.uri}==============");
      router.go('/$parent/404', extra: state.uri.toString());
    },
  );



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    AppState state = context.watch<AppLogic>().state;
    ThemeData light = lightTheme;
    ThemeData dark = darkTheme;
    ThemeMode mode = state.themeMode;
    return TolyMessage(
      theme: light,
      darkTheme: dark,
      themeMode: mode,
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        theme: light,
        darkTheme: dark,
        themeMode: mode,
        title: 'TolyUI1',
      ),
    );
  }

  @override
  void reassemble() {
    super.reassemble();
    _router = GoRouter(
      initialLocation: _router.path,
      routes: <RouteBase>[appRoutes],
      onException: (BuildContext ctx, GoRouterState state, GoRouter router) {
        String parent = state.uri.pathSegments.first;
        print("onException::${state.uri}==============");
        router.go('/$parent/404', extra: state.uri.toString());
      },
    );
  }
}
