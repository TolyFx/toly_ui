import 'dart:async';

import 'package:flutter/material.dart';

import '../../model/task.dart';
import '../../widget/overlay/loading_overlay.dart';
import '../message/message_mixin.dart';

typedef ErrorCallback = Function(dynamic, StackTrace?);

mixin LoadingMixin on ContextAttachable {
  OverlayEntry? entry;
  Completer<bool>? _completer;
  Timer? _timeoutTimer;

  Future<T?> loadingTask<T>({
    required Task<T> task,
    Duration timeout = const Duration(seconds: 10),
    Color? backgroundColor,
    Widget? body,
    ErrorCallback? onError,
  }) async {
    T? result;
    _timeoutTimer = Timer(timeout, () {
      closeLoading();
      onError?.call('Task Timeout!', null);
    });
    try {
      loading(backgroundColor: backgroundColor, body: body);
      result = await task();
    } catch (e, t) {
      onError?.call(e, t);
    }
    closeLoading();
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
    return result;
  }

  void loading({
    Color? backgroundColor,
    Widget? body,
  }) {
    final OverlayState state = Overlay.of(context);
    _completer = Completer();
    entry = OverlayEntry(
      builder: (BuildContext ctx) {
        return LoadingOverlay(
          completer: _completer!,
          color: backgroundColor,
          child: body ?? DefaultLoading(),
          close: () => entry?.remove(),
        );
      },
    );
    state.insert(entry!);
  }

  void closeLoading() {
    if (_completer?.isCompleted ?? false) return;
    _completer?.complete(true);
  }
}

class DefaultLoading extends StatelessWidget {
  const DefaultLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      direction: Axis.vertical,
      children: [
        CircularProgressIndicator(
          strokeWidth: 2,
        ),
        Text(
          'Loading',
          style: TextStyle(color: Theme.of(context).primaryColor),
        )
      ],
    );
  }
}
