import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toly_ui/view/debugger/debugger.dart';
import 'package:tolyui/basic/basic.dart';
import 'package:tolyui_feedback/toly_popover/toly_popover.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';
import '../../display_nodes/display_nodes.dart';

@DisplayNode(
  title: 'Popover 对齐方式',
  desc: 'TolyPopover 提供 12 种不同方向的展示方式，以及气泡框包裹效果。',
)
class PopoverDemo4 extends StatelessWidget {
  const PopoverDemo4({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: buildDisplay(Placement.topStart)),
              Expanded(child: buildDisplay(Placement.top)),
              Expanded(child: buildDisplay(Placement.topEnd)),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(child: buildDisplay(Placement.leftStart)),
              Expanded(child: buildDisplay(Placement.left)),
              Expanded(child: buildDisplay(Placement.leftEnd)),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(child: buildDisplay(Placement.rightStart)),
              Expanded(child: buildDisplay(Placement.right)),
              Expanded(child: buildDisplay(Placement.rightEnd)),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(child: buildDisplay(Placement.bottomStart)),
              Expanded(child: buildDisplay(Placement.bottom)),
              Expanded(child: buildDisplay(Placement.bottomEnd)),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDisplay(Placement placement) {
    String info = placement.toString().split('.')[1];
    String buttonText = _nameMap[placement]!;
    return Center(
      child: TolyPopover(
        maxWidth: 200,
        placement: placement,
        gap: 12,
        overlay: _DisplayPanel(
          title: info,
        ),
        builder: (_, ctrl, __) => DebugDisplayButton(
          info: buttonText,
          onPressed: ctrl.open,
        ),
      ),
    );
  }

  static const Map<Placement, String> _nameMap = {
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

class _DisplayPanel extends StatelessWidget {
  final String title;

  const _DisplayPanel({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Text(
              title.substring(0, 1).toUpperCase() + title.substring(1),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Text(
              'this is content, this is content, this is content',
            ),
          ),
        ],
      ),
    );
  }
}
