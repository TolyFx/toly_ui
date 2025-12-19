import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageStyle {
  final IconData icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;

  const MessageStyle({
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
  });
}

class TolyMessageStyleTheme extends ThemeExtension<TolyMessageStyleTheme> {
  final MessageStyle successStyle;
  final MessageStyle infoStyle;
  final MessageStyle errorStyle;
  final MessageStyle warningStyle;
  final BorderRadius? borderRadius;
  final BorderRadius? noticeBorderRadius;
  final bool? plain;
  final bool? closeable;

  TolyMessageStyleTheme({
    required this.successStyle,
    required this.infoStyle,
    required this.errorStyle,
    required this.warningStyle,
    this.plain = false,
    this.closeable = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.noticeBorderRadius = const BorderRadius.all(Radius.circular(4)),
  });

  TolyMessageStyleTheme.tolyuiLight({
    this.successStyle = const MessageStyle(
      backgroundColor: Color(0xfff0f9eb),
      foregroundColor: Color(0xff67c23a),
      borderColor: Color(0xffebf6e5),
      icon: Icons.check_circle_rounded,
    ),
    this.infoStyle = const MessageStyle(
      backgroundColor: Color(0xfff4f4f5),
      borderColor: Color(0xffeeeef0),
      foregroundColor: Colors.black,
      icon: CupertinoIcons.info,
    ),
    this.errorStyle = const MessageStyle(
      backgroundColor: Color(0xfffef0f0),
      foregroundColor: Color(0xfff56c6c),
      borderColor: Color(0xfffde2e2),
      icon: CupertinoIcons.clear_thick_circled,
    ),
    this.warningStyle = const MessageStyle(
      backgroundColor: Color(0xfffdf6ec),
      foregroundColor: Color(0xffe6a23c),
      borderColor: Color(0xfffbf0e1),
      icon: Icons.error,
    ),
    this.plain = false,
    this.closeable = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.noticeBorderRadius = const BorderRadius.all(Radius.circular(4)),
  });

  TolyMessageStyleTheme.tolyuiDark({
    this.successStyle = const MessageStyle(
      backgroundColor: Color(0xff1c2518),
      foregroundColor: Color(0xff67c23a),
      borderColor: Color(0xff1f2c19),
      icon: Icons.check_circle_rounded,
    ),
    this.infoStyle = const MessageStyle(
      backgroundColor: Color(0xff202121),
      borderColor: Color(0xff272729),
      foregroundColor: Color(0xff909399),
      icon: CupertinoIcons.info,
    ),
    this.errorStyle = const MessageStyle(
      backgroundColor: Color(0xff2b1d1d),
      foregroundColor: Color(0xfff56c6c),
      borderColor: Color(0xff3b2424),
      icon: CupertinoIcons.clear_thick_circled,
    ),
    this.warningStyle = const MessageStyle(
      backgroundColor: Color(0xff292218),
      foregroundColor: Color(0xffe6a23c),
      borderColor: Color(0xff2e2519),
      icon: Icons.error,
    ),
    this.plain = false,
    this.closeable = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.noticeBorderRadius = const BorderRadius.all(Radius.circular(4)),

  });

  @override
  TolyMessageStyleTheme copyWith({
    MessageStyle? successStyle,
    MessageStyle? infoStyle,
    MessageStyle? errorStyle,
    MessageStyle? warningStyle,
    BorderRadius? borderRadius,
    BorderRadius? noticeBorderRadius,
    bool? plain,
    bool? closeable,
  }) {
    return TolyMessageStyleTheme(
      successStyle: successStyle ?? this.successStyle,
      infoStyle: infoStyle ?? this.infoStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      warningStyle: warningStyle ?? this.warningStyle,
      plain: plain ?? this.plain,
      closeable: closeable ?? this.closeable,
      borderRadius: borderRadius ?? this.borderRadius,
      noticeBorderRadius: noticeBorderRadius ?? this.noticeBorderRadius,
    );
  }

  @override
  TolyMessageStyleTheme lerp(TolyMessageStyleTheme? other, double t) => this;
}

// class Default
