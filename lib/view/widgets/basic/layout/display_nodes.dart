Map<String,dynamic> displayNodes = {
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
            Cell(span: (_) => 24, child: const Box(color: Color(0xff99a9bf)))
          ],
        ),
        const SizedBox(height: 12),
        Row$(
          cells: [
            Cell(span: (_) => 12, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: (_) => 12, child: const Box(color: Color(0xffe5e9f2))),
          ],
        ),
        const SizedBox(height: 12),
        Row$(
          cells: [
            Cell(span: (_) => 8, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: (_) => 8, child: const Box(color: Color(0xffe5e9f2))),
            Cell(span: (_) => 8, child: const Box(color: Color(0xffd3dce6))),
          ],
        ),
        const SizedBox(height: 12),
        Row$(
          cells: [
            Cell(span: (_) => 6, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: (_) => 6, child: const Box(color: Color(0xffe5e9f2))),
            Cell(span: (_) => 6, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: (_) => 6, child: const Box(color: Color(0xffe5e9f2))),
          ],
        ),
      ],
    );
  }
}"""
  },
  'LayoutDemo3': {
    'title': '混合布局',
    'desc': '通过基础的 1/24 分栏任意扩展组合形成较为复杂的混合布局。',
    'code': r"""class LayoutDemo3 extends StatelessWidget {
  const LayoutDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row$(
          gutter: (_) => 20,
          cells: [
            Cell(span: (_) => 16, child: const Box(color: Color(0xff99a9bf))),
            Cell(span: (_) => 8, child: const Box(color: Color(0xff99a9bf))),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Row$(
          gutter: (_) => 20.0,
          cells: [
            Cell(span: (_) => 8, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: (_) => 8, child: const Box(color: Color(0xffe5e9f2))),
            Cell(span: (_) => 4, child: const Box(color: Color(0xffe5e9f2))),
            Cell(span: (_) => 4, child: const Box(color: Color(0xffe5e9f2))),
          ],
        ),
        const SizedBox(height: 12),
        Row$(
          gutter: (_) => 20,
          cells: [
            Cell(span: (_) => 4, child: const Box(color: Color(0xffd3dce6))),
            Cell(span: (_) => 16, child: const Box(color: Color(0xffe5e9f2))),
            Cell(span: (_) => 4, child: const Box(color: Color(0xffd3dce6))),
          ],
        ),
      ],
    );
  }
}"""
  },
  'LayoutDemo4': {
    'title': '响应式布局',
    'desc': '参照了 Bootstrap 的 响应式设计，预设了五个响应尺寸：xs、sm、md、lg 和 xl。',
    'code': r"""class LayoutDemo3 extends StatelessWidget {
  const LayoutDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return Row$(
      gutter: (_) => 20,
      cells: [
        Cell(
            span: (re) => switch (re) {
                  Re.xs => 8,
                  Re.sm => 6,
                  Re.md => 4,
                  Re.lg => 3,
                  Re.xl => 1,
                },
            child: const Box(color: Color(0xffd3dce6))),
        Cell(
            span: (re) => switch (re) {
                  Re.xs =>  4,
                  Re.sm =>  6,
                  Re.md =>  8,
                  Re.lg =>  9,
                  Re.xl => 11,
                },
            child: const Box(color: Color(0xffe5e9f2))),
        Cell(
            span: (re) => switch (re) {
                  Re.xs => 12,
                  Re.sm => 6,
                  Re.md => 8,
                  Re.lg => 9,
                  Re.xl => 11,
                },
            child: const Box(color: Color(0xffd3dce6))),
        Cell(
            span: (re) => switch (re) {
                  Re.xs=> 0,
                  Re.sm=> 6,
                  Re.md=> 4,
                  Re.lg=> 3,
                  Re.xl=> 1,
                },
            child: const Box(color: Color(0xffd3dce6))),
      ],
    );
  }
}"""
  },
  'LayoutDemo2': {
    'title': '分栏间隔',
    'desc': r'提供 gutter 属性来指定列之间的间距，该属性支持 Re 响应式变化。',
    'code': r"""class LayoutDemo2 extends StatelessWidget {
  const LayoutDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    List<Cell> cells = [
      Cell(span: (_) => 6, child: const Box(color: Color(0xffd3dce6))),
      Cell(span: (_) => 6, child: const Box(color: Color(0xffe5e9f2))),
      Cell(span: (_) => 6, child: const Box(color: Color(0xffd3dce6))),
      Cell(span: (_) => 6, child: const Box(color: Color(0xffe5e9f2))),
    ];
    return Column(
      children: [
        Row$(
          gutter: (_) => 20,
          cells: cells,
        ),
        Row$(
          gutter: (re) => switch (re) {
            Re.xs => 10.0,
            Re.sm => 20.0,
            Re.md => 30.0,
            Re.lg => 40.0,
            Re.xl => 50.0,
          },
          cells: cells,
        ),
      ],
    );
  }
}"""
  },
  'LayoutDemo5': {
    'title': '响应式尺寸盒',
    'desc': r'通过 SizedBox$ 设置具有响应式的尺寸盒',
    'code': r"""class LayoutDemo5 extends StatelessWidget {
  const LayoutDemo5({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: const Color(0xffd3dce6),
        child: SizedBox$(
            child: const Center(child: Text("宽高根据屏幕尺寸变化的盒子")),
            width: (re) => switch (re) {
                  Re.xs => 200,
                  Re.sm => 200,
                  Re.md => 300,
                  Re.lg => 400,
                  Re.xl => 500,
                },
            height: (re) => switch (re) { _ => 40.0 * (re.index + 1) }));
  }
}
"""
  },
  'LayoutDemo6': {
    'title': '响应式边距',
    'desc': r'通过 Padding$ 让边距根据屏幕尺寸变化',
    'code': r"""class LayoutDemo6 extends StatelessWidget {
  const LayoutDemo6({super.key});

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
                    Re.xs => const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    Re.sm => const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    Re.md => const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    Re.lg => const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                    Re.xl => const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  }),
        ));
  }
}"""
  },
};