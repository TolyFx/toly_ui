import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '两种风格',
  desc: '展示 Material 和 Cupertino 两种风格的滑块。Material 风格采用 Android 设计语言，滑块轨道清晰，视觉层次分明。Cupertino 风格采用 iOS 设计语言，滑块更加简洁流畅。可以根据应用的整体设计风格选择合适的滑块样式，或在跨平台应用中根据系统自动适配。',
)
class SliderDemo1 extends StatefulWidget {
  const SliderDemo1({super.key});

  @override
  State<SliderDemo1> createState() => _SliderDemo1State();
}

class _SliderDemo1State extends State<SliderDemo1> {
  double _materialValue = 50;
  double _cupertinoValue = 50;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Material 风格', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('${_materialValue.toInt()}', style: TextStyle(color: Theme.of(context).primaryColor)),
          ],
        ),
        Slider(
          value: _materialValue,
          min: 0,
          max: 100,
          onChanged: (value) => setState(() => _materialValue = value),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Text('Cupertino 风格', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('${_cupertinoValue.toInt()}', style: const TextStyle(color: CupertinoColors.activeBlue)),
          ],
        ),
        CupertinoSlider(
          value: _cupertinoValue,
          min: 0,
          max: 100,
          onChanged: (value) => setState(() => _cupertinoValue = value),
        ),
      ],
    );
  }
}
