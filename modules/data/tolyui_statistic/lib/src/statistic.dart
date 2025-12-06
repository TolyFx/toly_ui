import 'package:flutter/material.dart';
import 'types.dart';
import 'statistic_number.dart';
import 'statistic_timer.dart';

class TolyStatistic extends StatelessWidget {
  final String? title;
  final ValueType value;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? titleSuffix;

  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final String decimalSeparator;
  final String groupSeparator;
  final int? precision;
  final String? Function(ValueType)? formatter;
  final Widget Function(Widget)? valueRender;
  final bool horizontalCenter;

  const TolyStatistic({
    super.key,
    this.title,
    this.value = 0,
    this.prefix,
    this.suffix,
    this.titleSuffix,
    this.titleStyle,
    this.valueStyle,
    this.decimalSeparator = '.',
    this.groupSeparator = ',',
    this.precision,
    this.formatter,
    this.valueRender,
    this.horizontalCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: horizontalCenter
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) _buildTitle(),
        _buildContent(),
      ],
    );
  }

  Widget _buildTitle() {
    Widget child = Text(
      title!,
      style: titleStyle ??
          const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
    );
    if (titleSuffix != null) {
      child = Wrap(
        spacing: 6,
        children: [
          child,
          titleSuffix!,
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: child,
    );
  }

  Widget _buildContent() {
    final valueWidget = TolyStatisticNumber(
      value: value,
      decimalSeparator: decimalSeparator,
      groupSeparator: groupSeparator,
      precision: precision,
      formatter: formatter,
      style: valueStyle,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefix != null) ...[
          prefix!,
          const SizedBox(width: 4),
        ],
        valueRender?.call(valueWidget) ?? valueWidget,
        if (suffix != null) ...[
          const SizedBox(width: 4),
          suffix!,
        ],
      ],
    );
  }
}
