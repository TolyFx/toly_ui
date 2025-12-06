import 'package:flutter/material.dart';
import 'types.dart';

class TolyStatisticNumber extends StatelessWidget {
  final ValueType value;
  final String decimalSeparator;
  final String groupSeparator;
  final int? precision;
  final String? Function(ValueType)? formatter;
  final TextStyle? style;

  const TolyStatisticNumber({
    super.key,
    required this.value,
    this.decimalSeparator = '.',
    this.groupSeparator = ',',
    this.precision,
    this.formatter,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    String displayValue;

    if (formatter != null) {
      displayValue = formatter!(value) ?? value.toString();
    } else {
      displayValue = _formatNumber(value.toString());
    }

    return Text(
      displayValue,
      style: style ??
          const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
    );
  }

  String _formatNumber(String val) {
    final regex = RegExp(r'^(-?)(\d*)(\.(\d+))?$');
    final match = regex.firstMatch(val);

    if (match == null || val == '-') {
      return val;
    }

    final negative = match.group(1) ?? '';
    String intPart = match.group(2) ?? '0';
    String decimalPart = match.group(4) ?? '';

    intPart = intPart.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => groupSeparator,
    );

    if (precision != null) {
      if (decimalPart.length < precision!) {
        decimalPart = decimalPart.padRight(precision!, '0');
      } else if (decimalPart.length > precision!) {
        decimalPart = decimalPart.substring(0, precision!);
      }
    }

    String result = negative + intPart;
    if (decimalPart.isNotEmpty) {
      result += decimalSeparator + decimalPart;
    }

    return result;
  }
}
