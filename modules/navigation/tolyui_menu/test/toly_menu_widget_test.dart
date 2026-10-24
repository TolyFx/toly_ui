import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_menu/tolyui_menu.dart';

void main() {
  testWidgets('级联菜单共享一个浮层并在选择后整组关闭', (
    WidgetTester tester,
  ) async {
    final TolyMenuController controller = TolyMenuController();
    bool selected = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: TolyMenuAnchor(
              controller: controller,
              entries: <TolyMenuEntry>[
                TolyMenuItem(
                  id: 'export',
                  label: '导出',
                  children: <TolyMenuEntry>[
                    TolyMenuItem(
                      id: 'json',
                      label: 'JSON',
                      onSelected: () => selected = true,
                    ),
                  ],
                ),
              ],
              builder: (
                BuildContext context,
                TolyMenuController menuController,
              ) {
                return const SizedBox(
                  key: ValueKey<String>('anchor'),
                  width: 80,
                  height: 28,
                  child: Text('菜单'),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('anchor')));
    await tester.pump();
    expect(controller.isOpen, isTrue);
    expect(find.byKey(const ValueKey<String>('toly-menu-level-0')), findsOne);

    final TestGesture gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await gesture.addPointer(location: Offset.zero);
    await gesture
        .moveTo(tester.getCenter(find.byKey(const ValueKey<String>('export'))));
    await tester.pump();
    expect(find.byKey(const ValueKey<String>('toly-menu-level-1')), findsOne);

    await tester.tap(find.byKey(const ValueKey<String>('json')));
    await tester.pump();
    expect(selected, isTrue);
    expect(controller.isOpen, isFalse);
    expect(
        find.byKey(const ValueKey<String>('toly-menu-level-0')), findsNothing);
    await gesture.removePointer();
    controller.dispose();
  });

  testWidgets('禁用子菜单不会响应悬浮或展开', (
    WidgetTester tester,
  ) async {
    final TolyMenuController controller = TolyMenuController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TolyMenuAnchor(
            controller: controller,
            entries: const <TolyMenuEntry>[
              TolyMenuItem(
                id: 'disabled',
                label: '禁用子菜单',
                enabled: false,
                children: <TolyMenuEntry>[
                  TolyMenuItem(id: 'child', label: '不应出现'),
                ],
              ),
            ],
            builder: (
              BuildContext context,
              TolyMenuController menuController,
            ) {
              return const SizedBox(width: 80, height: 28, child: Text('菜单'));
            },
          ),
        ),
      ),
    );
    controller.open();
    await tester.pump();

    final TestGesture gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await gesture.addPointer(location: Offset.zero);
    await gesture.moveTo(
      tester.getCenter(find.byKey(const ValueKey<String>('disabled'))),
    );
    await tester.pump();
    expect(controller.expandedPath, isEmpty);
    expect(find.text('不应出现'), findsNothing);
    await gesture.removePointer();
    controller.dispose();
  });
  testWidgets('底部工具栏菜单向上展开，仍可点击选择', (WidgetTester tester) async {
    String? selected;
    Widget buildAnchor(BuildContext context, TolyMenuController controller) =>
        const SizedBox(width: 80, height: 28, child: Text('底部菜单'));
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TolyMenuAnchor(
            placement: TolyMenuPlacement.topStart,
            builder: buildAnchor,
            entries: const [TolyMenuItem(id: 'move', label: '移动到目录')],
            onSelected: (TolyMenuItem item) => selected = item.id,
          )),
    ))));
    await tester.tap(find.text('底部菜单'));
    await tester.pumpAndSettle();
    expect(
        tester
            .getBottomRight(
                find.byKey(const ValueKey<String>('toly-menu-level-0')))
            .dy,
        lessThan(tester.getTopLeft(find.text('底部菜单')).dy));
    await tester.tap(find.text('移动到目录'));
    await tester.pumpAndSettle();
    expect(selected, 'move');
    expect(tester.takeException(), isNull);
  });
}
