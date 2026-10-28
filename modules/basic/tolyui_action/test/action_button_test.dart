import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_action/tolyui_action.dart';

void main() {
  testWidgets('悬停反馈不触发操作，点击只触发一次', (WidgetTester tester) async {
    int calls = 0;
    await tester.pumpWidget(MaterialApp(
      home: Center(
          child: TolyActionButton(
        onPressed: () => calls++,
        child: const Text('移动'),
      )),
    ));
    final TestGesture mouse =
        await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('移动')));
    await tester.pumpAndSettle();
    expect(calls, 0);
    final AnimatedContainer surface =
        tester.widget(find.byType(AnimatedContainer));
    expect(
        (surface.decoration! as BoxDecoration).color, const Color(0xFFEEF0F3));
    await tester.tap(find.text('移动'));
    expect(calls, 1);
    await mouse.removePointer();
  });

  testWidgets('禁用按钮不能被点击或键盘激活', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Center(
          child: TolyActionButton(
        autofocus: true,
        onPressed: null,
        child: Text('删除'),
      )),
    ));
    await tester.tap(find.text('删除'));
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    final FocusableActionDetector focus =
        tester.widget(find.byType(FocusableActionDetector));
    expect(focus.enabled, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('聚焦后 Enter 与空格均可激活', (WidgetTester tester) async {
    int calls = 0;
    await tester.pumpWidget(MaterialApp(
      home: Center(
          child: TolyActionButton(
        autofocus: true,
        onPressed: () => calls++,
        child: const Text('完成'),
      )),
    ));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    expect(calls, 2);
  });
  testWidgets('按钮在 Wrap 中按内容收缩，不占据整行', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Center(
            child: SizedBox(
      width: 250,
      child: Wrap(spacing: 4, children: [
        TolyActionButton(onPressed: () {}, child: const Text('全部')),
        TolyActionButton(onPressed: () {}, child: const Text('图片')),
        TolyActionButton(onPressed: () {}, child: const Text('视频')),
      ]),
    ))));
    expect(tester.getTopLeft(find.text('全部')).dy,
        tester.getTopLeft(find.text('图片')).dy);
    expect(tester.getTopLeft(find.text('图片')).dy,
        tester.getTopLeft(find.text('视频')).dy);
    expect(tester.getSize(find.byType(TolyActionButton).first).width,
        lessThan(80));
  });
}
