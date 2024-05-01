import 'package:flutter/material.dart';

import 'rx.dart';

typedef ReParserStrategy = Rx Function(double width);

typedef ReWidgetBuilder = Widget Function(BuildContext context, Rx type);

class WindowRespondBuilder extends StatelessWidget {
  final ReWidgetBuilder builder;
  final ReParserStrategy? parserStrategy;

  const WindowRespondBuilder({
    super.key,
    required this.builder,
    this.parserStrategy,
  });

  static Rx _defaultParserStrategy(double width) {
    if (width < 576) return Rx.xs;
    if (width >= 576 && width < 768) return Rx.sm;
    if (width >= 768 && width < 992) return Rx.md;
    if (width >= 992 && width < 1200) return Rx.lg;
    return Rx.xl;
  }

  @override
  Widget build(BuildContext context) {
    Size windowSize = MediaQuery.sizeOf(context);
    ReParserStrategy? strategy = parserStrategy ?? _defaultParserStrategy;
    return builder(context, strategy(windowSize.width));
  }
}

@immutable
class ReParserStrategyTheme extends ThemeExtension<ReParserStrategyTheme> {
  const ReParserStrategyTheme({required this.parserStrategy});

  final ReParserStrategy parserStrategy;

  @override
  ReParserStrategyTheme copyWith({
    ReParserStrategy? parserStrategy,
  }) {
    return ReParserStrategyTheme(
      parserStrategy: parserStrategy ?? this.parserStrategy,
    );
  }

  @override
  ReParserStrategyTheme lerp(
      ThemeExtension<ReParserStrategyTheme>? other, double t) {
    return this;
  }
}