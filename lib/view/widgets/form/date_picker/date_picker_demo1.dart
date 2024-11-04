import 'package:flutter/material.dart';

import '../../display_nodes/display_nodes.dart';
import 'package:intl/intl.dart';

@DisplayNode(
  title: '选择日期',
  desc: 'showDatePicker 方法打开日期选择对话框。',
)
class DatePickerDemo1 extends StatefulWidget {
  const DatePickerDemo1({super.key});

  @override
  State<DatePickerDemo1> createState() => _DatePickerDemo1State();
}

class _DatePickerDemo1State extends State<DatePickerDemo1> {
  DateTime? _selectDate;
  DateFormat format = DateFormat('yyyy/MM/dd');

  String get result {
    if (_selectDate == null) {
      return '';
    }
    return format.format(_selectDate!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              _show(context);
            },
            child: Text('选择日期')),
        const SizedBox(height: 4),
        Text('选择结果: $result')
      ],
    );
  }

  void _show(BuildContext context) async{
    DateTime first = DateTime(2021, 1, 1);
    DateTime last = DateTime.now();
    _selectDate = await showDatePicker(context: context, firstDate: first, lastDate: last);
    if(_selectDate!=null){
      setState(() {

      });
    }
  }
}
