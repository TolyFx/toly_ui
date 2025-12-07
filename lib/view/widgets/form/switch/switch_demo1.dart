import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '两种风格',
  desc: '展示 Material 和 Cupertino 两种风格的开关。Material 风格采用 Android 设计语言，开关滑块较大，视觉效果明显。Cupertino 风格采用 iOS 设计语言，开关更加圆润精致。可以根据应用的整体设计风格选择合适的开关样式，或在跨平台应用中根据系统自动适配。',
)
class SwitchDemo1 extends StatefulWidget {
  const SwitchDemo1({super.key});

  @override
  State<SwitchDemo1> createState() => _SwitchDemo1State();
}

class _SwitchDemo1State extends State<SwitchDemo1> {
  bool _materialValue = true;
  bool _cupertinoValue = true;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 16,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: _materialValue,
              onChanged: (value) => setState(() => _materialValue = value),
            ),
            const SizedBox(width: 8),
            const Text('Material 风格'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoSwitch(
              value: _cupertinoValue,
              onChanged: (value) => setState(() => _cupertinoValue = value),
            ),
            const SizedBox(width: 8),
            const Text('Cupertino 风格'),
          ],
        ),
      ],
    );
  }
}
