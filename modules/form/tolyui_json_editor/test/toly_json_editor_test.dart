// 验证 JSON 编辑器、校验状态和样式配置行为。

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_json_editor/tolyui_json_editor.dart';
import 'package:tolyui_json_editor/src/json_highlight_controller.dart';

void main() {
  group('TolyJsonEditor', () {
    testWidgets('renders with initial value', (WidgetTester tester) async {
      const testJson = '{"key": "value"}';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TolyJsonEditor(
              value: testJson,
              label: 'Test JSON',
            ),
          ),
        ),
      );

      expect(find.text('Test JSON'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('shows validation badge for valid JSON',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TolyJsonEditor(
              value: '{"valid": true}',
            ),
          ),
        ),
      );

      expect(find.text('Valid'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows error for invalid JSON', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TolyJsonEditor(
              value: '{invalid json}',
            ),
          ),
        ),
      );

      expect(find.text('Invalid'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('calls onChanged when text changes',
        (WidgetTester tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TolyJsonEditor(
              value: '{}',
              onChanged: (value) => changedValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '{"new": "value"}');
      expect(changedValue, '{"new": "value"}');
    });

    testWidgets('聚焦时编辑器尺寸保持稳定', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: TolyJsonEditor(value: '{}')),
        ),
      );

      final Finder editor = find.byType(AnimatedContainer).first;
      final Size unfocusedSize = tester.getSize(editor);

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();

      expect(tester.getSize(editor), unfocusedSize);
    });

    testWidgets('按物理换行展示编辑器行号', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TolyJsonEditor(value: '{}\n[]', showLineNumbers: true),
          ),
        ),
      );

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(
        find.byKey(const ValueKey<String>('json-editor-current-line')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('json-editor-scope-guide')),
        findsOneWidget,
      );
    });

    testWidgets('光标移动时同步高亮当前行', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TolyJsonEditor(value: '{}\n[]', showLineNumbers: true),
          ),
        ),
      );

      final Finder activeLine =
          find.byKey(const ValueKey<String>('json-editor-current-line'));
      final double initialTop = tester.getTopLeft(activeLine).dy;
      final TextField textField =
          tester.widget<TextField>(find.byType(TextField));
      textField.controller!.selection =
          const TextSelection.collapsed(offset: 4);
      await tester.pump();

      expect(tester.getTopLeft(activeLine).dy, greaterThan(initialTop));
    });

    testWidgets('折叠按钮隐藏区块且不修改原始 JSON', (WidgetTester tester) async {
      const String source = '{\n  "nested": {\n    "value": 1\n  }\n}';
      String? changedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TolyJsonEditor(
              value: source,
              showLineNumbers: true,
              onChanged: (String value) => changedValue = value,
            ),
          ),
        ),
      );

      final Finder rootFold = find.byKey(
        const ValueKey<String>('json-editor-fold-0'),
      );
      final double expandedHeight =
          tester.getSize(find.byType(AnimatedContainer).first).height;
      await tester.tap(rootFold);
      await tester.pump();

      expect(
        find.byWidgetPredicate(
          (Widget widget) =>
              widget is RichText && widget.text.toPlainText().contains('3 行'),
        ),
        findsOneWidget,
      );
      expect(
        tester.getSize(find.byType(AnimatedContainer).first).height,
        lessThan(expandedHeight),
      );
      expect(changedValue, isNull);

      await tester.tap(rootFold);
      await tester.pump();
      final TextField textField =
          tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller!.text, source);
    });

    testWidgets('hides toolbar when showToolbar is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TolyJsonEditor(
              value: '{}',
              label: 'Test',
              showToolbar: false,
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsNothing);
      expect(find.byIcon(Icons.format_align_left), findsNothing);
    });

    testWidgets('disables format button for invalid JSON',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TolyJsonEditor(
              value: '{invalid}',
            ),
          ),
        ),
      );

      final formatButton =
          find.widgetWithIcon(IconButton, Icons.format_align_left);
      expect(formatButton, findsOneWidget);

      final button = tester.widget<IconButton>(formatButton);
      expect(button.onPressed, isNull);
    });
  });

  group('JsonEditorStyle', () {
    test('语法高亮保持原始文本逐字符不变', () {
      const String source = '{\n  "name" : "Toly",\n  "count": 2\n}';
      final List<TextSpan> spans = JsonHighlightController.highlight(
        source,
        JsonEditorStyle.light(),
      );
      final String highlightedText = TextSpan(children: spans).toPlainText();

      expect(highlightedText, source);
    });

    test('creates light theme', () {
      final style = JsonEditorStyle.light();
      expect(style.backgroundColor, Colors.white);
      expect(style.keyColor, Colors.blue[700]);
    });

    test('creates dark theme', () {
      final style = JsonEditorStyle.dark();
      expect(style.backgroundColor, Colors.grey[900]);
      expect(style.keyColor, Colors.lightBlue[300]);
    });

    test('creates from theme', () {
      final theme = ThemeData.light();
      final style = JsonEditorStyle.fromTheme(theme);
      expect(style.backgroundColor, theme.colorScheme.surface);
    });

    test('copyWith works correctly', () {
      final original = JsonEditorStyle.light();
      final copied = original.copyWith(
        backgroundColor: Colors.red,
      );

      expect(copied.backgroundColor, Colors.red);
      expect(copied.keyColor, original.keyColor);
      expect(copied.scopeGuideColor, original.scopeGuideColor);
    });
  });
}
