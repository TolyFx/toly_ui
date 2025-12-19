enum MessagePosition {
  top,
  bottom,
}

enum NoticePosition {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight;

  bool get isBottom => index == 2 || index == 3;
  bool get isTop => index == 0 || index == 1;
  bool get isRight => index == 1 || index == 3;
  bool get isLeft => index == 0 || index == 2;
}
