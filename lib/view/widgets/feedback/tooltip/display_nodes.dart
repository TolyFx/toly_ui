Map<String,dynamic> get displayNodes => {
  'TooltipDemo1': {
    'title': 'Tooltip 排列方式',
    'desc': 'TolyUI 中基于 Flutter 的 Tooltip 组件进行了强化。'
        '提供 9 种不同方向的展示方式，以及气泡框包裹效果。',
    'code': r"""class TooltipDemo1 extends StatelessWidget {
  const TooltipDemo1({super.key});

  @override
  Widget build(BuildContext context) {
   return SizedBox(
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Spacer(),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.topStart)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.top)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.topEnd)),
              // Spacer(),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.leftStart)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.left)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.leftEnd)),
            ],
          ),
          const SizedBox(height: 10,),

          Row(
            children: [
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.rightStart)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.right)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.rightEnd)),
            ],
          ),
          const SizedBox(height: 10,),


          Row(
            children: [
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.bottomStart)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.bottom)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.bottomEnd)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTolyTooltipDisplay(TooltipPlacement placement){
    Palette foreground = const Palette(normal: Color(0xff606266), hover: Color(0xff096dd9), pressed: Color(0xff096dd9));
    Palette border = const Palette(normal: Color(0xffd9d9d9), hover: Color(0x44409eff), pressed: Color(0xff096dd9));
    Palette bg = const Palette(normal: Color(0xff1890ff), hover: Color(0xffecf5ff), pressed: Color(0xffecf5ff));
    String info = placement.toString().split('.')[1];
    return Center(
      child: TolyTooltip(
        textStyle: TextStyle(fontSize: 13,color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        placement: placement,
        verticalOffset: 12,
        message: '${info} \nmessage tips.',
        child: ElevatedButton(
          onPressed: () {},
          child: Text(info),
          style: OutlineButtonPalette(
            foregroundPalette: foreground,
            borderPalette: border,
            backgroundPalette: bg,
          ).style,
        ),
      ),
    );
  }
}"""
  },
  'TooltipDemo2': {
    'title': 'Tooltip 富文本',
    'desc': '使用 richMessage 可以展示富文本信息。',
    'code': r"""class TooltipDemo1 extends StatelessWidget {
  const TooltipDemo1({super.key});

  @override
  Widget build(BuildContext context) {
   return SizedBox(
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Spacer(),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.topStart)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.top)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.topEnd)),
              // Spacer(),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.leftStart)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.left)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.leftEnd)),
            ],
          ),
          const SizedBox(height: 10,),

          Row(
            children: [
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.rightStart)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.right)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.rightEnd)),
            ],
          ),
          const SizedBox(height: 10,),


          Row(
            children: [
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.bottomStart)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.bottom)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.bottomEnd)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTolyTooltipDisplay(TooltipPlacement placement){
    Palette foreground = const Palette(normal: Color(0xff606266), hover: Color(0xff096dd9), pressed: Color(0xff096dd9));
    Palette border = const Palette(normal: Color(0xffd9d9d9), hover: Color(0x44409eff), pressed: Color(0xff096dd9));
    Palette bg = const Palette(normal: Color(0xff1890ff), hover: Color(0xffecf5ff), pressed: Color(0xffecf5ff));
    String info = placement.toString().split('.')[1];
    return Center(
      child: TolyTooltip(
        textStyle: TextStyle(fontSize: 13,color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        placement: placement,
        verticalOffset: 12,
        message: '${info} \nmessage tips.',
        child: ElevatedButton(
          onPressed: () {},
          child: Text(info),
          style: OutlineButtonPalette(
            foregroundPalette: foreground,
            borderPalette: border,
            backgroundPalette: bg,
          ).style,
        ),
      ),
    );
  }
}"""
  },
  'TooltipDemo3': {
    'title': 'Tooltip 样式配置',
    'desc': '可以通过 decorationConfig、textStyle、textAlign、padding 等配置弹出内容样式; gap 参数设置弹出框与组件的间隔; exitDuration 参数设置移除浮层的延迟时长。',
    'code': r"""class TooltipDemo1 extends StatelessWidget {
  const TooltipDemo1({super.key});

  @override
  Widget build(BuildContext context) {
   return SizedBox(
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Spacer(),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.topStart)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.top)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.topEnd)),
              // Spacer(),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.leftStart)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.left)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.leftEnd)),
            ],
          ),
          const SizedBox(height: 10,),

          Row(
            children: [
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.rightStart)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.right)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.rightEnd)),
            ],
          ),
          const SizedBox(height: 10,),


          Row(
            children: [
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.bottomStart)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.bottom)),
              Expanded(child: buildTolyTooltipDisplay(TooltipPlacement.bottomEnd)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTolyTooltipDisplay(TooltipPlacement placement){
    Palette foreground = const Palette(normal: Color(0xff606266), hover: Color(0xff096dd9), pressed: Color(0xff096dd9));
    Palette border = const Palette(normal: Color(0xffd9d9d9), hover: Color(0x44409eff), pressed: Color(0xff096dd9));
    Palette bg = const Palette(normal: Color(0xff1890ff), hover: Color(0xffecf5ff), pressed: Color(0xffecf5ff));
    String info = placement.toString().split('.')[1];
    return Center(
      child: TolyTooltip(
        textStyle: TextStyle(fontSize: 13,color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        placement: placement,
        verticalOffset: 12,
        message: '${info} \nmessage tips.',
        child: ElevatedButton(
          onPressed: () {},
          child: Text(info),
          style: OutlineButtonPalette(
            foregroundPalette: foreground,
            borderPalette: border,
            backgroundPalette: bg,
          ).style,
        ),
      ),
    );
  }
}"""
  },
};