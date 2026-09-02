// 验证 JSON 编辑器、校验状态和样式配置行为。

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_json_editor/tolyui_json_editor.dart';

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

    testWidgets('shows validation badge for valid JSON', (WidgetTester tester) async {
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

    testWidgets('calls onChanged when text changes', (WidgetTester tester) async {
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

    testWidgets('hides toolbar when showToolbar is false', (WidgetTester tester) async {
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

    testWidgets('disables format button for invalid JSON', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TolyJsonEditor(
              value: '{invalid}',
            ),
          ),
        ),
      );

      final formatButton = find.widgetWithIcon(IconButton, Icons.format_align_left);
      expect(formatButton, findsOneWidget);
      
      final button = tester.widget<IconButton>(formatButton);
      expect(button.onPressed, isNull);
    });
  });

  group('JsonEditorStyle', () {
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
    });
  });
}
