import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// 验证 tolyui_form 的公开表单组件行为。

import 'package:tolyui_form/tolyui_form.dart';

void main() {
  testWidgets('文本字段支持输入与提交', (WidgetTester tester) async {
    String changed = '';
    String submitted = '';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TolyTextField(
            value: '原值',
            onChanged: (String value) => changed = value,
            onSubmitted: (String value) => submitted = value,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), '新值');
    await tester.testTextInput.receiveAction(TextInputAction.done);

    expect(changed, '新值');
    expect(submitted, '新值');
  });

  testWidgets('精简输入框按默认悬停聚焦切换视觉状态', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: TolyTextField(value: '属性值')),
      ),
    );
    final Finder frame = find.byKey(
      const ValueKey<String>('toly-compact-input-frame'),
    );
    BoxDecoration decoration =
        tester.widget<AnimatedContainer>(frame).decoration! as BoxDecoration;
    expect(decoration.border!.top.color, Colors.transparent);
    expect(decoration.color, isNot(Colors.transparent));

    final TestGesture mouse = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
    );
    await mouse.addPointer(location: tester.getCenter(frame));
    await tester.pumpAndSettle();
    decoration =
        tester.widget<AnimatedContainer>(frame).decoration! as BoxDecoration;
    expect(decoration.color, isNot(Colors.transparent));

    await tester.tap(
      find.byKey(const ValueKey<String>('toly-compact-input-editor')),
    );
    await tester.pump();
    expect(
      tester.widget<AnimatedContainer>(frame).duration,
      Duration.zero,
    );
    decoration =
        tester.widget<AnimatedContainer>(frame).decoration! as BoxDecoration;
    expect(decoration.border!.top.color, isNot(Colors.transparent));

    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    expect(
      tester.widget<AnimatedContainer>(frame).duration,
      Duration.zero,
    );
    await mouse.removePointer();
  });

  testWidgets('数字字段标签支持水平拖拽调值', (WidgetTester tester) async {
    final ValueNotifier<double> value = ValueNotifier<double>(10);
    double submitted = 10;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ValueListenableBuilder<double>(
            valueListenable: value,
            builder: (BuildContext context, double current, Widget? child) {
              return TolyNumberField(
                value: current,
                label: 'X',
                step: 0.5,
                onChanged: (double changed) => value.value = changed,
                onSubmitted: (double changed) => submitted = changed,
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('X'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);

    await tester.drag(find.text('X'), const Offset(20, 0));
    await tester.pump();

    expect(value.value, 20);
    expect(submitted, 20);
    expect(find.text('20'), findsOneWidget);
  });

  testWidgets('选择与开关字段回传新值', (WidgetTester tester) async {
    String? selected = 'cover';
    bool toggled = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: <Widget>[
              TolySelectField<String>(
                value: selected,
                options: const <TolySelectOption<String>>[
                  TolySelectOption(value: 'cover', label: '覆盖'),
                  TolySelectOption(value: 'contain', label: '包含'),
                ],
                onChanged: (String? value) => selected = value,
              ),
              TolyToggleField(
                value: toggled,
                label: const Text('自动尺寸'),
                onChanged: (bool value) => toggled = value,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('自动尺寸'));

    expect(toggled, isTrue);
    expect(selected, 'cover');
  });

  testWidgets('紧凑按钮组分段展示并回传按钮值', (WidgetTester tester) async {
    String? pressed;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TolyButtonGroup<String>(
            selectedValues: const <String>{'left'},
            items: const <TolyButtonGroupItem<String>>[
              TolyButtonGroupItem<String>(
                value: 'left',
                icon: Icon(Icons.rotate_left),
              ),
              TolyButtonGroupItem<String>(
                value: 'right',
                icon: Icon(Icons.rotate_right),
              ),
            ],
            onPressed: (String value) => pressed = value,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('right')));

    expect(pressed, 'right');
    expect(find.byType(InkWell), findsNothing);
    final DecoratedBox selection = tester.widget<DecoratedBox>(
      find.byKey(
        const ValueKey<String>('toly-button-group-selection-left'),
      ),
    );
    final BoxDecoration decoration = selection.decoration as BoxDecoration;
    expect(decoration.color, isNot(Colors.transparent));
    expect(decoration.border, isNotNull);
  });

  testWidgets('按钮组均分宽度并支持配置分隔线颜色', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 122,
            child: TolyButtonGroup<int>(
              itemWidth: null,
              separatorColor: Colors.white,
              items: const <TolyButtonGroupItem<int>>[
                TolyButtonGroupItem<int>(value: 1, icon: Icon(Icons.looks_one)),
                TolyButtonGroupItem<int>(value: 2, icon: Icon(Icons.looks_two)),
                TolyButtonGroupItem<int>(value: 3, icon: Icon(Icons.looks_3)),
              ],
              onPressed: _ignoreInt,
            ),
          ),
        ),
      ),
    );

    final List<double> widths = <int>[1, 2, 3]
        .map(
          (int value) => tester.getSize(find.byKey(ValueKey<int>(value))).width,
        )
        .toList();
    expect(widths[0], closeTo(widths[1], 0.01));
    expect(widths[1], closeTo(widths[2], 0.01));
    final Container separator = tester.widget<Container>(
      find.byKey(const ValueKey<String>('toly-button-group-separator-1')),
    );
    expect(separator.color, Colors.white);
  });
}

void _ignoreInt(int value) {}
