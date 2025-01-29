import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';
import 'package:toly_ui/view/debugger/display/debug_display_tile.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '阴影模式',
  desc: 'TolyCard 的阴影展示有 always, hover, never 三种样式：',
)
class CardDemo3 extends StatelessWidget {
  const CardDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    List<BoxShadow> shadows = [
      BoxShadow(
        color: Colors.blue.withOpacity(0.04),
        blurRadius: 8,
        spreadRadius: 2,
        offset: const Offset(0, 0),
      ),
      BoxShadow(
        color: Colors.blue.withOpacity(0.08),
        blurRadius: 6,
        spreadRadius: 4,
        offset: Offset(0, 2),
      ),
    ];
    return Wrap(
      spacing: 12,
      children: [
        SizedBox(
          width: 100,
          child: TolyCard(
              shadowMode: ShadowMode.always,
              shadows: shadows,
              child: DebugDisplayTile(
                title: 'always',
                centerTitle: true,
                content: '总是会展示阴影效果',
                foot: '阴影模式',
              )),
        ),
        SizedBox(
          width: 100,
          child: TolyCard(
              shadowMode: ShadowMode.hover,
              shadows: shadows,
              child: DebugDisplayTile(
                title: 'hover',
                centerTitle: true,
                content: '悬浮时展示阴影效果',
                foot: '阴影模式',
              )),
        ),
        SizedBox(
          width: 100,
          child: TolyCard(
              shadowMode: ShadowMode.never,
              shadows: shadows,
              child: DebugDisplayTile(
                title: 'never',
                centerTitle: true,
                content: '永不展示阴影效果',
                foot: '阴影模式',
              )),
        ),
      ],
    );
  }
}
