import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;
import 'types.dart';
import 'statistic.dart';

class TolyStatisticTimer extends StatefulWidget {
  final TimerType type;
  final ValueType value;
  final String? title;
  final String format;
  final Widget? prefix;
  final Widget? suffix;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final VoidCallback? onFinish;
  final ValueChanged<int>? onChange;

  const TolyStatisticTimer({
    super.key,
    required this.type,
    required this.value,
    this.title,
    this.format = 'HH:mm:ss',
    this.prefix,
    this.suffix,
    this.titleStyle,
    this.valueStyle,
    this.onFinish,
    this.onChange,
  });

  @override
  State<TolyStatisticTimer> createState() => _TolyStatisticTimerState();
}

class _TolyStatisticTimerState extends State<TolyStatisticTimer> {
  Timer? _timer;
  int _currentDiff = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final target = _getTime(widget.value);

      final diff = widget.type == TimerType.countdown
          ? math.max(target - now, 0)
          : math.max(now - target, 0);

      setState(() {
        _currentDiff = diff;
      });

      widget.onChange?.call(diff);

      if (widget.type == TimerType.countdown && target <= now) {
        widget.onFinish?.call();
        timer.cancel();
      }
    });
  }

  int _getTime(ValueType value) {
    if (value is int) return value;
    if (value is DateTime) return value.millisecondsSinceEpoch;
    return int.tryParse(value.toString()) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return TolyStatistic(
      title: widget.title,
      value: _formatTime(_currentDiff, widget.format),
      prefix: widget.prefix,
      suffix: widget.suffix,
      titleStyle: widget.titleStyle,
      valueStyle: widget.valueStyle,
    );
  }

  String _formatTime(int duration, String format) {
    final timeUnits = [
      ['Y', 1000 * 60 * 60 * 24 * 365],
      ['M', 1000 * 60 * 60 * 24 * 30],
      ['D', 1000 * 60 * 60 * 24],
      ['H', 1000 * 60 * 60],
      ['m', 1000 * 60],
      ['s', 1000],
      ['S', 1],
    ];

    int leftDuration = duration;
    String result = format;

    for (final unit in timeUnits) {
      final name = unit[0] as String;
      final unitValue = unit[1] as int;

      if (result.contains(name)) {
        final value = leftDuration ~/ unitValue;
        leftDuration -= value * unitValue;

        result = result.replaceAllMapped(
          RegExp('$name+'),
          (match) {
            final len = match.group(0)!.length;
            return value.toString().padLeft(len, '0');
          },
        );
      }
    }

    return result;
  }
}
