import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// create by 星星 on 2024/5/26
/// contact me by email 1395723441@qq.com
/// 说明:
///

class TolyCountdown extends StatefulWidget {
  ///Countdown Title
  final String title;

  ///Countdown value
  final Duration? value;

  ///Countdown front slot
  final Widget? prefix;

  ///Countdown front slot
  final Widget? suffix;
  final TextStyle? valueStyle;
  final TextStyle? titleStyle;

  /// [format] Date formatting
  final String format;

  ///[ finish] Called when the countdown is complete
  final VoidCallback? finish;

  ///[endTime]Incoming countdown end time
  final DateTime? endTime;

  const TolyCountdown(
      {super.key,
      this.value,
      this.prefix,
      this.suffix,
      required this.title,
      this.valueStyle,
      this.titleStyle,
      this.format = 'HH:mm:ss',
      this.finish,
      this.endTime})
      : assert(value == null || endTime == null,
            "The target value and defined value cannot coexist at the same time"),
        assert(value != null || endTime != null, "Countdown requires passing in the initial value");

  @override
  State<TolyCountdown> createState() => _TolyCountdownState();
}

class _TolyCountdownState extends State<TolyCountdown> {
  late Timer timer;
  late int currentValue;

  @override
  void initState() {
    super.initState();
    if (widget.value != null) {
      currentValue = widget.value!.inMilliseconds;
      print(currentValue);
      print(DateTime.fromMillisecondsSinceEpoch(currentValue, isUtc: true));
    } else if (widget.endTime != null) {
      assert(widget.endTime!.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch,
          "The target time is greater than the current time");
      currentValue = widget.endTime!.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch;
    }
    timer = Timer.periodic(const Duration(seconds: 1), _doTask);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = widget.titleStyle ?? const TextStyle(color: Colors.grey, fontSize: 12);
    TextStyle valueStyle = widget.valueStyle ?? const TextStyle();
    String valueText = DateFormat(widget.format)
        .format(DateTime.fromMillisecondsSinceEpoch(currentValue, isUtc: true));

    Widget child = Column(
      children: [
        if (widget.prefix != null) widget.prefix!,
        Text(widget.title, style: textStyle),
        Text(valueText, style: valueStyle),
        if (widget.suffix != null) widget.suffix!,
      ],
    );
    return child;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _doTask(Timer timer) {
    if (currentValue <= 0) {
      timer.cancel();
      widget.finish?.call();
      return;
    }
    setState(() {
      currentValue -= 1000;
    });
  }
}
