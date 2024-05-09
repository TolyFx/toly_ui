// 'top' | 'top-start' | 'top-end' |
// 'bottom' | 'bottom-start' |'bottom-end' |
// 'left' | 'left-start' | 'left-end' |
// 'right' | 'right-start' | 'right-end'

enum Placement {
  top,
  topStart,
  topEnd,
  bottom,
  bottomStart,
  bottomEnd,
  left,
  leftStart,
  leftEnd,
  right,
  rightStart,
  rightEnd;

  bool get isTop => index >= 0 && index <= 2;

  bool get isVertical => isTop||isBottom;
  bool get isHorizontal => isLeft||isRight;

  bool get isBottom => index >= 3 && index <= 5;

  bool get isLeft => index >= 6 && index <= 8;

  bool get isRight => index >= 9 && index <= 11;

  Placement get shift {
    if (isBottom||isRight) {
      return Placement.values[index - 3];
    }
    if (isTop||isLeft) {
      return Placement.values[index + 3];
    }
    return this;
  }
}

class PlacementShift{
  final Placement placement;
  final double x;

  PlacementShift(this.placement, this.x);

  @override
  String toString() {
    return 'PlacementShift{placement: $placement, x: $x}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlacementShift &&
          runtimeType == other.runtimeType &&
          placement == other.placement &&
          x == other.x;

  @override
  int get hashCode => placement.hashCode ^ x.hashCode;
}