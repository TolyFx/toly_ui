import 'dart:async';

import 'package:flutter/material.dart';

import '../../model/task.dart';
import '../../widget/overlay/loading_overlay.dart';
import '../message/message_mixin.dart';

mixin LoadingMixin on ContextAttachable {
  OverlayEntry? entry;
  Completer<bool>? _completer;

  void loadingTask({Task? task}) {}

  void loading({
    Color? backgroundColor,
  }) {
    final OverlayState state = Overlay.of(context);
    _completer = Completer();
    entry = OverlayEntry(
      builder: (BuildContext ctx) {
        return LoadingOverlay(
          completer: _completer!,
          color: backgroundColor,
          child: DefaultLoading(),
          close: ()=>entry?.remove(),
        );
      },
    );
    state.insert(entry!);
  }

  void closeLoading() {
    _completer?.complete(true);
    // entry?.remove();
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
        Text('Loading',style: TextStyle(color: Theme.of(context).primaryColor),)
      ],
    );
  }
}

