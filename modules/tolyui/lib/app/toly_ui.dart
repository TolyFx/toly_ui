// import 'package:flutter/material.dart';
// import 'package:tolyui/tolyui.dart';
//
//
// class TolyUiApp extends StatefulWidget {
//   final MessageHandler? handler;
//
//   /// {@macro flutter.widgets.widgetsApp.navigatorKey}
//   final GlobalKey<NavigatorState>? navigatorKey;
//
//   /// A key to use when building the [ScaffoldMessenger].
//   ///
//   /// If a [scaffoldMessengerKey] is specified, the [ScaffoldMessenger] can be
//   /// directly manipulated without first obtaining it from a [BuildContext] via
//   /// [ScaffoldMessenger.of]: from the [scaffoldMessengerKey], use the
//   /// [GlobalKey.currentState] getter.
//   final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
//
//   /// {@macro flutter.widgets.widgetsApp.home}
//   final Widget? home;
//
//   /// The application's top-level routing table.
//   ///
//   /// When a named route is pushed with [Navigator.pushNamed], the route name is
//   /// looked up in this map. If the name is present, the associated
//   /// [widgets.WidgetBuilder] is used to construct a [MaterialPageRoute] that
//   /// performs an appropriate transition, including [Hero] animations, to the
//   /// new route.
//   ///
//   /// {@macro flutter.widgets.widgetsApp.routes}
//   final Map<String, WidgetBuilder>? routes;
//
//   /// {@macro flutter.widgets.widgetsApp.initialRoute}
//   final String? initialRoute;
//
//   /// {@macro flutter.widgets.widgetsApp.onGenerateRoute}
//   final RouteFactory? onGenerateRoute;
//
//   /// {@macro flutter.widgets.widgetsApp.onGenerateInitialRoutes}
//   final InitialRouteListFactory? onGenerateInitialRoutes;
//
//   /// {@macro flutter.widgets.widgetsApp.onUnknownRoute}
//   final RouteFactory? onUnknownRoute;
//
//   /// {@macro flutter.widgets.widgetsApp.onNavigationNotification}
//   final NotificationListenerCallback<NavigationNotification>? onNavigationNotification;
//
//   /// {@macro flutter.widgets.widgetsApp.navigatorObservers}
//   final List<NavigatorObserver>? navigatorObservers;
//
//   /// {@macro flutter.widgets.widgetsApp.routeInformationProvider}
//   final RouteInformationProvider? routeInformationProvider;
//
//   /// {@macro flutter.widgets.widgetsApp.routeInformationParser}
//   final RouteInformationParser<Object>? routeInformationParser;
//
//   /// {@macro flutter.widgets.widgetsApp.routerDelegate}
//   final RouterDelegate<Object>? routerDelegate;
//
//   /// {@macro flutter.widgets.widgetsApp.backButtonDispatcher}
//   final BackButtonDispatcher? backButtonDispatcher;
//
//   /// {@macro flutter.widgets.widgetsApp.routerConfig}
//   final RouterConfig<Object>? routerConfig;
//
//   /// {@macro flutter.widgets.widgetsApp.builder}
//   ///
//   /// Material specific features such as [showDialog] and [showMenu], and widgets
//   /// such as [Tooltip], [PopupMenuButton], also require a [Navigator] to properly
//   /// function.
//   final TransitionBuilder? builder;
//
//   /// {@macro flutter.widgets.widgetsApp.title}
//   ///
//   /// This value is passed unmodified to [WidgetsApp.title].
//   final String title;
//
//   /// {@macro flutter.widgets.widgetsApp.onGenerateTitle}
//   ///
//   /// This value is passed unmodified to [WidgetsApp.onGenerateTitle].
//   final GenerateAppTitle? onGenerateTitle;
//
//   /// Default visual properties, like colors fonts and shapes, for this app's
//   /// material widgets.
//   ///
//   /// A second [darkTheme] [ThemeData] value, which is used to provide a dark
//   /// version of the user interface can also be specified. [themeMode] will
//   /// control which theme will be used if a [darkTheme] is provided.
//   ///
//   /// The default value of this property is the value of [ThemeData.light()].
//   ///
//   /// See also:
//   ///
//   ///  * [themeMode], which controls which theme to use.
//   ///  * [MediaQueryData.platformBrightness], which indicates the platform's
//   ///    desired brightness and is used to automatically toggle between [theme]
//   ///    and [darkTheme] in [MaterialApp].
//   ///  * [ThemeData.brightness], which indicates the [Brightness] of a theme's
//   ///    colors.
//   final ThemeData? theme;
//
//   /// The [ThemeData] to use when a 'dark mode' is requested by the system.
//   ///
//   /// Some host platforms allow the users to select a system-wide 'dark mode',
//   /// or the application may want to offer the user the ability to choose a
//   /// dark theme just for this application. This is theme that will be used for
//   /// such cases. [themeMode] will control which theme will be used.
//   ///
//   /// This theme should have a [ThemeData.brightness] set to [Brightness.dark].
//   ///
//   /// Uses [theme] instead when null. Defaults to the value of
//   /// [ThemeData.light()] when both [darkTheme] and [theme] are null.
//   ///
//   /// See also:
//   ///
//   ///  * [themeMode], which controls which theme to use.
//   ///  * [MediaQueryData.platformBrightness], which indicates the platform's
//   ///    desired brightness and is used to automatically toggle between [theme]
//   ///    and [darkTheme] in [MaterialApp].
//   ///  * [ThemeData.brightness], which is typically set to the value of
//   ///    [MediaQueryData.platformBrightness].
//   final ThemeData? darkTheme;
//
//   /// The [ThemeData] to use when 'high contrast' is requested by the system.
//   ///
//   /// Some host platforms (for example, iOS) allow the users to increase
//   /// contrast through an accessibility setting.
//   ///
//   /// Uses [theme] instead when null.
//   ///
//   /// See also:
//   ///
//   ///  * [MediaQueryData.highContrast], which indicates the platform's
//   ///    desire to increase contrast.
//   final ThemeData? highContrastTheme;
//
//   /// The [ThemeData] to use when a 'dark mode' and 'high contrast' is requested
//   /// by the system.
//   ///
//   /// Some host platforms (for example, iOS) allow the users to increase
//   /// contrast through an accessibility setting.
//   ///
//   /// This theme should have a [ThemeData.brightness] set to [Brightness.dark].
//   ///
//   /// Uses [darkTheme] instead when null.
//   ///
//   /// See also:
//   ///
//   ///  * [MediaQueryData.highContrast], which indicates the platform's
//   ///    desire to increase contrast.
//   final ThemeData? highContrastDarkTheme;
//
//   /// Determines which theme will be used by the application if both [theme]
//   /// and [darkTheme] are provided.
//   ///
//   /// If set to [ThemeMode.system], the choice of which theme to use will
//   /// be based on the user's system preferences. If the [MediaQuery.platformBrightnessOf]
//   /// is [Brightness.light], [theme] will be used. If it is [Brightness.dark],
//   /// [darkTheme] will be used (unless it is null, in which case [theme]
//   /// will be used.
//   ///
//   /// If set to [ThemeMode.light] the [theme] will always be used,
//   /// regardless of the user's system preference.
//   ///
//   /// If set to [ThemeMode.dark] the [darkTheme] will be used
//   /// regardless of the user's system preference. If [darkTheme] is null
//   /// then it will fallback to using [theme].
//   ///
//   /// The default value is [ThemeMode.system].
//   ///
//   /// See also:
//   ///
//   ///  * [theme], which is used when a light mode is selected.
//   ///  * [darkTheme], which is used when a dark mode is selected.
//   ///  * [ThemeData.brightness], which indicates to various parts of the
//   ///    system what kind of theme is being used.
//   final ThemeMode? themeMode;
//
//   /// The duration of animated theme changes.
//   ///
//   /// When the theme changes (either by the [theme], [darkTheme] or [themeMode]
//   /// parameters changing) it is animated to the new theme over time.
//   /// The [themeAnimationDuration] determines how long this animation takes.
//   ///
//   /// To have the theme change immediately, you can set this to [Duration.zero].
//   ///
//   /// The default is [kThemeAnimationDuration].
//   ///
//   /// See also:
//   ///   [themeAnimationCurve], which defines the curve used for the animation.
//   final Duration themeAnimationDuration;
//
//   /// The curve to apply when animating theme changes.
//   ///
//   /// The default is [Curves.linear].
//   ///
//   /// This is ignored if [themeAnimationDuration] is [Duration.zero].
//   ///
//   /// See also:
//   ///   [themeAnimationDuration], which defines how long the animation is.
//   final Curve themeAnimationCurve;
//
//   /// {@macro flutter.widgets.widgetsApp.color}
//   final Color? color;
//
//   /// {@macro flutter.widgets.widgetsApp.locale}
//   final Locale? locale;
//
//   /// {@macro flutter.widgets.widgetsApp.localizationsDelegates}
//   ///
//   /// Internationalized apps that require translations for one of the locales
//   /// listed in [GlobalMaterialLocalizations] should specify this parameter
//   /// and list the [supportedLocales] that the application can handle.
//   ///
//   /// ```dart
//   /// // The GlobalMaterialLocalizations and GlobalWidgetsLocalizations
//   /// // classes require the following import:
//   /// // import 'package:flutter_localizations/flutter_localizations.dart';
//   ///
//   /// const MaterialApp(
//   ///   localizationsDelegates: <LocalizationsDelegate<Object>>[
//   ///     // ... app-specific localization delegate(s) here
//   ///     GlobalMaterialLocalizations.delegate,
//   ///     GlobalWidgetsLocalizations.delegate,
//   ///   ],
//   ///   supportedLocales: <Locale>[
//   ///     Locale('en', 'US'), // English
//   ///     Locale('he', 'IL'), // Hebrew
//   ///     // ... other locales the app supports
//   ///   ],
//   ///   // ...
//   /// )
//   /// ```
//   ///
//   /// ## Adding localizations for a new locale
//   ///
//   /// The information that follows applies to the unusual case of an app
//   /// adding translations for a language not already supported by
//   /// [GlobalMaterialLocalizations].
//   ///
//   /// Delegates that produce [WidgetsLocalizations] and [MaterialLocalizations]
//   /// are included automatically. Apps can provide their own versions of these
//   /// localizations by creating implementations of
//   /// [LocalizationsDelegate<WidgetsLocalizations>] or
//   /// [LocalizationsDelegate<MaterialLocalizations>] whose load methods return
//   /// custom versions of [WidgetsLocalizations] or [MaterialLocalizations].
//   ///
//   /// For example: to add support to [MaterialLocalizations] for a locale it
//   /// doesn't already support, say `const Locale('foo', 'BR')`, one first
//   /// creates a subclass of [MaterialLocalizations] that provides the
//   /// translations:
//   ///
//   /// ```dart
//   /// class FooLocalizations extends MaterialLocalizations {
//   ///   FooLocalizations();
//   ///   @override
//   ///   String get okButtonLabel => 'foo';
//   ///   // ...
//   ///   // lots of other getters and methods to override!
//   /// }
//   /// ```
//   ///
//   /// One must then create a [LocalizationsDelegate] subclass that can provide
//   /// an instance of the [MaterialLocalizations] subclass. In this case, this is
//   /// essentially just a method that constructs a `FooLocalizations` object. A
//   /// [SynchronousFuture] is used here because no asynchronous work takes place
//   /// upon "loading" the localizations object.
//   ///
//   /// ```dart
//   /// // continuing from previous example...
//   /// class FooLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
//   ///   const FooLocalizationsDelegate();
//   ///   @override
//   ///   bool isSupported(Locale locale) {
//   ///     return locale == const Locale('foo', 'BR');
//   ///   }
//   ///   @override
//   ///   Future<FooLocalizations> load(Locale locale) {
//   ///     assert(locale == const Locale('foo', 'BR'));
//   ///     return SynchronousFuture<FooLocalizations>(FooLocalizations());
//   ///   }
//   ///   @override
//   ///   bool shouldReload(FooLocalizationsDelegate old) => false;
//   /// }
//   /// ```
//   ///
//   /// Constructing a [MaterialApp] with a `FooLocalizationsDelegate` overrides
//   /// the automatically included delegate for [MaterialLocalizations] because
//   /// only the first delegate of each [LocalizationsDelegate.type] is used and
//   /// the automatically included delegates are added to the end of the app's
//   /// [localizationsDelegates] list.
//   ///
//   /// ```dart
//   /// // continuing from previous example...
//   /// const MaterialApp(
//   ///   localizationsDelegates: <LocalizationsDelegate<Object>>[
//   ///     FooLocalizationsDelegate(),
//   ///   ],
//   ///   // ...
//   /// )
//   /// ```
//   /// See also:
//   ///
//   ///  * [supportedLocales], which must be specified along with
//   ///    [localizationsDelegates].
//   ///  * [GlobalMaterialLocalizations], a [localizationsDelegates] value
//   ///    which provides material localizations for many languages.
//   ///  * The Flutter Internationalization Tutorial,
//   ///    <https://flutter.dev/to/internationalization/>.
//   final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
//
//   /// {@macro flutter.widgets.widgetsApp.localeListResolutionCallback}
//   ///
//   /// This callback is passed along to the [WidgetsApp] built by this widget.
//   final LocaleListResolutionCallback? localeListResolutionCallback;
//
//   /// {@macro flutter.widgets.LocaleResolutionCallback}
//   ///
//   /// This callback is passed along to the [WidgetsApp] built by this widget.
//   final LocaleResolutionCallback? localeResolutionCallback;
//
//   /// {@macro flutter.widgets.widgetsApp.supportedLocales}
//   ///
//   /// It is passed along unmodified to the [WidgetsApp] built by this widget.
//   ///
//   /// See also:
//   ///
//   ///  * [localizationsDelegates], which must be specified for localized
//   ///    applications.
//   ///  * [GlobalMaterialLocalizations], a [localizationsDelegates] value
//   ///    which provides material localizations for many languages.
//   ///  * The Flutter Internationalization Tutorial,
//   ///    <https://flutter.dev/to/internationalization/>.
//   final Iterable<Locale> supportedLocales;
//
//   /// Turns on a performance overlay.
//   ///
//   /// See also:
//   ///
//   ///  * <https://flutter.dev/to/performance-overlay>
//   final bool showPerformanceOverlay;
//
//   /// Turns on checkerboarding of raster cache images.
//   final bool checkerboardRasterCacheImages;
//
//   /// Turns on checkerboarding of layers rendered to offscreen bitmaps.
//   final bool checkerboardOffscreenLayers;
//
//   /// Turns on an overlay that shows the accessibility information
//   /// reported by the framework.
//   final bool showSemanticsDebugger;
//
//   /// {@macro flutter.widgets.widgetsApp.debugShowCheckedModeBanner}
//   final bool debugShowCheckedModeBanner;
//
//   /// {@macro flutter.widgets.widgetsApp.shortcuts}
//   /// {@tool snippet}
//   /// This example shows how to add a single shortcut for
//   /// [LogicalKeyboardKey.select] to the default shortcuts without needing to
//   /// add your own [Shortcuts] widget.
//   ///
//   /// Alternatively, you could insert a [Shortcuts] widget with just the mapping
//   /// you want to add between the [WidgetsApp] and its child and get the same
//   /// effect.
//   ///
//   /// ```dart
//   /// Widget build(BuildContext context) {
//   ///   return WidgetsApp(
//   ///     shortcuts: <ShortcutActivator, Intent>{
//   ///       ... WidgetsApp.defaultShortcuts,
//   ///       const SingleActivator(LogicalKeyboardKey.select): const ActivateIntent(),
//   ///     },
//   ///     color: const Color(0xFFFF0000),
//   ///     builder: (BuildContext context, Widget? child) {
//   ///       return const Placeholder();
//   ///     },
//   ///   );
//   /// }
//   /// ```
//   /// {@end-tool}
//   /// {@macro flutter.widgets.widgetsApp.shortcuts.seeAlso}
//   final Map<ShortcutActivator, Intent>? shortcuts;
//
//   /// {@macro flutter.widgets.widgetsApp.actions}
//   /// {@tool snippet}
//   /// This example shows how to add a single action handling an
//   /// [ActivateAction] to the default actions without needing to
//   /// add your own [Actions] widget.
//   ///
//   /// Alternatively, you could insert a [Actions] widget with just the mapping
//   /// you want to add between the [WidgetsApp] and its child and get the same
//   /// effect.
//   ///
//   /// ```dart
//   /// Widget build(BuildContext context) {
//   ///   return WidgetsApp(
//   ///     actions: <Type, Action<Intent>>{
//   ///       ... WidgetsApp.defaultActions,
//   ///       ActivateAction: CallbackAction<Intent>(
//   ///         onInvoke: (Intent intent) {
//   ///           // Do something here...
//   ///           return null;
//   ///         },
//   ///       ),
//   ///     },
//   ///     color: const Color(0xFFFF0000),
//   ///     builder: (BuildContext context, Widget? child) {
//   ///       return const Placeholder();
//   ///     },
//   ///   );
//   /// }
//   /// ```
//   /// {@end-tool}
//   /// {@macro flutter.widgets.widgetsApp.actions.seeAlso}
//   final Map<Type, Action<Intent>>? actions;
//
//   /// {@macro flutter.widgets.widgetsApp.restorationScopeId}
//   final String? restorationScopeId;
//
//   /// {@template flutter.material.materialApp.scrollBehavior}
//   /// The default [ScrollBehavior] for the application.
//   ///
//   /// [ScrollBehavior]s describe how [Scrollable] widgets behave. Providing
//   /// a [ScrollBehavior] can set the default [ScrollPhysics] across
//   /// an application, and manage [Scrollable] decorations like [Scrollbar]s and
//   /// [GlowingOverscrollIndicator]s.
//   /// {@endtemplate}
//   ///
//   /// When null, defaults to [MaterialScrollBehavior].
//   ///
//   /// See also:
//   ///
//   ///  * [ScrollConfiguration], which controls how [Scrollable] widgets behave
//   ///    in a subtree.
//   final ScrollBehavior? scrollBehavior;
//
//   /// Turns on a [GridPaper] overlay that paints a baseline grid
//   /// Material apps.
//   ///
//   /// Only available in debug mode.
//   ///
//   /// See also:
//   ///
//   ///  * <https://material.io/design/layout/spacing-methods.html>
//   final bool debugShowMaterialGrid;
//
//   /// {@macro flutter.widgets.widgetsApp.useInheritedMediaQuery}
//   @Deprecated(
//       'This setting is now ignored. '
//           'MaterialApp never introduces its own MediaQuery; the View widget takes care of that. '
//           'This feature was deprecated after v3.7.0-29.0.pre.'
//   )
//   final bool useInheritedMediaQuery;
//
//   /// Used to override the theme animation curve and duration.
//   ///
//   /// If [AnimationStyle.duration] is provided, it will be used to override
//   /// the theme animation duration in the underlying [AnimatedTheme] widget.
//   /// If it is null, then [themeAnimationDuration] will be used. Otherwise,
//   /// defaults to 200ms.
//   ///
//   /// If [AnimationStyle.curve] is provided, it will be used to override
//   /// the theme animation curve in the underlying [AnimatedTheme] widget.
//   /// If it is null, then [themeAnimationCurve] will be used. Otherwise,
//   /// defaults to [Curves.linear].
//   ///
//   /// To disable the theme animation, use [AnimationStyle.noAnimation].
//   ///
//   /// {@tool dartpad}
//   /// This sample showcases how to override the theme animation curve and
//   /// duration in the [MaterialApp] widget using [AnimationStyle].
//   ///
//   /// ** See code in examples/api/lib/material/app/app.0.dart **
//   /// {@end-tool}
//   final AnimationStyle? themeAnimationStyle;
//
//   const TolyUiApp({
//     super.key,
//     this.handler,
//     this.navigatorKey,
//     this.scaffoldMessengerKey,
//     this.home,
//     Map<String, WidgetBuilder> this.routes = const <String, WidgetBuilder>{},
//     this.initialRoute,
//     this.onGenerateRoute,
//     this.onGenerateInitialRoutes,
//     this.onUnknownRoute,
//     this.onNavigationNotification,
//     List<NavigatorObserver> this.navigatorObservers = const <NavigatorObserver>[],
//     this.builder,
//     this.title = '',
//     this.onGenerateTitle,
//     this.color,
//     this.theme,
//     this.darkTheme,
//     this.highContrastTheme,
//     this.highContrastDarkTheme,
//     this.themeMode = ThemeMode.system,
//     this.themeAnimationDuration = kThemeAnimationDuration,
//     this.themeAnimationCurve = Curves.linear,
//     this.locale,
//     this.localizationsDelegates,
//     this.localeListResolutionCallback,
//     this.localeResolutionCallback,
//     this.supportedLocales = const <Locale>[Locale('en', 'US')],
//     this.debugShowMaterialGrid = false,
//     this.showPerformanceOverlay = false,
//     this.checkerboardRasterCacheImages = false,
//     this.checkerboardOffscreenLayers = false,
//     this.showSemanticsDebugger = false,
//     this.debugShowCheckedModeBanner = true,
//     this.shortcuts,
//     this.actions,
//     this.restorationScopeId,
//     this.scrollBehavior,
//     @Deprecated(
//         'Remove this parameter as it is now ignored. '
//             'MaterialApp never introduces its own MediaQuery; the View widget takes care of that. '
//             'This feature was deprecated after v3.7.0-29.0.pre.'
//     )
//     this.useInheritedMediaQuery = false,
//     this.themeAnimationStyle,
//   }): routeInformationProvider = null,
//         routeInformationParser = null,
//         routerDelegate = null,
//         backButtonDispatcher = null,
//         routerConfig = null;
//
//   const TolyUiApp.router({
//     super.key,
//     this.handler,
//     this.scaffoldMessengerKey,
//     this.routeInformationProvider,
//     this.routeInformationParser,
//     this.routerDelegate,
//     this.routerConfig,
//     this.backButtonDispatcher,
//     this.builder,
//     this.title = '',
//     this.onGenerateTitle,
//     this.onNavigationNotification,
//     this.color,
//     this.theme,
//     this.darkTheme,
//     this.highContrastTheme,
//     this.highContrastDarkTheme,
//     this.themeMode = ThemeMode.system,
//     this.themeAnimationDuration = kThemeAnimationDuration,
//     this.themeAnimationCurve = Curves.linear,
//     this.locale,
//     this.localizationsDelegates,
//     this.localeListResolutionCallback,
//     this.localeResolutionCallback,
//     this.supportedLocales = const <Locale>[Locale('en', 'US')],
//     this.debugShowMaterialGrid = false,
//     this.showPerformanceOverlay = false,
//     this.checkerboardRasterCacheImages = false,
//     this.checkerboardOffscreenLayers = false,
//     this.showSemanticsDebugger = false,
//     this.debugShowCheckedModeBanner = true,
//     this.shortcuts,
//     this.actions,
//     this.restorationScopeId,
//     this.scrollBehavior,
//     @Deprecated(
//         'Remove this parameter as it is now ignored. '
//             'MaterialApp never introduces its own MediaQuery; the View widget takes care of that. '
//             'This feature was deprecated after v3.7.0-29.0.pre.'
//     )
//     this.useInheritedMediaQuery = false,
//     this.themeAnimationStyle,
//   }) : assert(routerDelegate != null || routerConfig != null),
//         navigatorObservers = null,
//         navigatorKey = null,
//         onGenerateRoute = null,
//         home = null,
//         onGenerateInitialRoutes = null,
//         onUnknownRoute = null,
//         routes = null,
//         initialRoute = null;
//
//   @override
//   State<TolyUiApp> createState() => TolyUiAppState();
// }
//
// class TolyUiAppState extends State<TolyUiApp> {
//   late MessageHandler handler;
//
//   @override
//   void initState() {
//     handler = widget.handler ?? $message;
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     handler.detach();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       theme: widget.theme,
//       darkTheme: widget.darkTheme,
//       themeMode: widget.themeMode,
//       locale: widget.locale,
//       localizationsDelegates: widget.localizationsDelegates,
//       // home: Builder(
//       //   builder: (context) {
//       //     handler.attach(context);
//       //     return widget.child;
//       //   }
//       // ),
//     );
//   }
// }
