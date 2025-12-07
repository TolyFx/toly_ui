import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '自定义样式',
  desc: '展示自定义样式的滑块。通过设置颜色、分段数、标签等属性，可以创建符合应用设计风格的滑块。不同的颜色可以表达不同的含义，分段滑块适用于离散值选择，标签可以提供即时的数值反馈。',
)
class SliderDemo3 extends StatefulWidget {
  const SliderDemo3({super.key});

  @override
  State<SliderDemo3> createState() => _SliderDemo3State();
}

class _SliderDemo3State extends State<SliderDemo3> {
  double _value1 = 3;
  double _value2 = 50;
  double _value3 = 75;
  double _value4 = 60;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('分段滑块', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('${_value1.toInt()}'),
          ],
        ),
        Slider(
          value: _value1,
          min: 0,
          max: 5,
          divisions: 5,
          label: _value1.toInt().toString(),
          onChanged: (value) => setState(() => _value1 = value),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('绿色主题', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('${_value2.toInt()}'),
          ],
        ),
        Slider(
          value: _value2,
          min: 0,
          max: 100,
          activeColor: Colors.green,
          inactiveColor: Colors.green.withOpacity(0.3),
          onChanged: (value) => setState(() => _value2 = value),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('橙色主题', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('${_value4.toInt()}'),
          ],
        ),
        Slider(
          value: _value4,
          min: 0,
          max: 100,
          activeColor: Colors.orange,
          inactiveColor: Colors.orange.withOpacity(0.3),
          thumbColor: Colors.orange,
          onChanged: (value) => setState(() => _value4 = value),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('禁用状态', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('${_value3.toInt()}'),
          ],
        ),
        Slider(
          value: _value3,
          min: 0,
          max: 100,
          onChanged: null,
        ),
      ],
    );
  }
}
