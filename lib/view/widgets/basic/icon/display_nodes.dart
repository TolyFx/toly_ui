Map<String,dynamic> displayNodes = {
  'IconDemo1': {
    'title': '用于显示一个图标',
    'desc': 'Icon 组件使用 Flutter 框架内部的组件。',
    'code': """class IconDemo1 extends StatelessWidget {
  const IconDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 20,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(Icons.security, color: Colors.orange, size: 60),
        Icon(Icons.android, color: Colors.green, size: 100),
        Icon(Icons.tab_unselected_outlined, color: Colors.blue, size: 100),
      ],
    );
  }
}"""
  },
};