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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: widget.theme,
      darkTheme: widget.darkTheme,
      themeMode: widget.themeMode,
      locale: widget.locale,
      localizationsDelegates: widget.localizationsDelegates,
      home: Builder(
        builder: (context) {
          handler.attach(context);
          return widget.child;
        }
      ),
    );
  }
}
