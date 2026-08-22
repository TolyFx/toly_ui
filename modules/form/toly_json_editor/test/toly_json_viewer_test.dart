import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toly_json_editor/toly_json_editor.dart';

void main() {
  testWidgets('源码视图展示行号并支持区块折叠', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox.expand(
            child: TolyJsonViewer(
              data: <String, Object>{
                'root': <String, Object>{'value': 1},
              },
              showLineNumbers: true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('1'), findsWidgets);
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.expand_more_rounded).first);
    await tester.pump();

    expect(find.textContaining('3 行'), findsOneWidget);
  });

  testWidgets('工具栏可切换行号显示', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox.expand(
            child: TolyJsonViewer(
              data: <String, Object>{'value': 1},
              showLineNumbers: true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.text('行号'));
    await tester.pump();

    expect(find.text('2'), findsNothing);
  });
}
