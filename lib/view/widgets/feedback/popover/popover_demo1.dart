import 'package:flutter/material.dart';
import 'package:toly_ui/app/theme/theme.dart';
import 'package:tolyui_feedback/toly_popover/toly_popover.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import '../../../debugger/debugger.dart';
import '../../display_nodes/display_nodes.dart';
@DisplayNode(
  title: 'Popover 基本使用',
  desc: 'Popover 会将浮层弹框的控制器暴露给 build 方法。你可以通过任何手势事件来打开或关闭浮层弹框。',
)
class PopoverDemo1 extends StatelessWidget {
  const PopoverDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 40,
      children: [
        buildDisplay1(),
        buildDisplay2(),
        buildDisplay3(),
        // Spacer(),
      ],
    );
  }

  Widget buildDisplay1() {
    return TolyPopover(
      placement: Placement.top,
      maxWidth: 200,
      overlay: const DisplayPanel(),
      builder: (_, ctrl, __) {
        return MouseRegion(
          onEnter: (_) => ctrl.open(),
          child: const DebugDisplayButton(info: 'Hover Me'),
        );
      },
    );
  }

  Widget buildDisplay2() {
    return TolyPopover(
      placement: Placement.top,
      maxWidth: 200,
      overlay: const DisplayPanel(),
      builder: (_, ctrl, __) {
        return DebugDisplayButton(info: 'Click Me', onPressed: ctrl.open);
      },
    );
  }

  Widget buildDisplay3() {
    return TolyPopover(
      placement: Placement.top,
      maxWidth: 200,
      overlay: const DisplayPanel(),
      builder: (_, ctrl, __) {
        return GestureDetector(
            onLongPress: ctrl.open, child: const Text('LongPress Me'));
      },
    );
  }
}

class DisplayPanel extends StatelessWidget {
  const DisplayPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Text(
              'Title',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            height: px1,
            thickness: px1,
          ),
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
