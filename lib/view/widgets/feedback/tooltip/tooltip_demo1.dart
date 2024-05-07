import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tolyui/basic/basic.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

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
      child:
      TolyTooltip(
        textStyle: TextStyle(fontSize: 13,color: Colors.white),
        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
        placement: placement,
        gap: 12,
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
}
