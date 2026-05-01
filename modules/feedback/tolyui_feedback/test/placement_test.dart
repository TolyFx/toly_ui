import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_feedback/toly_tooltip/tooltip_placement.dart';

void main() {
  group('Placement', () {
    group('方向判断', () {
      test('isTop 对 top/topStart/topEnd 返回 true', () {
        expect(Placement.top.isTop, isTrue);
        expect(Placement.topStart.isTop, isTrue);
        expect(Placement.topEnd.isTop, isTrue);
      });

      test('isTop 对非 top 方向返回 false', () {
        expect(Placement.bottom.isTop, isFalse);
        expect(Placement.left.isTop, isFalse);
        expect(Placement.right.isTop, isFalse);
      });

      test('isBottom 对 bottom/bottomStart/bottomEnd 返回 true', () {
        expect(Placement.bottom.isBottom, isTrue);
        expect(Placement.bottomStart.isBottom, isTrue);
        expect(Placement.bottomEnd.isBottom, isTrue);
      });

      test('isLeft 对 left/leftStart/leftEnd 返回 true', () {
        expect(Placement.left.isLeft, isTrue);
        expect(Placement.leftStart.isLeft, isTrue);
        expect(Placement.leftEnd.isLeft, isTrue);
      });

      test('isRight 对 right/rightStart/rightEnd 返回 true', () {
        expect(Placement.right.isRight, isTrue);
        expect(Placement.rightStart.isRight, isTrue);
        expect(Placement.rightEnd.isRight, isTrue);
      });

      test('isVertical 对 top 和 bottom 系列返回 true', () {
        expect(Placement.top.isVertical, isTrue);
        expect(Placement.bottomEnd.isVertical, isTrue);
        expect(Placement.left.isVertical, isFalse);
        expect(Placement.right.isVertical, isFalse);
      });

      test('isHorizontal 对 left 和 right 系列返回 true', () {
        expect(Placement.left.isHorizontal, isTrue);
        expect(Placement.rightEnd.isHorizontal, isTrue);
        expect(Placement.top.isHorizontal, isFalse);
        expect(Placement.bottom.isHorizontal, isFalse);
      });
    });

    group('shift 翻转', () {
      test('bottom 系列 shift 到 top 系列', () {
        expect(Placement.bottom.shift, Placement.top);
        expect(Placement.bottomStart.shift, Placement.topStart);
        expect(Placement.bottomEnd.shift, Placement.topEnd);
      });

      test('top 系列 shift 到 bottom 系列', () {
        expect(Placement.top.shift, Placement.bottom);
        expect(Placement.topStart.shift, Placement.bottomStart);
        expect(Placement.topEnd.shift, Placement.bottomEnd);
      });

      test('right 系列 shift 到 left 系列', () {
        expect(Placement.right.shift, Placement.left);
        expect(Placement.rightStart.shift, Placement.leftStart);
        expect(Placement.rightEnd.shift, Placement.leftEnd);
      });

      test('left 系列 shift 到 right 系列', () {
        expect(Placement.left.shift, Placement.right);
        expect(Placement.leftStart.shift, Placement.rightStart);
        expect(Placement.leftEnd.shift, Placement.rightEnd);
      });
    });

    group('枚举完整性', () {
      test('共 12 个方向', () {
        expect(Placement.values.length, 12);
      });
    });
  });

  group('PlacementShift', () {
    test('相等性判断', () {
      final a = PlacementShift(Placement.top, 10.0);
      final b = PlacementShift(Placement.top, 10.0);
      final c = PlacementShift(Placement.bottom, 10.0);
      final d = PlacementShift(Placement.top, 20.0);

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
      expect(a, isNot(equals(d)));
    });

    test('hashCode 一致性', () {
      final a = PlacementShift(Placement.top, 10.0);
      final b = PlacementShift(Placement.top, 10.0);
      expect(a.hashCode, equals(b.hashCode));
    });

    test('toString 包含关键信息', () {
      final shift = PlacementShift(Placement.left, 5.0);
      expect(shift.toString(), contains('Placement.left'));
      expect(shift.toString(), contains('5.0'));
    });
  });
}
