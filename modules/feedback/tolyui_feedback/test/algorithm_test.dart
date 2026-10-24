import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_feedback/toly_tooltip/algorithm.dart';
import 'package:tolyui_feedback/toly_tooltip/tooltip_placement.dart';

void main() {
  group('OverflowEdge', () {
    test('noOverflow 全部不溢出时为 true', () {
      final edge = OverflowEdge(
        top: false,
        bottom: false,
        left: false,
        right: false,
      );
      expect(edge.noOverflow, isTrue);
      expect(edge.overflowAll, isFalse);
    });

    test('overflowAll 全部溢出时为 true', () {
      final edge = OverflowEdge(
        top: true,
        bottom: true,
        left: true,
        right: true,
      );
      expect(edge.overflowAll, isTrue);
      expect(edge.noOverflow, isFalse);
    });

    test('部分溢出时 noOverflow 和 overflowAll 都为 false', () {
      final edge = OverflowEdge(
        top: true,
        bottom: false,
        left: false,
        right: false,
      );
      expect(edge.noOverflow, isFalse);
      expect(edge.overflowAll, isFalse);
    });

    test('toString 包含各方向信息', () {
      final edge = OverflowEdge(
        top: true,
        bottom: false,
        left: true,
        right: false,
      );
      final str = edge.toString();
      expect(str, contains('top: true'));
      expect(str, contains('bottom: false'));
      expect(str, contains('left: true'));
      expect(str, contains('right: false'));
    });
  });

  group('defaultOverflowAlgorithm', () {
    test('无溢出时返回原始 placement', () {
      final edge = OverflowEdge(
        top: false,
        bottom: false,
        left: false,
        right: false,
      );
      expect(
        defaultOverflowAlgorithm(edge, Placement.top),
        Placement.top,
      );
      expect(
        defaultOverflowAlgorithm(edge, Placement.bottomEnd),
        Placement.bottomEnd,
      );
    });

    test('top 溢出时 top 系列翻转到 bottom', () {
      final edge = OverflowEdge(
        top: true,
        bottom: false,
        left: false,
        right: false,
      );
      expect(
        defaultOverflowAlgorithm(edge, Placement.top),
        Placement.bottom,
      );
      expect(
        defaultOverflowAlgorithm(edge, Placement.topStart),
        Placement.bottomStart,
      );
      expect(
        defaultOverflowAlgorithm(edge, Placement.topEnd),
        Placement.bottomEnd,
      );
    });

    test('bottom 溢出时 bottom 系列翻转到 top', () {
      final edge = OverflowEdge(
        top: false,
        bottom: true,
        left: false,
        right: false,
      );
      expect(
        defaultOverflowAlgorithm(edge, Placement.bottom),
        Placement.top,
      );
      expect(
        defaultOverflowAlgorithm(edge, Placement.bottomStart),
        Placement.topStart,
      );
    });

    test('left 溢出时 left 翻转到 right', () {
      final edge = OverflowEdge(
        top: false,
        bottom: false,
        left: true,
        right: false,
      );
      expect(
        defaultOverflowAlgorithm(edge, Placement.left),
        Placement.right,
      );
    });

    test('right 溢出时 right 翻转到 left', () {
      final edge = OverflowEdge(
        top: false,
        bottom: false,
        left: false,
        right: true,
      );
      expect(
        defaultOverflowAlgorithm(edge, Placement.right),
        Placement.left,
      );
    });

    test('左侧居中在下方溢出时改为底部对齐', () {
      final OverflowEdge edge =
          OverflowEdge(top: false, bottom: true, left: false, right: false);
      expect(defaultOverflowAlgorithm(edge, Placement.left), Placement.leftEnd);
    });

    test('左侧顶部对齐在下方溢出时改为底部对齐', () {
      final OverflowEdge edge =
          OverflowEdge(top: false, bottom: true, left: false, right: false);
      expect(defaultOverflowAlgorithm(edge, Placement.leftStart),
          Placement.leftEnd);
    });

    test('右侧顶部对齐在下方溢出时改为底部对齐', () {
      final OverflowEdge edge =
          OverflowEdge(top: false, bottom: true, left: false, right: false);
      expect(defaultOverflowAlgorithm(edge, Placement.rightStart),
          Placement.rightEnd);
    });

    test('左侧底部对齐在上方溢出时改为顶部对齐', () {
      final OverflowEdge edge =
          OverflowEdge(top: true, bottom: false, left: false, right: false);
      expect(defaultOverflowAlgorithm(edge, Placement.leftEnd),
          Placement.leftStart);
    });

    test('右侧底部对齐在上方溢出时改为顶部对齐', () {
      final OverflowEdge edge =
          OverflowEdge(top: true, bottom: false, left: false, right: false);
      expect(defaultOverflowAlgorithm(edge, Placement.rightEnd),
          Placement.rightStart);
    });

    test('左右都溢出时水平方向转为垂直方向', () {
      final edge = OverflowEdge(
        top: false,
        bottom: false,
        left: true,
        right: true,
      );
      // 左右都溢出，top 不溢出 → 转为 top
      expect(
        defaultOverflowAlgorithm(edge, Placement.left),
        Placement.top,
      );
      expect(
        defaultOverflowAlgorithm(edge, Placement.right),
        Placement.top,
      );
    });

    test('左右都溢出且 top 也溢出时转为 bottom', () {
      final edge = OverflowEdge(
        top: true,
        bottom: false,
        left: true,
        right: true,
      );
      expect(
        defaultOverflowAlgorithm(edge, Placement.left),
        Placement.bottom,
      );
    });

    test('leftStart 在 left 溢出时翻转为 rightStart', () {
      final edge = OverflowEdge(
        top: false,
        bottom: false,
        left: true,
        right: false,
      );
      expect(
        defaultOverflowAlgorithm(edge, Placement.leftStart),
        Placement.rightStart,
      );
    });

    test('rightEnd 在 right 溢出时翻转为 leftEnd', () {
      final edge = OverflowEdge(
        top: false,
        bottom: false,
        left: false,
        right: true,
      );
      expect(
        defaultOverflowAlgorithm(edge, Placement.rightEnd),
        Placement.leftEnd,
      );
    });

    test('bottom 不溢出时 bottom 系列保持不变', () {
      final edge = OverflowEdge(
        top: true,
        bottom: false,
        left: true,
        right: false,
      );
      expect(
        defaultOverflowAlgorithm(edge, Placement.bottom),
        Placement.bottom,
      );
    });
  });
}
