import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

class TolyUiApp extends StatefulWidget {
  final GlobalKey<NavigatorState>? navigatorKey;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final Widget? home;

  final Map<String, WidgetBuilder>? routes;

  final String? initialRoute;

  final RouteFactory? onGenerateRoute;

  final InitialRouteListFactory? onGenerateInitialRoutes;

  final RouteFactory? onUnknownRoute;

  final NotificationListenerCallback<NavigationNotification>?
      onNavigationNotification;

  final List<NavigatorObserver>? navigatorObservers;

  final RouteInformationProvider? routeInformationProvider;

  final RouteInformationParser<Object>? routeInformationParser;

  final RouterDelegate<Object>? routerDelegate;

  final BackButtonDispatcher? backButtonDispatcher;

  final RouterConfig<Object>? routerConfig;

  final TransitionBuilder? builder;

  final String? title;

  final GenerateAppTitle? onGenerateTitle;

  final ThemeData? theme;

  final ThemeData? darkTheme;

  final ThemeData? highContrastTheme;

  final ThemeData? highContrastDarkTheme;

  final ThemeMode? themeMode;

  final Duration themeAnimationDuration;

  final Curve themeAnimationCurve;

  final Color? color;

  final Locale? locale;

  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  final LocaleListResolutionCallback? localeListResolutionCallback;

  final LocaleResolutionCallback? localeResolutionCallback;

  final Iterable<Locale> supportedLocales;

  final bool showPerformanceOverlay;

  final bool checkerboardRasterCacheImages;

  final bool checkerboardOffscreenLayers;

  final bool showSemanticsDebugger;

  final bool debugShowCheckedModeBanner;

  final Map<ShortcutActivator, Intent>? shortcuts;

  final Map<Type, Action<Intent>>? actions;

  final String? restorationScopeId;

  final ScrollBehavior? scrollBehavior;

  final bool debugShowMaterialGrid;

  final AnimationStyle? themeAnimationStyle;

  const TolyUiApp({
    super.key,
    this.navigatorKey,
    this.scaffoldMessengerKey,
    this.home,
    Map<String, WidgetBuilder> this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.onNavigationNotification,
    List<NavigatorObserver> this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode = ThemeMode.system,
    this.themeAnimationDuration = kThemeAnimationDuration,
    this.themeAnimationCurve = Curves.linear,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.themeAnimationStyle,
  }) : routeInformationProvider = null,
        routeInformationParser = null,
        routerDelegate = null,
        backButtonDispatcher = null,
        routerConfig = null;

  const TolyUiApp.router({
    super.key,
    this.scaffoldMessengerKey,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.routerConfig,
    this.backButtonDispatcher,
    this.builder,
    this.title,
    this.onGenerateTitle,
    this.onNavigationNotification,
    this.color,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode = ThemeMode.system,
    this.themeAnimationDuration = kThemeAnimationDuration,
    this.themeAnimationCurve = Curves.linear,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
    this.themeAnimationStyle,
  }) : assert(routerDelegate != null || routerConfig != null),
        navigatorObservers = null,
        navigatorKey = null,
        onGenerateRoute = null,
        home = null,
        onGenerateInitialRoutes = null,
        onUnknownRoute = null,
        routes = null,
        initialRoute = null;

  @override
  State<TolyUiApp> createState() => _TolyUiAppState();
}

class _TolyUiAppState extends State<TolyUiApp> {
  MessageHandler handler = $message;

  @override
  Widget build(BuildContext context) {
    final Overlay overlay = Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(
          builder: (BuildContext ctx) {
            handler.attach(ctx);
            return widget.routerConfig == null ? app : router;
          },
        ),
      ],
    );
    Widget result = Directionality(
      textDirection: TextDirection.ltr,
      child: overlay,
    );

    return Theme(
      data: widget.theme ?? ThemeData(),
      child: TapRegionSurface(
        child: Material(
          color: Colors.transparent,
          child: result,
        ),
      ),
    );
  }

  Widget get app => MaterialApp(
        navigatorKey: widget.navigatorKey,
        scaffoldMessengerKey: widget.scaffoldMessengerKey,
        home: widget.home,
        routes: widget.routes ?? const <String, WidgetBuilder>{},
        initialRoute: widget.initialRoute,
        onGenerateRoute: widget.onGenerateRoute,
        onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
        onUnknownRoute: widget.onUnknownRoute,
        onNavigationNotification: widget.onNavigationNotification,
        navigatorObservers:
            widget.navigatorObservers ?? const <NavigatorObserver>[],
        builder: widget.builder,
        title: widget.title,
        onGenerateTitle: widget.onGenerateTitle,
        color: widget.color,
        theme: widget.theme,
        darkTheme: widget.darkTheme,
        highContrastTheme: widget.highContrastTheme,
        highContrastDarkTheme: widget.highContrastDarkTheme,
        themeMode: widget.themeMode,
        themeAnimationDuration: widget.themeAnimationDuration,
        themeAnimationCurve: widget.themeAnimationCurve,
        locale: widget.locale,
        localizationsDelegates: widget.localizationsDelegates,
        localeListResolutionCallback: widget.localeListResolutionCallback,
        localeResolutionCallback: widget.localeResolutionCallback,
        supportedLocales: widget.supportedLocales,
        debugShowMaterialGrid: widget.debugShowMaterialGrid,
        showPerformanceOverlay: widget.showPerformanceOverlay,
        checkerboardRasterCacheImages: widget.checkerboardRasterCacheImages,
        checkerboardOffscreenLayers: widget.checkerboardOffscreenLayers,
        showSemanticsDebugger: widget.showSemanticsDebugger,
        debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
        shortcuts: widget.shortcuts,
        actions: widget.actions,
        restorationScopeId: widget.restorationScopeId,
        scrollBehavior: widget.scrollBehavior,
        themeAnimationStyle: widget.themeAnimationStyle,
      );

  Widget get router => MaterialApp.router(
    scaffoldMessengerKey: widget.scaffoldMessengerKey,
    routeInformationProvider: widget.routeInformationProvider,
    routeInformationParser: widget.routeInformationParser,
    routerDelegate: widget.routerDelegate,
    routerConfig: widget.routerConfig,
    backButtonDispatcher: widget.backButtonDispatcher,
    builder: widget.builder,
    title: widget.title,
    onGenerateTitle: widget.onGenerateTitle,
    onNavigationNotification: widget.onNavigationNotification,
    theme: widget.theme,
    darkTheme: widget.darkTheme,
    highContrastTheme: widget.highContrastTheme,
    highContrastDarkTheme: widget.highContrastDarkTheme,
    themeMode: widget.themeMode,
    themeAnimationDuration: widget.themeAnimationDuration,
    themeAnimationCurve: widget.themeAnimationCurve,
    locale: widget.locale,
    localizationsDelegates: widget.localizationsDelegates,
    localeListResolutionCallback: widget.localeListResolutionCallback,
    localeResolutionCallback: widget.localeResolutionCallback,
    supportedLocales: widget.supportedLocales,
    debugShowMaterialGrid: widget.debugShowMaterialGrid,
    showPerformanceOverlay: widget.showPerformanceOverlay,
    checkerboardRasterCacheImages: widget.checkerboardRasterCacheImages,
    checkerboardOffscreenLayers: widget.checkerboardOffscreenLayers,
    showSemanticsDebugger: widget.debugShowMaterialGrid,
    debugShowCheckedModeBanner: widget.showPerformanceOverlay,
    shortcuts: widget.shortcuts,
    actions: widget.actions,
    restorationScopeId: widget.restorationScopeId,
    scrollBehavior: widget.scrollBehavior,
  );

}
