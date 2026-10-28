import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

void main() {
  testWidgets('非零等待时每次关闭后移入均展示，保留等待时长', _repeatHover);
  testWidgets('等待期移出取消展示，重新进入仍可展示', _leaveBeforeShow);
  testWidgets('关闭延迟和淡出期间返回，提示保持可见', _returnWhileClosing);
}

Future<TestGesture> _prepare(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
          body: Center(
              child: TolyTooltip(
                  message: '悬浮详情',
                  waitDuration: Duration(milliseconds: 250),
                  exitDuration: Duration(milliseconds: 100),
                  child: SizedBox(
                      key: ValueKey<String>('hover-tooltip-target'),
                      width: 9,
                      height: 9,
                      child: ColoredBox(color: Colors.blue)))))));
  final TestGesture mouse =
      await tester.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: Offset.zero);
  addTearDown(mouse.removePointer);
  return mouse;
}

Offset _target(WidgetTester tester) => tester
    .getCenter(find.byKey(const ValueKey<String>('hover-tooltip-target')));

Future<void> _repeatHover(WidgetTester tester) async {
  final TestGesture mouse = await _prepare(tester);
  for (int index = 0; index < 4; index++) {
    await mouse.moveTo(_target(tester));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('悬浮详情'), findsNothing);
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pumpAndSettle();
    expect(find.text('悬浮详情'), findsOneWidget, reason: '第${index + 1}次进入必须展示');
    await mouse.moveTo(Offset.zero);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
    expect(find.text('悬浮详情'), findsNothing);
  }
  await tester.pumpWidget(const SizedBox.shrink());
}

Future<void> _leaveBeforeShow(WidgetTester tester) async {
  final TestGesture mouse = await _prepare(tester);
  await mouse.moveTo(_target(tester));
  await tester.pump(const Duration(milliseconds: 100));
  await mouse.moveTo(Offset.zero);
  await tester.pump(const Duration(milliseconds: 400));
  expect(find.text('悬浮详情'), findsNothing);
  await mouse.moveTo(_target(tester));
  await tester.pump(const Duration(milliseconds: 250));
  await tester.pumpAndSettle();
  expect(find.text('悬浮详情'), findsOneWidget);
  await tester.pumpWidget(const SizedBox.shrink());
}

Future<void> _returnWhileClosing(WidgetTester tester) async {
  final TestGesture mouse = await _prepare(tester);
  await mouse.moveTo(_target(tester));
  await tester.pump(const Duration(milliseconds: 250));
  await tester.pumpAndSettle();
  await mouse.moveTo(Offset.zero);
  await tester.pump(const Duration(milliseconds: 50));
  await mouse.moveTo(_target(tester));
  await tester.pump(const Duration(milliseconds: 200));
  expect(find.text('悬浮详情'), findsOneWidget);
  await mouse.moveTo(Offset.zero);
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pump(const Duration(milliseconds: 30));
  await mouse.moveTo(_target(tester));
  await tester.pumpAndSettle();
  expect(find.text('悬浮详情'), findsOneWidget);
  await mouse.moveTo(Offset.zero);
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pumpAndSettle();
  expect(find.text('悬浮详情'), findsNothing);
  await tester.pumpWidget(const SizedBox.shrink());
}
