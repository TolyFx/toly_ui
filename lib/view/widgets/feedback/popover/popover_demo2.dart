import 'package:flutter/material.dart';
import 'package:toly_ui/app/theme/theme.dart';
import 'package:tolyui_feedback/toly_popover/toly_popover.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

import '../../../debugger/debugger.dart';

class PopoverDemo2 extends StatelessWidget {
  const PopoverDemo2({super.key});

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

  Widget buildDisplay1() {
    return TolyPopover(
      placement: Placement.top,
      maxWidth: 200,
      overlayBuilder: (_, ctrl) => DeletePanel(
        ctrl: ctrl,
      ),
      builder: (_, ctrl, __) {
        return DebugDisplayButton(
          info: 'Delete',
          onPressed: ctrl.open,
        );
      },
    );
  }

  Widget buildDisplay2() {
    return
    TolyPopover(
      placement: Placement.bottomEnd,
      maxWidth: 180,
      overlayBuilder: (_, ctrl) => DisplayMenu(ctrl),
      decorationConfig: const DecorationConfig(),
      builder: (_, ctrl, __) {
        return GestureDetector(
          onTap: ctrl.open,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0),
            child: Icon(Icons.add_circle_outline, color: Color(0xff666666)),
          ),
        );
      },
    );
  }
}

class DisplayMenu extends StatelessWidget {
  final PopoverController ctrl;

  const DisplayMenu(this.ctrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildItem('发起群聊', Icons.chat_outlined),
          const Divider(
            color: Color(0xff515151),
          ),
          _buildItem('添加朋友', Icons.add),
          const Divider(
            color: Color(0xff515151),
          ),
          _buildItem('扫一扫', Icons.qr_code),
          const Divider(
            color: Color(0xff515151),
          ),
          _buildItem('收付款', Icons.payment_sharp),
        ],
      ),
    );
  }

  Widget _buildItem(String title, IconData icon) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: ctrl.close,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class DeletePanel extends StatelessWidget {
  final PopoverController ctrl;

  const DeletePanel({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // direction: Axis.vertical,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
          child: Text(
            'Delete Tip',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(
          height: px1,
          thickness: px1,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12.0),
          child: Text(
            'Are you sure delete this task?',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12.0, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DebugDisplayButton(
                info: 'No',
                onPressed: ctrl.close,
                type: DebugButtonType.cancel,
              ),
              const SizedBox(
                width: 8,
              ),
              DebugDisplayButton(
                info: 'Yes',
                onPressed: ctrl.close,
                type: DebugButtonType.conform,
              )
            ],
          ),
        )
      ],
    );
  }
}
