import 'package:flutter/material.dart';

class LayoutDisPlayPage extends StatelessWidget {
  const LayoutDisPlayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleShow(
                title: '基础布局',
                desc: '通过基础的 24 分栏，迅速简便地创建布局。',
              ),

              Column(
                // direction: Axis.vertical,
                children: [
                  Row$(
                    cells: [
                      RowCell(
                          span: 24,
                          child: _LayoutCell(
                            color: Color(0xff99a9bf),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row$(
                    cells: [
                      RowCell(
                          span: 12,
                          child: _LayoutCell(
                            color: Color(0xffd3dce6),
                          )),
                      RowCell(
                          span: 12,
                          child: _LayoutCell(
                            color: Color(0xffe5e9f2),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row$(
                    cells: [
                      RowCell(
                          span: 8,
                          child: _LayoutCell(
                            color: Color(0xffd3dce6),
                          )),
                      RowCell(
                          span: 8,
                          child: _LayoutCell(
                            color: Color(0xffe5e9f2),
                          )),
                      RowCell(
                          span: 8,
                          child: _LayoutCell(
                            color: Color(0xffd3dce6),
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row$(
                    cells: [
                      RowCell(
                          span: 6,
                          child: _LayoutCell(
                            color: Color(0xffd3dce6),
                          )),
                      RowCell(
                          span: 6,
                          child: _LayoutCell(
                            color: Color(0xffe5e9f2),
                          )),
                      RowCell(
                          span: 6,
                          child: _LayoutCell(
                            color: Color(0xffd3dce6),
                          )),
                      RowCell(
                          span: 6,
                          child: _LayoutCell(
                            color: Color(0xffe5e9f2),
                          )),
                    ],
                  ),
                ],
              ),
              // Divider(),

              TitleShow(
                title: '分栏间隔',
                desc: '提供 gutter 属性来指定列之间的间距，其默认值为0。',
              ),

              Row$(
                gutter: 20,
                cells: [
                  RowCell(
                      span: 6,
                      child: _LayoutCell(
                        color: Color(0xffd3dce6),
                      )),
                  RowCell(
                      span: 6,
                      child: _LayoutCell(
                        color: Color(0xffe5e9f2),
                      )),
                  RowCell(
                      span: 6,
                      child: _LayoutCell(
                        color: Color(0xffd3dce6),
                      )),
                  RowCell(
                      span: 6,
                      child: _LayoutCell(
                        color: Color(0xffe5e9f2),
                      )),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                "通过 reGutter 支持间隔随窗口的响应式变化。",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),

              Row$(
                reGutter: {
                  Re.xs: 10,
                  Re.sm: 20,
                  Re.md: 30,
                  Re.lg: 40,
                  Re.xl: 50,
                },
                cells: [
                  RowCell(
                      span: 6,
                      child: _LayoutCell(
                        color: Color(0xffd3dce6),
                      )),
                  RowCell(
                      span: 6,
                      child: _LayoutCell(
                        color: Color(0xffe5e9f2),
                      )),
                  RowCell(
                      span: 6,
                      child: _LayoutCell(
                        color: Color(0xffd3dce6),
                      )),
                  RowCell(
                      span: 6,
                      child: _LayoutCell(
                        color: Color(0xffd3dce6),
                      )),
                ],
              ),
              TitleShow(
                title: '响应式布局',
                desc: '参照了 Bootstrap 的 响应式设计，预设了五个响应尺寸：xs、sm、md、lg 和 xl。',
              ),
              Row$(
                gutter: 20,
                cells: [
                  RowCell.respond(
                      reSpan: {
                        Re.xs: 8,
                        Re.sm: 6,
                        Re.md: 4,
                        Re.lg: 3,
                        Re.xl: 1,
                      },
                      child: _LayoutCell(
                        color: Color(0xffd3dce6),
                      )),
                  RowCell.respond(
                      reSpan: {
                        Re.xs: 4,
                        Re.sm: 6,
                        Re.md: 8,
                        Re.lg: 9,
                        Re.xl: 11,
                      },
                      child: _LayoutCell(
                        color: Color(0xffe5e9f2),
                      )),
                  RowCell.respond(
                      reSpan: {
                        Re.xs: 12,
                        Re.sm: 6,
                        Re.md: 8,
                        Re.lg: 9,
                        Re.xl: 11,
                      },
                      child: _LayoutCell(
                        color: Color(0xffd3dce6),
                      )),
                  RowCell.respond(
                      reSpan: {
                        Re.xs: 0,
                        Re.sm: 6,
                        Re.md: 4,
                        Re.lg: 3,
                        Re.xl: 1,
                      },
                      child: _LayoutCell(
                        color: Color(0xffd3dce6),
                      )),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              TitleShow(
                title: '混合布局',
                desc: '通过基础的 1/24 分栏任意扩展组合形成较为复杂的混合布局。',
              ),

              Row$(
                gutter: 20,
                cells: [
                  RowCell(
                      span: 16,
                      child: _LayoutCell(
                        color: Color(0xff99a9bf),
                      )),
                  RowCell(
                      span: 8,
                      child: _LayoutCell(
                        color: Color(0xff99a9bf),
                      )),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row$(
                gutter: 20,
                cells: [
                  RowCell(
                      span: 8,
                      child: _LayoutCell(
                        color: Color(0xffd3dce6),
                      )),
                  RowCell(
                      span: 8,
                      child: _LayoutCell(
                        color: Color(0xffe5e9f2),
                      )),
                  RowCell(
                      span: 4,
                      child: _LayoutCell(
                        color: Color(0xffe5e9f2),
                      )),
                  RowCell(
                      span: 4,
                      child: _LayoutCell(
                        color: Color(0xffe5e9f2),
                      )),
                ],
              ),

              const SizedBox(
                height: 12,
              ),

              Row$(
                gutter: 20,
                cells: [
                  RowCell(
                      span: 4,
                      child: _LayoutCell(
                        color: Color(0xffd3dce6),
                      )),
                  RowCell(
                      span: 16,
                      child: _LayoutCell(
                        color: Color(0xffe5e9f2),
                      )),
                  RowCell(
                      span: 4,
                      child: _LayoutCell(
                        color: Color(0xffd3dce6),
                      )),
                ],
              ),

              const SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleShow extends StatelessWidget {
  final String title;
  final String desc;

  const TitleShow({super.key, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            desc,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _LayoutCell extends StatelessWidget {
  final Color color;
  final String? text;

  const _LayoutCell({super.key, required this.color, this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      child: text != null ? Text(text!) : null,
      decoration:
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
    );
  }
}

class Row$ extends StatelessWidget {
  final List<RowCell> cells;
  final double gutter;
  final Map<Re, double>? reGutter;

  const Row$({super.key, required this.cells, this.gutter = 0, this.reGutter});

  @override
  Widget build(BuildContext context) {
    return WindowRespondBuilder(
      builder: (BuildContext context, Re type) {
        List<Widget> children = [];

        int totalSpan = 0;
        for (int i = 0; i < cells.length; i++) {
          RowCell cell = cells[i];
          Widget child = cell.child;

          int? span;

          if (cell.reSpan != null) {
            span = cell.reSpan![type];

            /// 如果未设置该响应式的 span
            span ??= cell.reSpan!.values.first;
          }
          span = span ?? cell.span;

          if (span != 0) {
            children.add(Expanded(
              flex: span,
              child: child,
            ));

            double? gutter = this.gutter;
            if (reGutter != null && reGutter!.isNotEmpty) {
              gutter = reGutter![type];
            }

            if (gutter != 0) {
              children.add(SizedBox(width: gutter));
            }
          }
          totalSpan += span;
        }

        if (totalSpan < 24) {
          children.add(Spacer(
            flex: 24 - totalSpan,
          ));
        }
        return Row(
          children: children,
        );
      },
    );
  }
}

// typedef ReParser<T> = T Function(Re re, T value);

class RowCell {
  final Map<Re, int>? reSpan;
  final int span;
  final Widget child;

  RowCell({
    required this.span,
    required this.child,
    this.reSpan,
  });

  RowCell.respond({
    required this.reSpan,
    required this.child,
  })
      : span = 0,
        assert(reSpan != null && reSpan.isNotEmpty);
}

/// r: Respond
enum Re {
  xs, // (超小屏): < 576px
  sm, // (小屏幕): 576px(含) - 768px
  md, // (中屏幕): 768px(含) - 992px
  lg, // lg(大屏幕): 992px(含) - 1200px
  xl, // xl(超大屏幕): > 1200px(含)
}

typedef ReParserStrategy = Re Function(double width);

typedef ReWidgetBuilder = Widget Function(BuildContext context, Re type);

class WindowRespondBuilder extends StatelessWidget {
  final ReWidgetBuilder builder;
  final ReParserStrategy? parserStrategy;

  const WindowRespondBuilder({
    super.key,
    required this.builder,
    this.parserStrategy,
  });

  static Re _defaultParserStrategy(double width) {
    if (width < 576) return Re.xs;
    if (width >= 576 && width < 768) return Re.sm;
    if (width >= 768 && width < 992) return Re.md;
    if (width >= 992 && width < 1200) return Re.lg;
    return Re.xl;
  }

  @override
  Widget build(BuildContext context) {
    Size windowSize = MediaQuery.sizeOf(context);
    ReParserStrategy? strategy = parserStrategy ?? _defaultParserStrategy;
    return builder(context, strategy(windowSize.width));
  }
}

// class ReParserStrategyTheme {
//   final ReParserStrategy? parserStrategy;
//
//   ReParserStrategyTheme(this.parserStrategy);
// }
//
// @immutable
// class ReParserStrategy extends ThemeExtension<ReParserStrategy>{
//
// }
// ReParserTneme

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
  ReParserStrategyTheme lerp(ThemeExtension<ReParserStrategyTheme>? other,
      double t) {
    return this;
  }
}




