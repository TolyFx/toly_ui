import 'dart:async';

import 'package:flutter/material.dart';

typedef Task<T> = FutureOr<T> Function();

class TolyMenuItem<T> {
  final Task<T>? task;
  final String info;
  final bool popBeforeTask;
  final Widget? content;
  final WidgetBuilder? loadingBuilder;

  TolyMenuItem({
    this.loadingBuilder,
    this.task,
    required this.info,
    this.content,
    this.popBeforeTask = false,
  });
}
