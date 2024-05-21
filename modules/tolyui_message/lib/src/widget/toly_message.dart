import 'package:flutter/material.dart';

import '../logic/message.dart';

class TolyMessage extends StatefulWidget {
  final Widget child;
  final MessageHandler? handler;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode? themeMode;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  const TolyMessage({
    super.key,
    required this.child,
    this.handler,
    this.theme,
    this.localizationsDelegates = const [],
    this.locale,
    this.darkTheme,
    this.themeMode,
  });

  @override
  State<TolyMessage> createState() => TolyMessageState();
}

class TolyMessageState extends State<TolyMessage> {
  late MessageHandler handler;

  @override
  void initState() {
    handler = widget.handler ?? $message;
    super.initState();
  }

  @override
  void dispose() {
    handler.detach();
    super.dispose();
  }

  Iterable<LocalizationsDelegate<dynamic>> get _localizationsDelegates {
    return <LocalizationsDelegate<dynamic>>[
      if (widget.localizationsDelegates != null)
        ...widget.localizationsDelegates!,
      DefaultWidgetsLocalizations.delegate,
      DefaultMaterialLocalizations.delegate,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Overlay overlay = Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(
          builder: (BuildContext ctx) {
            handler.attach(ctx);
            return widget.child;
          },
        ),
      ],
    );

    Widget result = Directionality(
      textDirection: TextDirection.ltr,
      child: overlay,
    );

    return Localizations(
      locale: widget.locale ?? const Locale('en', 'US'),
      delegates: _localizationsDelegates.toList(),
      child: Theme(
        data: _themeBuilder(context),
        child: Material(
          color: Colors.transparent,
          child: result,
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
    theme ??= widget.theme ?? ThemeData.light();
    return theme;
  }
}
