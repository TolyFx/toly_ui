
import 'dart:io';

import 'package:flutter/material.dart';

import '../slide_transition/cupertino_back_gesture_detector.dart';


class ZeroPageRoute<T> extends MaterialPageRoute<T> {
  final Widget child;


  ZeroPageRoute({
    required this.child,
    super.settings
  }) : super(builder: (_) => child);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (Platform.isIOS) {
      child = CupertinoBackGestureDetector(
        enabledCallback: () => isPopGestureEnabled<T>(this),
        onStartPopGesture: () => startPopGesture<T>(this),
        child: child,
      );
    }
    return child;
  }

  @override
  Duration get transitionDuration => Duration.zero;
}

class ZeroPage<T> extends Page<T> {
  /// Creates a material page.
  const ZeroPage({
    required this.child,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.allowSnapshotting = true,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  /// The content to be shown in the [Route] created by this page.
  final Widget child;

  /// {@macro flutter.widgets.ModalRoute.maintainState}
  final bool maintainState;

  /// {@macro flutter.widgets.PageRoute.fullscreenDialog}
  final bool fullscreenDialog;

  /// {@macro flutter.widgets.TransitionRoute.allowSnapshotting}
  final bool allowSnapshotting;

  @override
  Route<T> createRoute(BuildContext context) {
    return ZeroPageRoute(child: child,settings: this);
  }
}