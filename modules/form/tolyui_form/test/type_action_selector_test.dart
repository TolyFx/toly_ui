import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_form/tolyui_form.dart';

import '../example/type_action_selector.dart';

const List<TolyTypeActionOption<String>> options = [
  TolyTypeActionOption(
    value: 'file',
    label: '系统文件',
    actionIcon: Icon(Icons.folder_open),
    actionLabel: '选择系统文件',
  ),
  TolyTypeActionOption(
    value: 'library',
    label: '媒体库',
    actionIcon: Icon(Icons.photo_library),
    actionLabel: '选择媒体',
  ),
  TolyTypeActionOption(
    value: 'disabled',
    label: '不可用类型',
    enabled: false,
    actionIcon: Icon(Icons.block),
    actionLabel: '不可用动作',
  ),
];
const Key selectKey = ValueKey<String>('toly-type-action-select');
const Key actionKey = ValueKey<String>('toly-type-action-execute');

Future<void> choose(WidgetTester tester, String label) async {
  await tester.tap(find.byKey(selectKey));
  await tester.pumpAndSettle();
  final Rect field = tester
      .getRect(find.byKey(const ValueKey<String>('toly-type-action-frame')));
  final Finder panel = find
      .ancestor(of: find.text(label).last, matching: find.byType(Material))
      .first;
  final Rect menu = tester.getRect(panel);
  expect(menu.width, closeTo(field.width, .1));
  expect(menu.left, closeTo(field.left, .1));
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Widget host(Widget child, {double width = 160}) => MaterialApp(
      home: Scaffold(
          body: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(width: width, child: child))),
    );

void main() {
  testWidgets('菜单选择只执行一次，同值只执行动作，手动仍可执行', testAutomaticAction);
  testWidgets('默认仅通知类型变化，外部回填不触发动作', testControlledValue);
  testWidgets('仅动作禁用时仍可切换类型，禁用项不可触发自动动作', testDisabledAction);
  testWidgets('整体禁用和忙碌状态阻止重复动作及类型变化', testBusyState);
  testWidgets('空值和外部失效类型均禁用动作，窄宽度保留图标且无溢出', testEmptyAndNarrow);
  testWidgets('键盘可打开菜单、选择类型及执行动作', testKeyboard);
  testWidgets('悬浮保持透明底或主题浅色，示例采用24px高度', testThemeFeedback);
  testWidgets('画布缩放后菜单仍与完整选择器等宽并左对齐', testScaledMenu);
}

Future<void> testAutomaticAction(WidgetTester tester) async {
  final ValueNotifier<String> value = ValueNotifier<String>('file');
  addTearDown(value.dispose);
  final List<String> events = [];
  void change(String next) {
    events.add('change:$next');
    value.value = next;
  }

  void act(String type) => events.add('action:$type');
  Widget build(BuildContext context, String current, Widget? child) =>
      TolyTypeActionSelector<String>(
        value: current,
        options: options,
        autoTriggerOnSelect: true,
        onTypeChanged: change,
        onAction: act,
      );
  await tester.pumpWidget(host(
      ValueListenableBuilder<String>(valueListenable: value, builder: build)));
  expect(events, isEmpty);
  await choose(tester, '媒体库');
  expect(events, ['change:library', 'action:library']);
  expect(find.byIcon(Icons.photo_library), findsOneWidget);
  await choose(tester, '媒体库');
  expect(events, ['change:library', 'action:library', 'action:library']);
  await tester.tap(find.byKey(actionKey));
  expect(events,
      ['change:library', 'action:library', 'action:library', 'action:library']);
  expect(find.text('选择媒体'), findsNothing);
  expect(find.byTooltip('选择媒体'), findsNothing);
  expect(
      find.byWidgetPredicate((Widget widget) =>
          widget is Semantics && widget.properties.label == '选择媒体'),
      findsOneWidget);
}

Future<void> testControlledValue(WidgetTester tester) async {
  final ValueNotifier<String> value = ValueNotifier<String>('file');
  addTearDown(value.dispose);
  final List<String> actions = [];
  void change(String next) => value.value = next;
  Widget build(BuildContext context, String current, Widget? child) =>
      TolyTypeActionSelector<String>(
        value: current,
        options: options,
        onTypeChanged: change,
        onAction: actions.add,
      );
  await tester.pumpWidget(host(
      ValueListenableBuilder<String>(valueListenable: value, builder: build)));
  await choose(tester, '媒体库');
  expect(value.value, 'library');
  expect(actions, isEmpty);
  value.value = 'file';
  await tester.pump();
  expect(find.byIcon(Icons.folder_open), findsOneWidget);
  expect(actions, isEmpty);
}

Future<void> testDisabledAction(WidgetTester tester) async {
  final List<String> changes = [], actions = [];
  await tester.pumpWidget(host(TolyTypeActionSelector<String>(
    value: 'file',
    options: options,
    actionEnabled: false,
    autoTriggerOnSelect: true,
    onTypeChanged: changes.add,
    onAction: actions.add,
  )));
  await tester.tap(find.byKey(actionKey));
  expect(actions, isEmpty);
  await choose(tester, '不可用类型');
  expect(changes, isEmpty);
  expect(actions, isEmpty);
  await tester.tapAt(const Offset(500, 500));
  await tester.pumpAndSettle();
  await choose(tester, '媒体库');
  expect(changes, ['library']);
  expect(actions, isEmpty);
}

Future<void> testBusyState(WidgetTester tester) async {
  final List<String> actions = [], changes = [];
  for (final bool running in [false, true]) {
    await tester.pumpWidget(host(TolyTypeActionSelector<String>(
      value: 'file',
      options: options,
      enabled: running,
      actionRunning: running,
      onTypeChanged: changes.add,
      onAction: actions.add,
    )));
    await tester.tap(find.byKey(actionKey));
    await tester.tap(find.byKey(selectKey));
    await tester.pump();
    expect(actions, isEmpty);
    expect(changes, isEmpty);
    expect(find.text('媒体库'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byIcon(Icons.folder_open), findsOneWidget);
  }
}

Future<void> testEmptyAndNarrow(WidgetTester tester) async {
  final List<String> actions = [];
  for (final String? value in [null, 'removed']) {
    await tester.pumpWidget(host(
        TolyTypeActionSelector<String>(
          value: value,
          options: options,
          onAction: actions.add,
        ),
        width: 90));
    await tester.tap(find.byKey(actionKey));
    expect(actions, isEmpty);
    expect(find.text('请选择类型'), findsOneWidget);
    expect(tester.takeException(), isNull);
  }
  await tester.pumpWidget(host(
      TolyTypeActionSelector<String>(
          value: 'file', options: options, onAction: actions.add),
      width: 90));
  expect(tester.getSize(find.byKey(actionKey)).width, 26);
  expect(tester.takeException(), isNull);
}

Future<void> testKeyboard(WidgetTester tester) async {
  final ValueNotifier<String> value = ValueNotifier<String>('file');
  addTearDown(value.dispose);
  final List<String> actions = [];
  void change(String next) => value.value = next;
  Widget build(BuildContext context, String current, Widget? child) =>
      TolyTypeActionSelector<String>(
        value: current,
        options: options,
        onTypeChanged: change,
        onAction: actions.add,
      );
  await tester.pumpWidget(host(
      ValueListenableBuilder<String>(valueListenable: value, builder: build)));
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pumpAndSettle();
  expect(find.text('媒体库'), findsOneWidget);
  await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
  await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pumpAndSettle();
  expect(value.value, 'library');
  expect(actions, isEmpty);
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pump();
  expect(actions, ['library']);
}

Future<void> testThemeFeedback(WidgetTester tester) async {
  await tester.pumpWidget(host(const TypeActionSelectorExample(), width: 240));
  expect(
      tester
          .getSize(find.byKey(const ValueKey<String>('toly-type-action-frame')))
          .height,
      24);
  final TestGesture mouse =
      await tester.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: tester.getCenter(find.byKey(actionKey)));
  await tester.pumpAndSettle();
  final Finder region = find.descendant(
      of: find.byKey(actionKey), matching: find.byType(ColoredBox));
  expect(tester.widget<ColoredBox>(region.first).color,
      const Color(0xFF3B82F6).withValues(alpha: .06));
  await mouse.removePointer();
}

Future<void> testScaledMenu(WidgetTester tester) async {
  void change(String value) {}
  await tester.pumpWidget(host(Transform.scale(
    scale: 1.5,
    alignment: Alignment.topLeft,
    child: TolyTypeActionSelector<String>(
        value: 'file', options: options, onTypeChanged: change),
  )));
  await tester.tap(find.byKey(selectKey));
  await tester.pumpAndSettle();
  final Rect field = tester
      .getRect(find.byKey(const ValueKey<String>('toly-type-action-frame')));
  final Finder panel = find
      .ancestor(of: find.text('媒体库').last, matching: find.byType(Material))
      .first;
  final Rect menu = tester.getRect(panel);
  expect(field.width, 240);
  expect(menu.width, closeTo(field.width, .1));
  expect(menu.left, closeTo(field.left, .1));
  final Text item = tester.widget<Text>(find.text('媒体库').last);
  expect(item.style!.fontSize, 16.5);
  expect(tester.takeException(), isNull);
}
