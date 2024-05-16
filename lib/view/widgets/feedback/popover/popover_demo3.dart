import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tolyui_feedback/toly_popover/callback.dart';

import 'package:tolyui_feedback/toly_popover/toly_popover.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import '../../../debugger/debugger.dart';

class PopoverDemo3 extends StatelessWidget {
  const PopoverDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 40,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        buildDisplay1(),
        buildDisplay2(),

        // Spacer(),
      ],
    );
  }

  Widget buildDisplay2() {
    String message =
        '21 世纪伟大的编程者、诗人、文学家、思想家。代表作有 《捷特诗集》、《幻将录》、《代码之海》、《Flutter 系列著作》等。';
    return TolyPopover(
      placement: Placement.top,
      maxWidth: 240,
      overlayDecorationBuilder: (_) => BoxDecoration(
        gradient: LinearGradient(transform: GradientRotation(pi / 4), colors: [
          Colors.blue,
          Colors.brown,
          Colors.green,
          Colors.red,
        ]),
        borderRadius: BorderRadius.circular(4),
      ),
      overlay: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
        child: Text(
          message,
          style: TextStyle(fontSize: 13, color: Colors.white),
        ),
      ),
      builder: (_, ctrl, __) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(onTap: ctrl.open, child: const Text('张风捷特烈')),
        );
      },
    );
  }

  Widget buildDisplay1() {
    return
    TolyPopover(
      placement: Placement.rightStart,
      maxWidth: 260,
      overlay: const _DisplayPanel(),
      overlayDecorationBuilder: decorationBuilder,
      offsetCalculator: calculatorOffset,
      builder: (_, ctrl, __) {
        return GestureDetector(
          onTap: ctrl.open,
          child: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/icon_head.webp'),
          ),
        );
      },
    );
  }

  Offset calculatorOffset(Calculator calculator){
    double x = calculator.boxSize.width / 2 + calculator.gap;
    double y = calculator.boxSize.height / 2;
    return Offset(-x, y);
  }

  Decoration decorationBuilder(PopoverDecoration decoration){
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.black.withOpacity(0.1)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          offset: const Offset(0, 2),
          blurRadius: 6,
          spreadRadius: 0,
        )
      ],
      borderRadius: BorderRadius.circular(4),
    );
  }
}

class _DisplayPanel extends StatelessWidget {
  const _DisplayPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/images/icon_head.webp'),
              ),
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '张风捷特烈',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '微信号: zdl1994328',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '地区: 安徽·合肥',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.only(top: 24.0),
            child: Wrap(
              spacing: 20,
              children: [
                DebugDisplayButton(info: '发消息'),
                DebugDisplayButton(info: '联系我',type: DebugButtonType.fillDisplay,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
