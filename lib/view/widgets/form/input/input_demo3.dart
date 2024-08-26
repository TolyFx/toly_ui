import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '组合输入框',
  desc: '可以通过 Wrap/Row 等组件，组合输入框和其他组件。如下：前置标签',
)
class InputDemo3 extends StatelessWidget {
  const InputDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        // direction: Axis.vertical,
        children: [
          TolyInput(
              hintText: '用户名/手机号/匠心ID',
              leadingBuilder: SlotBuilder(
                builder: (_, __) =>
                const Text('https://', style: TextStyle(color: Color(0xff1e1e1e))),
              )),
          TolyInput(
            hintText: 'Server Host',
            leadingBuilder: SlotBuilder(
              builder: (_, __) => const Text('https://', style: TextStyle(color: Color(0xff1e1e1e))),
            ),
            tailingBuilder: SlotBuilder(
              builder: (_, __) => const Text('.com', style: TextStyle(color: Color(0xff1e1e1e))),
            ),
          ),
          TolyInput(
            hintText: '选择文件夹',
            tailingBuilder: SlotBuilder(
              onTap: () => $message.success(message: 'Click Open Finder'),
              builder: (_, __) => const Icon(CupertinoIcons.folder, size: 18),
            ),
          ),
          TolyInput(
            hintText: '选择文件夹',
            tailingBuilder: SlotBuilder(
              onTap: () => $message.success(message: 'Click Open Finder'),
              builder: (_, hover) {
                Color? color = hover ? Colors.blue : null;
                return Icon(CupertinoIcons.folder, size: 18, color: color);
              },
            ),
          ),
        ],
      ),
    );;
  }
}
