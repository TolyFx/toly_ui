typedef ValueType = dynamic;

enum TimerType { countdown, countup }

class FormatConfig {
  final String? formatter;
  final String decimalSeparator;
  final String groupSeparator;
  final int? precision;

  const FormatConfig({
    this.formatter,
    this.decimalSeparator = '.',
    this.groupSeparator = ',',
    this.precision,
  });
}