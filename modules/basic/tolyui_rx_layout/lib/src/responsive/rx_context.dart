import 'package:flutter/material.dart';

import 'rx.dart';
import 'window_respond_builder.dart';

/// 便捷扩展：从 BuildContext 直接获取当前 Rx 断点级别
///
/// ```dart
/// if (context.rx.isDesktop) { ... }
/// ```
extension RxContext on BuildContext {
  /// 当前窗口宽度对应的 Rx 断点
  Rx get rx {
    final width = MediaQuery.sizeOf(this).width;
    final strategy = Theme.of(this).extension<ReParserStrategyTheme>()?.parserStrategy
        ?? defaultParserStrategy;
    return strategy(width);
  }
}
