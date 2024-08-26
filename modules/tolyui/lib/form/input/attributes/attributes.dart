import 'package:flutter/material.dart';

sealed class DisplaySize {
  final BoxConstraints constraints;

  const DisplaySize(this.constraints);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DisplaySize && runtimeType == other.runtimeType && constraints == other.constraints;

  @override
  int get hashCode => constraints.hashCode;
}

class DefaultSize extends DisplaySize {
  const DefaultSize() : super(const BoxConstraints.tightFor(height: 32));
}

class SmallSize extends DisplaySize {
  const SmallSize() : super(const BoxConstraints.tightFor(height: 24));
}

class LargeSize extends DisplaySize {
  const LargeSize() : super(const BoxConstraints.tightFor(height: 40));
}

class CustomSize extends DisplaySize {
  const CustomSize(super.constraints);

  CustomSize.height(double height) : super(BoxConstraints.tightFor(height: height));
}

sealed class InputType {}

class NumberInput extends InputType {
  final num step;
  final num min;
  final num? max;
  final num? errorDefault;

  NumberInput({
    this.step = 1,
    this.min = 0,
    this.max,
    this.errorDefault = 0,
  });

  String plus(String value) {
    num count = num.tryParse(value) ?? errorDefault ?? 0;
    return (count + step).clamp(min, max ?? 99999999).toString();
  }

  String minus(String value) {
    num count = num.tryParse(value) ?? errorDefault ?? 0;
    return (count - step).clamp(min, max ?? 99999999).toString();
  }
}
//
// abstract interface class Slot{
//   Widget build(BuildContext context);
// }
//
// class BuilderSlot implements Slot{
//   final WidgetBuilder builder;
//
//   BuilderSlot(this.builder);
//
//   @override
//   Widget build(BuildContext context) {
//     return builder(context);
//   }
// }


// class ClearAble{
//   final IconData icon;
//
//   ClearAble(this.icon);
// }