import 'dart:io';

import 'tooltip_placement.dart';

/// 边界溢出情况
class OverflowEdge {
  final bool top;
  final bool bottom;
  final bool right;
  final bool left;

  OverflowEdge({
    required this.top,
    required this.bottom,
    required this.right,
    required this.left,
  });

  @override
  String toString() {
    return 'OverflowEdge{top: $top, bottom: $bottom, right: $right, left: $left}';
  }

  bool get overflowAll => top && bottom && right && left;
}

typedef OverflowAlgorithm = Placement Function(
  OverflowEdge edge,
  Placement input,
);

Placement defaultOverflowAlgorithm(
  OverflowEdge edge,
  Placement input,
) {
  bool outTop = edge.top;
  bool outBottom = edge.bottom;
  bool outLeft = edge.left;
  bool outRight = edge.right;

  // print("edge:$edge, input:${input}");

  if (!outBottom && input.isBottom) {
    return Placement.bottom;
  }

  if (!outTop && input.isTop) {
    return Placement.top;
  }

  if (!outLeft && input.isLeft) {
    return Placement.left;
  }

  if (!outRight && input.isRight) {
    return Placement.right;
  }

  Placement effectPlacement = input;

  Placement shiftToVertical() {
    if (outTop) return Placement.bottom;
    return Placement.top;
  }

  if (outLeft && outRight) {
    return shiftToVertical();
  }

  /// TODO: ::边界响应策略:: 可以将转换策略作为函数参数，使用者来自定义。
  // if(placement.isHorizontal&&(outTop||outBottom)){
  //   return shiftToVertical();
  // }
  switch (input) {
    case Placement.left:
      if (outLeft) return Placement.right;
      if (outBottom) return Placement.leftEnd;
      if (outTop) return Placement.leftStart;
      break;
    case Placement.leftStart:
      if (outBottom) return Placement.leftEnd;
      if (outLeft) return Placement.rightStart;
      break;
    case Placement.leftEnd:
      if (outTop) return Placement.leftStart;
      if (outLeft) return Placement.rightEnd;
      break;
    case Placement.right:
      if (outRight) return Placement.left;
      if (outBottom) return Placement.rightEnd;
      if (outTop) return Placement.rightStart;

      break;
    case Placement.rightStart:
      if (outBottom) return Placement.rightEnd;
      if (outRight) return Placement.leftStart;
      break;
    case Placement.rightEnd:
      if (outTop) return Placement.rightStart;
      if (outRight) return Placement.leftEnd;
      break;
    default:
      if (outBottom && input.isBottom || outTop && input.isTop) {
        return input.shift;
      }
  }
  return effectPlacement;
}
