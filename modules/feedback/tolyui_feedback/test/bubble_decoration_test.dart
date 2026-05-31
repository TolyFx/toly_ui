import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_feedback/decoration/bubble_decoration.dart';
import 'package:tolyui_feedback/toly_tooltip/tooltip_placement.dart';

void main() {
  group('BubbleMeta', () {
    test('默认值', () {
      const meta = BubbleMeta();
      expect(meta.spineHeight, 8);
      expect(meta.angle, 70);
    });

    test('自定义值', () {
      const meta = BubbleMeta(spineHeight: 12, angle: 90);
      expect(meta.spineHeight, 12);
      expect(meta.angle, 90);
    });
  });

  group('BubbleDecoration', () {
    test('createBoxPainter 返回 BubbleBoxPainter', () {
      const decoration = BubbleDecoration(
        boxSize: Size(100, 40),
        placement: Placement.top,
        borderColor: Colors.grey,
        shiftX: 0,
        style: PaintingStyle.fill,
        radius: Radius.circular(4),
        bubbleMeta: BubbleMeta(),
      );
      final painter = decoration.createBoxPainter();
      expect(painter, isA<BubbleBoxPainter>());
    });

    test('不同 placement 都能创建 painter', () {
      for (final placement in Placement.values) {
        final decoration = BubbleDecoration(
          boxSize: const Size(100, 40),
          placement: placement,
          borderColor: Colors.grey,
          shiftX: 0,
          style: PaintingStyle.fill,
          radius: const Radius.circular(4),
          bubbleMeta: const BubbleMeta(),
        );
        expect(decoration.createBoxPainter(), isA<BubbleBoxPainter>());
      }
    });

    test('stroke 模式属性正确', () {
      const decoration = BubbleDecoration(
        boxSize: Size(100, 40),
        placement: Placement.bottom,
        borderColor: Colors.red,
        shiftX: 5.0,
        style: PaintingStyle.stroke,
        radius: Radius.circular(8),
        bubbleMeta: BubbleMeta(spineHeight: 10, angle: 60),
      );
      expect(decoration.style, PaintingStyle.stroke);
      expect(decoration.borderColor, Colors.red);
      expect(decoration.shiftX, 5.0);
      expect(decoration.radius, const Radius.circular(8));
    });
  });

  group('BubbleBoxPainter', () {
    late BubbleDecoration decoration;

    setUp(() {
      decoration = const BubbleDecoration(
        color: Colors.white,
        boxSize: Size(80, 32),
        placement: Placement.top,
        borderColor: Colors.grey,
        shiftX: 0,
        style: PaintingStyle.fill,
        radius: Radius.circular(4),
        bubbleMeta: BubbleMeta(),
      );
    });

    testWidgets('paint 不抛异常', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              width: 200,
              height: 100,
              decoration: decoration,
            ),
          ),
        ),
      );
      // 能正常渲染即通过
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('所有 placement 方向都能正常渲染', (tester) async {
      for (final placement in Placement.values) {
        final deco = BubbleDecoration(
          color: Colors.white,
          boxSize: const Size(80, 32),
          placement: placement,
          borderColor: Colors.grey,
          shiftX: 0,
          style: PaintingStyle.fill,
          radius: const Radius.circular(4),
          bubbleMeta: const BubbleMeta(),
        );
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Container(
                width: 200,
                height: 100,
                decoration: deco,
              ),
            ),
          ),
        );
        expect(find.byType(Container), findsOneWidget);
      }
    });

    testWidgets('带 shadow 的 decoration 正常渲染', (tester) async {
      final deco = BubbleDecoration(
        color: Colors.white,
        boxSize: const Size(80, 32),
        placement: Placement.bottom,
        borderColor: Colors.grey,
        shiftX: 0,
        style: PaintingStyle.fill,
        radius: const Radius.circular(4),
        bubbleMeta: const BubbleMeta(),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 2),
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              width: 200,
              height: 100,
              decoration: deco,
            ),
          ),
        ),
      );
      expect(find.byType(Container), findsOneWidget);
    });

    testWidgets('spineHeight 为 0 时不绘制尖角', (tester) async {
      const deco = BubbleDecoration(
        color: Colors.white,
        boxSize: Size(80, 32),
        placement: Placement.top,
        borderColor: Colors.grey,
        shiftX: 0,
        style: PaintingStyle.fill,
        radius: Radius.circular(4),
        bubbleMeta: BubbleMeta(spineHeight: 0),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(
              width: 200,
              height: 100,
              decoration: deco,
            ),
          ),
        ),
      );
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
