import 'package:flutter/material.dart';

import 'rx.dart';
import 'window_respond_builder.dart';

/// 便捷响应式组件：只区分移动端/桌面端两种布局
///
/// ```dart
/// Rx$(
///   mobile: (ctx) => MobileHomePage(),
///   desktop: (ctx) => DesktopHomePage(),
/// )
/// ```
class Rx$ extends StatelessWidget {
  final WidgetBuilder mobile;
  final WidgetBuilder desktop;

  const Rx$({
    super.key,
    required this.mobile,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return WindowRespondBuilder(
      builder: (context, rx) =>
          rx.isDesktop ? desktop(context) : mobile(context),
    );
  }
}
