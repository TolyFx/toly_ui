import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../logic/message.dart';

class TolyMessage extends StatefulWidget {
  final Widget child;
  final MessageHandler? handler;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode? themeMode;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Iterable<Locale> supportedLocales;

  const TolyMessage({
    super.key,
    required this.child,
    this.handler,
    this.theme,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.localizationsDelegates = const [],
    this.locale,
    this.darkTheme,
    this.themeMode,
  });

  @override
  State<TolyMessage> createState() => TolyMessageState();
}

class TolyMessageState extends State<TolyMessage> {
  /// 当前宿主绑定的消息处理器。
  late MessageHandler handler;

  /// 内容浮层保持身份，更新宿主内容时不重建消息调度器。
  late final OverlayEntry _content;

  @override
  void initState() {
    super.initState();
    handler = widget.handler ?? $message;
    _content = OverlayEntry(builder: _buildContent);
  }

  Widget _buildContent(BuildContext context) {
    handler.attach(context);
    return widget.child;
  }

  @override
  void didUpdateWidget(TolyMessage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final MessageHandler next = widget.handler ?? $message;
    if (next != handler) {
      handler.detach();
      handler = next;
    }
    _content.markNeedsBuild();
  }

  /// 在浮层和动画控制器销毁之前解除消息绑定。
  @override
  void deactivate() {
    handler.detach();
    super.deactivate();
  }

  @override
  void activate() {
    super.activate();
    _content.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(initialEntries: [_content]),
    );

    List<LocalizationsDelegate<dynamic>> delegates =
        widget.localizationsDelegates?.toList() ?? [];
    if (delegates.isEmpty) {
      delegates = [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];
    }
    return TapRegionSurface(
      child: Localizations(
        locale: widget.locale ?? const Locale('zh'),
        delegates: delegates,
        child: Theme(
          data: _themeBuilder(context),
          child: Material(
            color: Colors.transparent,
            child: result,
          ),
        ),
      ),
    );
  }

  ThemeData _themeBuilder(BuildContext context) {
    ThemeData? theme;
    final ThemeMode mode = widget.themeMode ?? ThemeMode.system;
    final Brightness platformBrightness =
        MediaQuery.platformBrightnessOf(context);
    final bool useDarkTheme = mode == ThemeMode.dark ||
        (mode == ThemeMode.system && platformBrightness == Brightness.dark);
    if (useDarkTheme && widget.darkTheme != null) {
      theme = widget.darkTheme;
    }
    theme ??= widget.theme ?? Theme.of(context);
    return theme;
  }
}
