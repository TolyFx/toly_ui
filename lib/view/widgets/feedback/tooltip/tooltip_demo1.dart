import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tolyui/basic/basic.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';
import '../../display_nodes/display_nodes.dart';
@DisplayNode(
    title: 'Tooltip 排列方式',
    desc: 'TolyUI 中基于 Flutter 的 Tooltip 组件进行了强化。'
)
class TooltipDemo1 extends StatelessWidget {
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
              Expanded(child: buildTolyTooltipDisplay(Placement.topStart)),
              Expanded(child: buildTolyTooltipDisplay(Placement.top)),
              Expanded(child: buildTolyTooltipDisplay(Placement.topEnd)),
              // Spacer(),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            children: [
              Expanded(child: buildTolyTooltipDisplay(Placement.leftStart)),
              Expanded(child: buildTolyTooltipDisplay(Placement.left)),
              Expanded(child: buildTolyTooltipDisplay(Placement.leftEnd)),
            ],
          ),
          const SizedBox(height: 10,),

          Row(
            children: [
              Expanded(child: buildTolyTooltipDisplay(Placement.rightStart)),
              Expanded(child: buildTolyTooltipDisplay(Placement.right)),
              Expanded(child: buildTolyTooltipDisplay(Placement.rightEnd)),
            ],
          ),
          const SizedBox(height: 10,),


          Row(
            children: [
              Expanded(child: buildTolyTooltipDisplay(Placement.bottomStart)),
              Expanded(child: buildTolyTooltipDisplay(Placement.bottom)),
              Expanded(child: buildTolyTooltipDisplay(Placement.bottomEnd)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTolyTooltipDisplay(Placement placement){
    Palette foreground = const Palette(normal: Color(0xff606266), hover: Color(0xff096dd9), pressed: Color(0xff096dd9));
    Palette border = const Palette(normal: Color(0xffd9d9d9), hover: Color(0x44409eff), pressed: Color(0xff096dd9));
    Palette bg = const Palette(normal: Color(0xff1890ff), hover: Color(0xffecf5ff), pressed: Color(0xffecf5ff));
    String info = placement.toString().split('.')[1];
    info = info.substring(0,1).toUpperCase()+info.substring(1);
    return Center(
      child:
      TolyTooltip(
        textStyle: TextStyle(fontSize: 13,color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        placement: placement,
        gap: 12,
        message: '${info} \nmessage tips.',
        child: ElevatedButton(
          onPressed: () {},
          child: Text(_nameMap[placement]!),
          style: OutlineButtonPalette(
            foregroundPalette: foreground,
            borderPalette: border,
            backgroundPalette: bg,
          ).style,
        ),
      ),
    );
  }

  static const Map<Placement,String> _nameMap = {
    Placement.top: 'Top',
    Placement.topStart: 'TStart',
    Placement.topEnd: 'TEnd',
    Placement.bottomEnd: 'BEnd',
    Placement.bottom: 'Bottom',
    Placement.bottomStart: 'BStart',
    Placement.rightEnd: 'REnd',
    Placement.right: 'Right',
    Placement.rightStart: 'RStart',
    Placement.leftEnd: 'LEnd',
    Placement.left: 'Left',
    Placement.leftStart: 'LStart',
  };
}
