Map<String,dynamic> get displayNodes => {
  'InputDemo1': {
    'title': '基础用法',
    'desc': '通过 Flutter 内置的 TextField 组件展示输入框。',
    'code': """class InputDemo1 extends StatelessWidget {
  const InputDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    double height = 32;
    TextStyle style = const TextStyle(fontSize: 14, height: 1);
    double width = 1;
    Color focusedColor = Colors.blue;
    Color unFocusedColor = const Color(0xffd9d9d9);
    OutlineInputBorder focusedBorder = OutlineInputBorder(borderSide: BorderSide(color: focusedColor, width: width));
    OutlineInputBorder border = OutlineInputBorder(borderSide: BorderSide(color: unFocusedColor, width: width));

    return SizedBox(
        width: 250,
        child: TextField(
          cursorHeight: style.fontSize,
          cursorWidth: 1,
          style: style,
          decoration: InputDecoration(
            hintText: 'please input',
            hintStyle: style.copyWith(color: unFocusedColor),
            constraints: BoxConstraints.tight(Size(0, height)),
            contentPadding: EdgeInsets.only(top: 0,right: 12,left: 12),
            focusedBorder: focusedBorder,
            enabledBorder: border,
            hoverColor: focusedColor,
            border: border,
          ),
        ));
  }
}"""
  },
  'InputDemo2': {
    'title': '禁用输入',
    'desc': 'enabled 置为 false 可禁用输入',
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
  'InputDemo3': {
    'title': '组合输入框',
    'desc': '可以通过 Wrap/Row 等组件，组合输入框和其他组件。如下：前置标签',
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