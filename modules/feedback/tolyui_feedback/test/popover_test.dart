import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

void main() {
  group('PopoverController', () {
    testWidgets('open/close 控制弹出层显示隐藏', (tester) async {
      final controller = PopoverController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TolyPopover(
                controller: controller,
                overlay: const Text('弹出内容'),
                child: const Text('触发器'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('弹出内容'), findsNothing);
      expect(controller.isOpen, isFalse);

      controller.open();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('弹出内容'), findsOneWidget);
      expect(controller.isOpen, isTrue);

      controller.close();
      await tester.pumpAndSettle();

      expect(find.text('弹出内容'), findsNothing);
      expect(controller.isOpen, isFalse);
    });

    testWidgets('重复 open 不会创建多个弹出层', (tester) async {
      final controller = PopoverController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TolyPopover(
                controller: controller,
                overlay: const Text('唯一弹出'),
                child: const Text('触发器'),
              ),
            ),
          ),
        ),
      );

      controller.open();
      await tester.pump(const Duration(milliseconds: 300));
      controller.open(); // 重复调用
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('唯一弹出'), findsOneWidget);
    });
  });

  group('TolyPopover', () {
    testWidgets('基本渲染 — 子组件正常显示', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: TolyPopover(
                overlay: Text('弹出层'),
                child: Text('子组件'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('子组件'), findsOneWidget);
      expect(find.text('弹出层'), findsNothing);
    });

    testWidgets('builder 模式正常工作', (tester) async {
      final controller = PopoverController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TolyPopover(
                controller: controller,
                overlay: const Text('弹出内容'),
                builder: (context, ctrl, child) {
                  return GestureDetector(
                    onTap: () => ctrl.open(),
                    child: const Text('自定义触发器'),
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('自定义触发器'), findsOneWidget);

      await tester.tap(find.text('自定义触发器'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('弹出内容'), findsOneWidget);
    });

    testWidgets('overlayBuilder 模式正常工作', (tester) async {
      final controller = PopoverController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TolyPopover(
                controller: controller,
                overlayBuilder: (context, ctrl) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('动态弹出'),
                      TextButton(
                        onPressed: () => ctrl.close(),
                        child: const Text('关闭'),
                      ),
                    ],
                  );
                },
                child: const Text('触发器'),
              ),
            ),
          ),
        ),
      );

      controller.open();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('动态弹出'), findsOneWidget);
      expect(find.text('关闭'), findsOneWidget);
    });

    testWidgets('barrierDismissible 为 true 时点击外部关闭', (tester) async {
      final controller = PopoverController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                const Positioned(
                  top: 10,
                  left: 10,
                  child: Text('外部区域'),
                ),
                Center(
                  child: TolyPopover(
                    controller: controller,
                    barrierDismissible: true,
                    overlay: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('可关闭弹出'),
                    ),
                    child: const Text('触发器'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      controller.open();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('可关闭弹出'), findsOneWidget);

      // 点击外部区域
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(controller.isOpen, isFalse);
    });

    testWidgets('onOpen 和 onClose 回调被调用', (tester) async {
      final controller = PopoverController();
      bool opened = false;
      bool closed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TolyPopover(
                controller: controller,
                onOpen: () => opened = true,
                onClose: () => closed = true,
                overlay: const Text('回调测试'),
                child: const Text('触发器'),
              ),
            ),
          ),
        ),
      );

      controller.open();
      await tester.pump(const Duration(milliseconds: 300));
      expect(opened, isTrue);

      controller.close();
      await tester.pumpAndSettle();
      expect(closed, isTrue);
    });

    testWidgets('不同 placement 都能正常渲染', (tester) async {
      for (final placement in [
        Placement.top,
        Placement.bottom,
        Placement.left,
        Placement.right,
        Placement.topStart,
        Placement.bottomEnd,
      ]) {
        final controller = PopoverController();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: TolyPopover(
                  key: ValueKey(placement),
                  controller: controller,
                  placement: placement,
                  overlay: Text('方向: $placement'),
                  child: const SizedBox(width: 100, height: 40),
                ),
              ),
            ),
          ),
        );
        // 等待 widget 完全挂载
        await tester.pumpAndSettle();

        controller.open();
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.text('方向: $placement'), findsOneWidget);

        controller.close();
        await tester.pumpAndSettle();
      }
    });

    testWidgets('dispose 时自动清理', (tester) async {
      final controller = PopoverController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TolyPopover(
                controller: controller,
                overlay: const Text('会被清理'),
                child: const Text('触发器'),
              ),
            ),
          ),
        ),
      );

      controller.open();
      await tester.pump(const Duration(milliseconds: 300));

      // 替换整个 widget 树，触发 dispose
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Text('替换后')),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('替换后'), findsOneWidget);
      expect(find.text('会被清理'), findsNothing);
    });
  });
}
