Map<String,dynamic> get displayNodes => {
  'ButtonDemo1': {
    'title': '填充样式',
    'desc': '按钮的填充样式。通过 FillButtonPalette 调色形成样式, 提供 elevation 设置按钮的阴影深度，默认为 0。',
    'code': """class ButtonDemo1 extends StatelessWidget {
  const ButtonDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return Wrap(
      spacing: 20,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text("Conform"),
          style: ButtonPalette(
            palette: const Palette(
              normal: Color(0xff1890ff),
              hover: Color(0xff40a9ff),
              foreground: Colors.white,
              pressed: Color(0xff096dd9),
            ),
          ).fillStyle,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text("Delete"),
          style: ButtonPalette(
            borderRadius: BorderRadius.circular(40),
            palette: const Palette(
              normal: Color(0xfff56c6c),
              hover: Color(0xfff89898),
              foreground: Colors.white,
              pressed: Color(0xffc45656),
            ),
          ).fillStyle,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text("Success"),
          style: ButtonPalette(
            elevation: 2,
            palette: const Palette(
              normal: Color(0xfff67c23a),
              hover: Color(0xff95d475),
              foreground: Colors.white,
              pressed: Color(0xff529b2e),
            ),
          ).fillStyle,
        ),
      ],
    );
  }
}
"""
  },
  'ButtonDemo2': {
    'title': '边线样式',
    'desc': '按钮的边线样式。通过 OutlineButtonPalette 调色形成样式, dashGap 可以指定虚线的间隔。',
    'code': """class ButtonDemo2 extends StatelessWidget {
  const ButtonDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text("Cancel"),
          style: ButtonPalette(
            palette: const Palette(
              normal: Color(0xff1890ff),
              hover: Color(0xffecf5ff),
              foreground: Color(0xff606266),
              pressed: Color(0xff096dd9),
            ),
          ).outlineStyle,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text("Cancel"),
          style: ButtonPalette(
            borderRadius: BorderRadius.circular(40),
            palette: const Palette(
              normal: Color(0xff1890ff),
              hover: Color(0xffecf5ff),
              foreground: Color(0xff606266),
              pressed: Color(0xff096dd9),
            ),
          ).outlineStyle,
        ),
      ],
    );
  }
}"""
  },
  'ButtonDemo3': {
    'title': '具有图标的按钮',
    'desc': '按钮的 child 可以通过 Wrap 组件包裹若干个孩子。',
    'code': """class ButtonDemo2 extends StatelessWidget {
  const ButtonDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text("Cancel"),
          style: ButtonPalette(
            palette: const Palette(
              normal: Color(0xff1890ff),
              hover: Color(0xffecf5ff),
              foreground: Color(0xff606266),
              pressed: Color(0xff096dd9),
            ),
          ).outlineStyle,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text("Cancel"),
          style: ButtonPalette(
            borderRadius: BorderRadius.circular(40),
            palette: const Palette(
              normal: Color(0xff1890ff),
              hover: Color(0xffecf5ff),
              foreground: Color(0xff606266),
              pressed: Color(0xff096dd9),
            ),
          ).outlineStyle,
        ),
      ],
    );
  }
}"""
  },
  'ButtonDemo4': {
    'title': '禁用按钮',
    'desc': '按钮的 onPressed 回调为 null 时，表示禁用按钮。',
    'code': """class ButtonDemo2 extends StatelessWidget {
  const ButtonDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text("Cancel"),
          style: ButtonPalette(
            palette: const Palette(
              normal: Color(0xff1890ff),
              hover: Color(0xffecf5ff),
              foreground: Color(0xff606266),
              pressed: Color(0xff096dd9),
            ),
          ).outlineStyle,
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text("Cancel"),
          style: ButtonPalette(
            borderRadius: BorderRadius.circular(40),
            palette: const Palette(
              normal: Color(0xff1890ff),
              hover: Color(0xffecf5ff),
              foreground: Color(0xff606266),
              pressed: Color(0xff096dd9),
            ),
          ).outlineStyle,
        ),
      ],
    );
  }
}"""
  },
};