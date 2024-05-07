Map<String, dynamic> get displayNodes => {
      'LayoutDemo1': {
        'title': '基础布局',
        'desc': '通过基础的 24 分栏，迅速简便地创建布局。',
        'code': r"""class LayoutDemo1 extends StatelessWidget {
  const LayoutDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row$(
          cells: [
            Cell(span: 24.rx, child: const Box(color: Color(0xff99a9bf)))
          ],
        ),
        const SizedBox(height: 12),
        Row$(
          cells: [
            Cell(span: 12.rx, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: 12.rx, child: const Box(color: Color(0xffe5e9f2))),
          ],
        ),
        const SizedBox(height: 12),
        Row$(
          cells: [
            Cell(span: 8.rx, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: 8.rx, child: const Box(color: Color(0xffe5e9f2))),
            Cell(span: 8.rx, child: const Box(color: Color(0xffd3dce6))),
          ],
        ),
        const SizedBox(height: 12),
        Row$(
          cells: [
            Cell(span: 6.rx, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: 6.rx, child: const Box(color: Color(0xffe5e9f2))),
            Cell(span: 6.rx, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: 6.rx, child: const Box(color: Color(0xffe5e9f2))),
          ],
        ),
      ],
    );
  }
}"""
      },
      'LayoutDemo2': {
        'title': '混合布局',
        'desc': '通过基础的 1/24 分栏任意扩展组合形成较为复杂的混合布局。',
        'code': r"""class LayoutDemo2 extends StatelessWidget {
  const LayoutDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row$(
          gutter: 20.rx,
          cells: [
            Cell(span: 16.rx, child: const Box(color: Color(0xff99a9bf))),
            Cell(span: 8.rx, child: const Box(color: Color(0xff99a9bf))),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Row$(
          gutter: 20.rx,
          cells: [
            Cell(span: 8.rx, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: 8.rx, child: const Box(color: Color(0xffe5e9f2))),
            Cell(span: 4.rx, child: const Box(color: Color(0xffe5e9f2))),
            Cell(span: 4.rx, child: const Box(color: Color(0xffe5e9f2))),
          ],
        ),
        const SizedBox(height: 12),
        Row$(
          gutter: 20.rx,
          cells: [
            Cell(span: 4.rx, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: 16.rx, child: const Box(color: Color(0xffe5e9f2))),
            Cell(span: 4.rx, child: const Box(color: Color(0xffd3dce6))),
          ],
        ),
      ],
    );
  }
}"""
      },
      'LayoutDemo3': {
        'title': '响应式布局',
        'desc':
            '参照了 Bootstrap 的 响应式设计，预设了五个响应尺阶：xs、sm、md、lg 和 xl。支持响应式的参数都可以感知尺阶设置数值，比如 span 跨度、gutter 间距等。',
        'code': r"""class LayoutDemo3 extends StatelessWidget {
  const LayoutDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return Row$(
      gutter: 20.rx,
      cells: [
        Cell(
            span: (re) => switch (re) {
                  Rx.xs => 8,
                  Rx.sm => 6,
                  Rx.md => 4,
                  Rx.lg => 3,
                  Rx.xl => 1,
                },
            child: const Box(color: Color(0xffd3dce6))),
        Cell(
            span: (re) => switch (re) {
                  Rx.xs => 4,
                  Rx.sm => 6,
                  Rx.md => 8,
                  Rx.lg => 9,
                  Rx.xl => 11,
                },
            child: const Box(color: Color(0xffe5e9f2))),
        Cell(
            span: (re) => switch (re) {
                  Rx.xs => 12,
                  Rx.sm => 6,
                  Rx.md => 8,
                  Rx.lg => 9,
                  Rx.xl => 11,
                },
            child: const Box(color: Color(0xffd3dce6))),
        Cell(
            span: (re) => switch (re) {
                  Rx.xs => 0,
                  Rx.sm => 6,
                  Rx.md => 4,
                  Rx.lg => 3,
                  Rx.xl => 1,
                },
            child: const Box(color: Color(0xffd3dce6))),
      ],
    );
  }
}"""
      },
      'LayoutDemo4': {
        'title': r'Row$：间隔与边距',
        'desc': r'提供 gutter 属性来指水平方向单元格间距；'
            r'单元格跨度总数超出 24，会自动换行，提供 verticalGutter 属性来指定列竖直方向间距；'
            r'padding 属性可以设计响应式的内边距；'
            r'这三个属性都支持 Rx 响应式变化。',
        'code': r"""class LayoutDemo4 extends StatelessWidget {
  const LayoutDemo4({super.key});

  @override
  Widget build(BuildContext context) {
    const Color color1 = Color(0xffd3dce6);
    const Color color2 = Color(0xffe5e9f2);
    return Row$(
        gutter: 16.0.rx,
        verticalGutter: 12.0.rx,
        padding: const EdgeInsets.symmetric(horizontal: 40).rx,
        cells: [
          Cell(span: 6.rx, child: const Box(color: color1, text: 'Toly')),
          Cell(span: 5.rx, child: const Box(color: color2, text: 'UI')),
          Cell(span: 7.rx, child: const Box(color: color1, text: 'Responsive')),
          Cell(span: 6.rx, child: const Box(color: color2, text: 'Layout')),
          Cell(span: 11.rx, child: const Box(color: color2, text: '11')),
          Cell(span: 4.rx, child: const Box(color: color2, text: '4')),
          Cell(span: 3.rx, child: const Box(color: color2, text: '3')),
          Cell(span: 6.rx, child: const Box(color: color2, text: '6')),
        ]);
  }
}"""
      },
'LayoutDemo5': {
        'title': r'Row$：水平对齐',
        'desc':
            r'在水平方向上，单元格有六种对齐方式，通过 justify 参数配置。它具有六种元素，下图自上而下依次是 start、end、center、spaceBetween、spaceAround、spaceEvenly: ',
        'code': r"""class LayoutDemo5 extends StatelessWidget {
  const LayoutDemo5({super.key});

  @override
  Widget build(BuildContext context) {
    const Color color1 = Color(0xffd3dce6);
    const Color color2 = Color(0xffe5e9f2);
    return Column(
      children: RxJustify.values
          .map((e) =>
          Row$(
              justify: e,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4).rx,
              cells: [
                Cell(span: 4.rx, child: const Box(color: color1)),
                Cell(span: 2.rx, child: const Box(color: color2)),
                Cell(span: 6.rx, child: const Box(color: color1)),
                Cell(span: 6.rx, child: const Box(color: color2)),
              ]))
          .toList(),
    );
  }
}"""
      },
  'LayoutDemo6': {
    'title': r'Row$：竖直对齐',
    'desc':
    r'在竖直方向上，单元格有三种对齐方式，通过 align 参数配置。下图自上而下依次是 top、bottom、middle：',
    'code': r"""class LayoutDemo6 extends StatelessWidget {
  const LayoutDemo6({super.key});

  @override
  Widget build(BuildContext context) {
    const Color color1 = Color(0xffd3dce6);
    const Color color2 = Color(0xffe5e9f2);
    return Column(
        children: RxAlign.values
        .map((e) => Row$(
        align: e,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6).rx,
        cells: [
          Cell(span: 6.rx, child: const Box(color: color1,height: 20,)),
          Cell(span: 4.rx, child: const Box(color: color2, height: 42)),
          Cell(span: 8.rx, child: const Box(color: color1, height: 52)),
          Cell(span: 6.rx, child: const Box(color: color2)),
        ]))
    .toList());
  }
}
"""
  },
  'LayoutDemo7': {
    'title': 'Cell: 列偏移',
    'desc':
    r'Cell#offset 可以指定分栏偏移的栏数，该属性支持 Rx 响应式变化。',
    'code': r"""class LayoutDemo7 extends StatelessWidget {
  const LayoutDemo7({super.key});

  @override
  Widget build(BuildContext context) {
    const Color color1 = Color(0xffd3dce6);
    const Color color2 = Color(0xffe5e9f2);
    return Column(
      children: [
        Row$(gutter: 20.0.rx, cells: [
          Cell(span: 6.rx, child: const Box(color: color1)),
          Cell(span: 6.rx, offset: 6.rx, child: const Box(color: color2)),
        ]),
        const SizedBox(height: 12),
        Row$(gutter: 20.0.rx, cells: [
          Cell(span: 6.rx, offset: 6.rx, child: const Box(color: color2)),
          Cell(span: 6.rx, offset: 6.rx, child: const Box(color: color2)),
        ]),
        const SizedBox(height: 12),
        Row$(gutter: 20.0.rx, cells: [
          Cell(span: 12.rx, offset: 6.rx, child: const Box(color: color1)),
        ]),
      ],
    );
  }
}"""
  },
  'LayoutDemo8': {
    'title': 'Cell: 列平移',
    'desc':
    r'pull 和 push 仅对对单元格进行平移，并不占据栅格空间。push 向右移动指定格数；pull 向左移动指定格数。',
    'code': r"""class LayoutDemo8 extends StatelessWidget {
  const LayoutDemo8({super.key});

  @override
  Widget build(BuildContext context) {
    const Color color1 = Color(0xffd3dce6);
    const Color color2 = Color(0xffe5e9f2);
    return Column(
      children: [
        Row$(
            gutter: 10.0.rx,
            cells: List.generate(24, (index) => Cell(span: 1.rx, child: const Box2(color: color1))).toList()),
        const SizedBox(height: 12),
        const SizedBox(height: 8),
        Row$(gutter: 10.0.rx, cells: [
          Cell(span: 6.rx, child: const Box(color: color1, text: '')),
          Cell(span: 4.rx, push: 1.rx, child: const Box2(color: color2, text: 'push#1')),
          Cell(span: 8.rx, child: const Box(color: Color(0x660000ff), text: '')),
          Cell(span: 6.rx, pull: 2.rx, child: const Box2(color: Color(0x99e5e9f2), text: 'pull#2')),
        ]),
      ],
    );
  }
}"""
  },
      'LayoutDemo9': {
        'title': '响应式尺寸盒',
        'desc': r'通过 SizedBox$ 设置具有响应式的尺寸盒',
        'code': r"""class LayoutDemo9 extends StatelessWidget {
  const LayoutDemo9({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: const Color(0xffd3dce6),
        child: SizedBox$(
            child: const Center(child: Text("宽高根据屏幕尺寸变化的盒子")),
            width: (re) => switch (re) {
                  Rx.xs => 200,
                  Rx.sm => 200,
                  Rx.md => 300,
                  Rx.lg => 400,
                  Rx.xl => 500,
                },
            height: (re) => switch (re) { _ => 40.0 * (re.index + 1) }));
  }
}"""
      },
      'LayoutDemo10': {
        'title': '响应式边距',
        'desc': r'通过 Padding$ 让边距根据屏幕尺寸变化',
        'code': r"""class LayoutDemo10 extends StatelessWidget {
  const LayoutDemo10({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: const Color(0xffd3dce6),
        child: SizedBox(
          width: 300,
          height: 150,
          child: Padding$(
              child: Container(
                  color: Colors.orange.withOpacity(0.6),
                  alignment: Alignment.center,
                  child: const Text("边距根据屏幕尺寸变化")),
              padding: (re) => switch (re) {
                    Rx.xs => const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    Rx.sm => const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    Rx.md => const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    Rx.lg => const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    Rx.xl => const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  }),
        ));
  }
}"""
      },
    };
