import 'dart:async';

import 'package:flutter/material.dart';
import 'status.dart';

typedef Task<T> = FutureOr<T> Function();
typedef CancellableTask<T> = FutureOr<T> Function(CancelToken token);

class CancelToken {
  bool _cancelled = false;
  bool get isCancelled => _cancelled;
  void cancel() => _cancelled = true;
}

extension TaskExe<T> on Task<T> {
  Future<T?> execute({
    Duration? duration,
    OnStatusChange<T>? onStatusChange,
  }) {
    duration ??= Duration(seconds: 5);
    final cancelToken = CancelToken();
    
    return doTask(cancelToken, onStatusChange).timeout(
      duration,
      onTimeout: () {
        cancelToken.cancel();
        onStatusChange?.call(Timeout(duration!));
        return null;
      },
    );
  }

  Future<T?> doTask(
    CancelToken cancelToken,
    OnStatusChange<T>? onStatusChange,
  ) async {
    if (cancelToken.isCancelled) return null;
    
    T? data;
    onStatusChange?.call(const Loading());
    try {
      data = await call();
      if (!cancelToken.isCancelled) {
        onStatusChange?.call(Success(data));
      }
    } catch (e, s) {
      if (!cancelToken.isCancelled) {
        onStatusChange?.call(Failure(e, s));
      }
    }
    return cancelToken.isCancelled ? null : data;
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
