import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '自定义范围滑块',
  desc: '展示自定义样式的范围滑块。通过设置不同的颜色主题、分段数和标签样式，可以创建符合应用设计风格的范围选择器。适用于价格区间筛选、时间段选择、数据范围过滤等需要精确控制区间的场景。',
)
class SliderDemo4 extends StatefulWidget {
  const SliderDemo4({super.key});

  @override
  State<SliderDemo4> createState() => _SliderDemo4State();
}

class _SliderDemo4State extends State<SliderDemo4> {
  RangeValues _values1 = const RangeValues(20, 80);
  RangeValues _values2 = const RangeValues(300, 700);
  RangeValues _values3 = const RangeValues(40, 60);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('绿色主题', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('${_values1.start.toInt()} - ${_values1.end.toInt()}'),
          ],
        ),
        RangeSlider(
          values: _values1,
          min: 0,
          max: 100,
          activeColor: Colors.green,
          inactiveColor: Colors.green.withOpacity(0.3),
          onChanged: (values) => setState(() => _values1 = values),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('价格区间', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('¥${_values2.start.toInt()} - ¥${_values2.end.toInt()}'),
          ],
        ),
        RangeSlider(
          values: _values2,
          min: 0,
          max: 1000,
          divisions: 20,
          activeColor: Colors.orange,
          inactiveColor: Colors.orange.withOpacity(0.3),
          labels: RangeLabels(
            '¥${_values2.start.toInt()}',
            '¥${_values2.end.toInt()}',
          ),
          onChanged: (values) => setState(() => _values2 = values),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('紫色主题', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('${_values3.start.toInt()}% - ${_values3.end.toInt()}%'),
          ],
        ),
        RangeSlider(
          values: _values3,
          min: 0,
          max: 100,
          divisions: 10,
          activeColor: Colors.purple,
          inactiveColor: Colors.purple.withOpacity(0.3),
          labels: RangeLabels(
            '${_values3.start.toInt()}%',
            '${_values3.end.toInt()}%',
          ),
          onChanged: (values) => setState(() => _values3 = values),
        ),
      ],
    );
  }
}
