import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

void main() {
  group('TolyTooltip', () {
    testWidgets('基本渲染 — 子组件正常显示', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: TolyTooltip(
                message: '提示文字',
                child: Text('悬停我'),
              ),
            ),
          ),
        ),
      );
      expect(find.text('悬停我'), findsOneWidget);
      // tooltip 内容初始不可见
      expect(find.text('提示文字'), findsNothing);
    });

    testWidgets('长按触发 tooltip 显示', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: TolyTooltip(
                message: '长按提示',
                child: Text('长按我'),
              ),
            ),
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('长按我')),
      );
      // 等待长按识别
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('长按提示'), findsOneWidget);

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('tap 模式触发 tooltip', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: TolyTooltip(
                message: '点击提示',
                triggerMode: TooltipTriggerMode.tap,
                child: Text('点击我'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('点击我'));
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('点击提示'), findsOneWidget);
    });

    testWidgets('鼠标悬停触发 tooltip', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: TolyTooltip(
                message: '悬停提示',
                waitDuration: Duration.zero,
                child: Text('悬停目标'),
              ),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.text('悬停目标')));
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('悬停提示'), findsOneWidget);
    });

    testWidgets('鼠标移出后 tooltip 消失', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: TolyTooltip(
                message: '会消失',
                waitDuration: Duration.zero,
                exitDuration: Duration(milliseconds: 50),
                child: Text('目标'),
              ),
            ),
          ),
        ),
      );

      final gesture = await tester.createGesture(
        kind: PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      // 悬停显示
      await gesture.moveTo(tester.getCenter(find.text('目标')));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('会消失'), findsOneWidget);

      // 移出
      await gesture.moveTo(Offset.zero);
      await tester.pumpAndSettle();
      expect(find.text('会消失'), findsNothing);
    });

    testWidgets('message 为空时不显示 overlay', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: TolyTooltip(
                message: '',
                richMessage: null,
                child: Text('空消息'),
              ),
            ),
          ),
        ),
      );
      // 不应该崩溃，子组件正常显示
      expect(find.text('空消息'), findsOneWidget);
    });

    testWidgets('richMessage 支持富文本', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: TolyTooltip(
                richMessage: TextSpan(
                  children: [
                    TextSpan(text: '加粗', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: '普通'),
                  ],
                ),
                triggerMode: TooltipTriggerMode.tap,
                child: Text('富文本'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('富文本'));
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text('加粗普通'), findsOneWidget);
    });

    testWidgets('dismissAllToolTips 关闭所有 tooltip', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: TolyTooltip(
                message: '可关闭',
                triggerMode: TooltipTriggerMode.tap,
                child: Text('目标'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('目标'));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('可关闭'), findsOneWidget);

      TolyTooltip.dismissAllToolTips();
      await tester.pumpAndSettle();
      expect(find.text('可关闭'), findsNothing);
    });

    testWidgets('onTriggered 回调被调用', (tester) async {
      bool triggered = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TolyTooltip(
                message: '回调测试',
                triggerMode: TooltipTriggerMode.tap,
                onTriggered: () => triggered = true,
                child: const Text('触发'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('触发'));
      await tester.pump(const Duration(milliseconds: 200));
      expect(triggered, isTrue);
    });

    testWidgets('不同 placement 都能正常渲染', (tester) async {
      for (final placement in [Placement.top, Placement.bottom, Placement.left, Placement.right]) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: TolyTooltip(
                  message: '方向测试',
                  placement: placement,
                  triggerMode: TooltipTriggerMode.tap,
                  child: const Text('目标'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('目标'));
        await tester.pump(const Duration(milliseconds: 200));
        expect(find.text('方向测试'), findsOneWidget);

        TolyTooltip.dismissAllToolTips();
        await tester.pumpAndSettle();
      }
    });

    testWidgets('自定义 DecorationConfig 正常渲染', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: TolyTooltip(
                message: '自定义装饰',
                decorationConfig: DecorationConfig(
                  backgroundColor: Colors.blue,
                  style: PaintingStyle.stroke,
                  isBubble: false,
                  radius: Radius.circular(8),
                ),
                triggerMode: TooltipTriggerMode.tap,
                child: Text('目标'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('目标'));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('自定义装饰'), findsOneWidget);
    });
  });
}
