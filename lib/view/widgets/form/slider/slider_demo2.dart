import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '范围滑块',
  desc: '展示范围滑块的用法。通过 RangeSlider 可以选择一个数值范围，用户可以同时调整起始值和结束值。适用于价格筛选、时间段选择、数据范围过滤等需要设定区间的场景。',
)
class SliderDemo2 extends StatefulWidget {
  const SliderDemo2({super.key});

  @override
  State<SliderDemo2> createState() => _SliderDemo2State();
}

class _SliderDemo2State extends State<SliderDemo2> {
  RangeValues _values1 = const RangeValues(20, 80);
  RangeValues _values2 = const RangeValues(30, 70);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('基础范围', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('${_values1.start.toInt()} - ${_values1.end.toInt()}'),
          ],
        ),
        RangeSlider(
          values: _values1,
          min: 0,
          max: 100,
          onChanged: (values) => setState(() => _values1 = values),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Text('带标签分段', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('${_values2.start.toInt()} - ${_values2.end.toInt()}'),
          ],
        ),
        RangeSlider(
          values: _values2,
          min: 0,
          max: 100,
          divisions: 10,
          labels: RangeLabels(
            _values2.start.toInt().toString(),
            _values2.end.toInt().toString(),
          ),
          onChanged: (values) => setState(() => _values2 = values),
        ),
      ],
    );
  }
}
