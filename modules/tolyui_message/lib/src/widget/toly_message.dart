import 'package:flutter/material.dart';

import '../logic/message.dart';
import 'theme/toly_message_style_theme.dart';

class TolyMessage extends StatefulWidget {
  final Widget child;
  final MessageHandler? handler;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode? themeMode;

  const TolyMessage({
    super.key,
    required this.child,
    this.handler,
    this.theme,
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

    return Theme(
      data: _themeBuilder(context),
      child: Material(
        color: Colors.transparent,
        child: result,
      ),
    );
  }

  ThemeData _themeBuilder(BuildContext context) {
    ThemeData? theme;
    final ThemeMode mode = widget.themeMode ?? ThemeMode.system;
    final Brightness platformBrightness = MediaQuery.platformBrightnessOf(context);
    final bool useDarkTheme = mode == ThemeMode.dark || (mode == ThemeMode.system && platformBrightness == Brightness.dark);
     if (useDarkTheme && widget.darkTheme != null) {
      theme = widget.darkTheme;
    }
    theme ??= widget.theme ?? ThemeData.light();
    return theme;
  }
}
