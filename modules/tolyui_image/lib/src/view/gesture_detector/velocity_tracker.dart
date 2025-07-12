part of 'official.dart';

class ExtendedVelocityTracker extends _VelocityTracker {
  ExtendedVelocityTracker.withKind(super.kind) : super.withKind();
  Offset getSamplesDelta() {
    Offset? first;
    Offset? last;
    for (int i = 0; i < _samples.length; i++) {
      final _PointAtTime? d = _samples[i];
      if (d != null && first == null) {
        first = d.point;
        break;
      }
    }

    for (int i = _samples.length - 1; i >= 0; i--) {
      final _PointAtTime? d = _samples[i];
      if (d != null && last == null) {
        last = d.point;
        break;
      }
    }
    last ??= Offset.zero;
    first ??= Offset.zero;
    return last - first;
  }
}
