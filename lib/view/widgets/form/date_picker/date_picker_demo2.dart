import 'package:flutter/material.dart';

import '../../display_nodes/display_nodes.dart';
import 'package:intl/intl.dart';

@DisplayNode(
  title: '选择时间范围',
  desc: 'showDateRangePicker 方法打开选择时间范围对话框。',
)
class DatePickerDemo2 extends StatefulWidget {
  const DatePickerDemo2({super.key});

  @override
  State<DatePickerDemo2> createState() => _DatePickerDemo2State();
}

class _DatePickerDemo2State extends State<DatePickerDemo2> {
  String _dateRange = '';

  DateFormat format = DateFormat('yyyy/MM/dd');


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              _show(context);
            },
            child: Text('选择时间范围')),
        const SizedBox(height: 4),
        Text('选择结果: $_dateRange')
      ],
    );
  }

  void _show(BuildContext context) async {
    DateTime firstDate = DateTime(2021, 1, 1);
    DateTime lastDate = DateTime.now();
    DateTime start = lastDate.add(const Duration(days: -8));
    DateTime end = lastDate.add(const Duration(days: -2));
    DateTimeRange? range = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: DateTimeRange(
        start: start,
        end: end,
      ),
      saveText: "确定",
    );
    if (range != null) {
      setState(() {
        _dateRange =
        "${format.format(range.start)} - ${format.format(range.end)}";
      });
    }
  }
}
