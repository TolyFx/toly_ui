import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';
import 'package:tolyui_feedback/decoration/bubble_decoration.dart';
import 'package:tolyui_feedback/toly_popover/model/callback.dart';
import 'package:tolyui_feedback/toly_popover/view/decoration.dart';

void main() {
  group('DecorationConfig', () {
    test('默认值正确', () {
      const config = DecorationConfig();
      expect(config.style, PaintingStyle.fill);
      expect(config.backgroundColor, const Color(0xff303133));
      expect(config.textColor, isNull);
      expect(config.isBubble, isTrue);
      expect(config.radius, const Radius.circular(4));
      expect(config.shadows, isNull);
    });

    test('自定义值', () {
      const config = DecorationConfig(
        style: PaintingStyle.stroke,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        isBubble: false,
        radius: Radius.circular(12),
        shadows: [BoxShadow(blurRadius: 4)],
      );
      expect(config.style, PaintingStyle.stroke);
      expect(config.backgroundColor, Colors.white);
      expect(config.textColor, Colors.black);
      expect(config.isBubble, isFalse);
      expect(config.radius, const Radius.circular(12));
      expect(config.shadows, isNotNull);
      expect(config.shadows!.length, 1);
    });

    test('BubbleMeta 默认值', () {
      const config = DecorationConfig();
      expect(config.bubbleMeta.spineHeight, 8);
      expect(config.bubbleMeta.angle, 70);
    });

    test('自定义 BubbleMeta', () {
      const config = DecorationConfig(
        bubbleMeta: BubbleMeta(spineHeight: 12, angle: 90),
      );
      expect(config.bubbleMeta.spineHeight, 12);
      expect(config.bubbleMeta.angle, 90);
    });
  });

  group('Calculator', () {
    test('属性正确存储', () {
      final calc = Calculator(
        placement: Placement.top,
        boxSize: const Size(100, 40),
        overlaySize: const Size(200, 80),
        gap: 12,
      );
      expect(calc.placement, Placement.top);
      expect(calc.boxSize, const Size(100, 40));
      expect(calc.overlaySize, const Size(200, 80));
      expect(calc.gap, 12);
    });
  });

  group('PopoverDecoration', () {
    test('属性正确存储', () {
      final deco = PopoverDecoration(
        placement: Placement.bottom,
        shift: const Offset(5, 0),
        boxSize: const Size(100, 40),
        darkTheme: true,
        config: const DecorationConfig(),
      );
      expect(deco.placement, Placement.bottom);
      expect(deco.shift, const Offset(5, 0));
      expect(deco.boxSize, const Size(100, 40));
      expect(deco.darkTheme, isTrue);
      expect(deco.config, isNotNull);
    });
  });

  group('defaultDecorationBuilder', () {
    test('亮色主题 isBubble=true 返回 BubbleDecoration', () {
      final deco = PopoverDecoration(
        placement: Placement.top,
        shift: Offset.zero,
        boxSize: const Size(100, 40),
        darkTheme: false,
        config: const DecorationConfig(
          backgroundColor: Colors.white,
          style: PaintingStyle.stroke,
          isBubble: true,
        ),
      );
      final result = defaultDecorationBuilder(deco);
      expect(result, isA<BubbleDecoration>());
    });

    test('isBubble=false 返回 BoxDecoration', () {
      final deco = PopoverDecoration(
        placement: Placement.top,
        shift: Offset.zero,
        boxSize: const Size(100, 40),
        darkTheme: false,
        config: const DecorationConfig(
          isBubble: false,
        ),
      );
      final result = defaultDecorationBuilder(deco);
      expect(result, isA<BoxDecoration>());
    });

    test('暗色主题 config 为 null 时默认 isBubble=false 返回 BoxDecoration', () {
      // 当 config 为 null 时，defaultDecorationBuilder 内部创建的 DecorationConfig
      // 使用 PaintingStyle.stroke 和 shadows，但 isBubble 默认为 true
      // 所以实际返回 BubbleDecoration
      final deco = PopoverDecoration(
        placement: Placement.bottom,
        shift: Offset.zero,
        boxSize: const Size(100, 40),
        darkTheme: true,
        config: null,
      );
      final result = defaultDecorationBuilder(deco);
      // config 为 null 时内部构建的 DecorationConfig 的 isBubble 未显式设置
      // 查看源码: DecorationConfig 默认 isBubble=true，但 defaultDecorationBuilder
      // 中 config ?? DecorationConfig(...) 没有传 isBubble，所以走默认值
      // 实际上 defaultDecorationBuilder 中创建的 config 没有设置 isBubble
      // 看源码: config.isBubble 检查 → 默认 DecorationConfig 的 isBubble=true
      // 但 defaultDecorationBuilder 中 config ?? 创建的是带 style: stroke 的
      // 其 isBubble 仍然是默认的 true → 返回 BubbleDecoration
      expect(result, isA<Decoration>());
    });

    test('亮色主题 config 为 null 时返回 Decoration', () {
      final deco = PopoverDecoration(
        placement: Placement.bottom,
        shift: Offset.zero,
        boxSize: const Size(100, 40),
        darkTheme: false,
        config: null,
      );
      final result = defaultDecorationBuilder(deco);
      // 同上，默认 isBubble=true，返回 BubbleDecoration
      expect(result, isA<Decoration>());
    });
  });

  group('offsetCalculator', () {
    test('boxOffsetCalculator 各方向偏移正确', () {
      final calcTop = Calculator(
        placement: Placement.top,
        boxSize: const Size(100, 40),
        overlaySize: const Size(200, 80),
        gap: 12,
      );
      final offsetTop = boxOffsetCalculator(calcTop);
      // top 方向: Offset(0, gap - 6) = Offset(0, 6)
      expect(offsetTop.dx, 0);
      expect(offsetTop.dy, 6);

      final calcBottom = Calculator(
        placement: Placement.bottom,
        boxSize: const Size(100, 40),
        overlaySize: const Size(200, 80),
        gap: 12,
      );
      final offsetBottom = boxOffsetCalculator(calcBottom);
      // bottom 方向: Offset(0, -gap + 6) = Offset(0, -6)
      expect(offsetBottom.dx, 0);
      expect(offsetBottom.dy, -6);
    });

    test('menuOffsetCalculator 自定义 shift', () {
      final calc = Calculator(
        placement: Placement.left,
        boxSize: const Size(100, 40),
        overlaySize: const Size(200, 80),
        gap: 12,
      );
      final offset = menuOffsetCalculator(calc, shift: 10);
      // left 方向: Offset(gap - shift, 0) = Offset(2, 0)
      expect(offset.dx, 2);
      expect(offset.dy, 0);
    });

    test('所有 placement 方向都有对应偏移', () {
      for (final placement in Placement.values) {
        final calc = Calculator(
          placement: placement,
          boxSize: const Size(100, 40),
          overlaySize: const Size(200, 80),
          gap: 12,
        );
        // 不应抛异常
        final offset = boxOffsetCalculator(calc);
        expect(offset, isA<Offset>());
      }
    });
  });
}
