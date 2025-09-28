import 'dart:async';

import 'package:flutter/material.dart';
import 'status.dart';

typedef Task<T> = FutureOr<T> Function();

extension TaskExe<T> on Task<T> {
  Future<T?> execute({
    Duration? duration,
    OnStatusChange<T>? onStatusChange,
  }) {
    Duration duration = Duration(seconds: 5);
    return doTask(duration, onStatusChange).timeout(
      duration,
      onTimeout: () {
        onStatusChange?.call(Timeout(duration));
        return null;
      },
    );
  }

  Future<T?> doTask(
    Duration? duration,
    OnStatusChange<T>? onStatusChange,
  ) async {
    T? data;
    onStatusChange?.call(const Loading());
    try {
      data = await call();
      onStatusChange?.call(Success(data));
    } catch (e, s) {
      onStatusChange?.call(Failure(e, s));
    }
    return data;
  }
}

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
