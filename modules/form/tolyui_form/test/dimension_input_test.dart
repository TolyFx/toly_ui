import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_form/tolyui_form.dart';

const Key widthKey = ValueKey<String>('dimension-width');
const Key heightKey = ValueKey<String>('dimension-height');
const Key lockKey = ValueKey<String>('dimension-lock');
const Key inputKey = ValueKey<String>('dimension');

void main() {
  testWidgets('草稿、回车与比例请求分开，初始化和回填不触发动作也不自动联动', _controlledEvents);
  testWidgets('比例动作支持键盘，整体禁用同时锁住输入和动作且没有Tooltip', _keyboardAndDisabled);
  testWidgets('主题密度、包裹宽度及光标选区可配置，控制器由宿主销毁', _layoutAndTheme);
  testWidgets('隐藏比例开关时字段均分宽度，数字过滤和空白不替宿主校验', _optionalLock);
}

Finder field(Key key) =>
    find.descendant(of: find.byKey(key), matching: find.byType(TextField));

class _Harness {
  /// 宿主持有文本，不由组件创建和销毁。
  final TextEditingController width = TextEditingController(text: '576');

  /// 高度与宽度互不自动影响。
  final TextEditingController height = TextEditingController(text: '960');

  /// 宽度可由宿主监听失焦。
  final FocusNode widthFocus = FocusNode();

  /// 高度可独立取得焦点。
  final FocusNode heightFocus = FocusNode();

  /// 比例锁是受控值。
  final ValueNotifier<bool> locked = ValueNotifier<bool>(true);

  /// 记录原始草稿事件。
  final List<String> changes = [];

  /// 记录明确确认的字段。
  final List<String> submissions = [];

  /// 记录比例动作请求次数。
  int lockChanges = 0;

  /// 整体编辑开关。
  bool enabled = true;

  /// 比例操作区可隐藏。
  bool showLock = true;

  /// 局部视觉覆盖。
  TolyDimensionInputStyle style = const TolyDimensionInputStyle();

  Widget page() => MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          textSelectionTheme:
              const TextSelectionThemeData(selectionColor: Colors.orange)),
      home: Scaffold(
          body: SizedBox(
              width: 232,
              child: Align(
                  alignment: Alignment.topLeft,
                  child: ValueListenableBuilder<bool>(
                      valueListenable: locked, builder: _build)))));

  Widget _build(BuildContext context, bool value, Widget? child) =>
      TolyDimensionInput(
          key: inputKey,
          widthController: width,
          heightController: height,
          widthFocusNode: widthFocus,
          heightFocusNode: heightFocus,
          widthFieldKey: widthKey,
          heightFieldKey: heightKey,
          lockKey: lockKey,
          locked: value,
          enabled: enabled,
          showLock: showLock,
          style: style,
          onLockChanged: _lock,
          onWidthChanged: _widthChanged,
          onHeightChanged: _heightChanged,
          onWidthSubmitted: _widthSubmitted,
          onHeightSubmitted: _heightSubmitted);

  void _lock(bool value) {
    lockChanges++;
    locked.value = value;
  }

  void _widthChanged(String value) => changes.add('W:$value');
  void _heightChanged(String value) => changes.add('H:$value');
  void _widthSubmitted(String value) => submissions.add('W:$value');
  void _heightSubmitted(String value) => submissions.add('H:$value');

  void dispose() {
    width.dispose();
    height.dispose();
    widthFocus.dispose();
    heightFocus.dispose();
    locked.dispose();
  }
}

Future<void> _controlledEvents(WidgetTester tester) async {
  final _Harness host = _Harness();
  addTearDown(host.dispose);
  await tester.pumpWidget(host.page());
  expect(host.changes, isEmpty);
  expect(host.lockChanges, 0);
  await tester.enterText(field(widthKey), '288');
  expect(host.changes, ['W:288']);
  expect(host.submissions, isEmpty);
  expect(host.height.text, '960');
  await tester.testTextInput.receiveAction(TextInputAction.done);
  await tester.pump();
  expect(host.submissions, ['W:288']);
  await tester.tap(field(heightKey));
  await tester.pump();
  expect(host.submissions, ['W:288']);
  await tester.tap(find.byKey(lockKey));
  await tester.pump();
  expect(host.lockChanges, 1);
  expect(host.locked.value, isFalse);
  expect(host.width.text, '288');
  expect(host.height.text, '960');
  host.width.text = '800';
  host.locked.value = true;
  await tester.pump();
  expect(host.lockChanges, 1);
  expect(host.changes, ['W:288']);
  await tester.pumpWidget(const SizedBox.shrink());
}

Future<void> _keyboardAndDisabled(WidgetTester tester) async {
  final _Harness host = _Harness();
  addTearDown(host.dispose);
  await tester.pumpWidget(host.page());
  host.heightFocus.requestFocus();
  await tester.pump();
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  await tester.sendKeyEvent(LogicalKeyboardKey.space);
  await tester.pump();
  expect(host.lockChanges, 1);
  expect(host.locked.value, isFalse);
  host.enabled = false;
  await tester.pumpWidget(host.page());
  expect(tester.widget<TextField>(field(widthKey)).enabled, isFalse);
  expect(tester.widget<TextField>(field(heightKey)).enabled, isFalse);
  await tester.tap(find.byKey(lockKey), warnIfMissed: false);
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pump();
  expect(host.lockChanges, 1);
  expect(find.byType(Tooltip), findsNothing);
  await tester.pumpWidget(const SizedBox.shrink());
}

Future<void> _layoutAndTheme(WidgetTester tester) async {
  final _Harness host = _Harness();
  addTearDown(host.dispose);
  await tester.pumpWidget(host.page());
  expect(tester.getSize(find.byKey(inputKey)), const Size(232, 28));
  expect(tester.getSize(find.byKey(widthKey)).width, 99);
  host.style = const TolyDimensionInputStyle(
      height: 18,
      fieldWidth: 48,
      lockWidth: 20,
      lockIconSize: 13,
      textStyle: TextStyle(fontSize: 8),
      labelStyle: TextStyle(fontSize: 7),
      activeColor: Color(0xFF3B82F6),
      cursorColor: Color(0xFF3B82F6),
      cursorHeight: 10,
      selectionColor: Color(0x333B82F6));
  await tester.pumpWidget(host.page());
  expect(tester.getSize(find.byKey(inputKey)), const Size(126, 18));
  expect(tester.getSize(find.byKey(widthKey)), const Size(48, 18));
  await tester.tap(field(widthKey));
  await tester.pump();
  final TextField input = tester.widget<TextField>(field(widthKey));
  expect(input.cursorColor, const Color(0xFF3B82F6));
  expect(input.cursorWidth, 1);
  expect(input.cursorHeight, 10);
  final EditableText editable = tester.widget<EditableText>(find.descendant(
      of: find.byKey(widthKey), matching: find.byType(EditableText)));
  expect(editable.selectionColor, const Color(0x333B82F6));
  await tester.pumpWidget(const SizedBox.shrink());
  host.width.text = '1024';
  expect(host.width.text, '1024');
  expect(tester.takeException(), isNull);
}

Future<void> _optionalLock(WidgetTester tester) async {
  final _Harness host = _Harness()..showLock = false;
  addTearDown(host.dispose);
  await tester.pumpWidget(host.page());
  expect(find.byKey(lockKey), findsNothing);
  expect(tester.getSize(find.byKey(widthKey)).width, 113);
  await tester.enterText(field(widthKey), '12a3');
  expect(host.width.text, '123');
  await tester.enterText(field(widthKey), '123456');
  expect(host.width.text, '12345');
  await tester.enterText(field(widthKey), '');
  expect(host.width.text, isEmpty);
  expect(host.height.text, '960');
  await tester.pumpWidget(const SizedBox.shrink());
}
