import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_pop_panel/tolyui_pop_panel.dart';

void main() {
  testWidgets('面板展示标题、内容与底部操作', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) => TextButton(
            onPressed: () => TolyPopPanel.show<void>(
              context: context,
              title: '元素配置',
              footer: const Text('底部操作'),
              child: const Text('配置内容'),
            ),
            child: const Text('打开'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(find.text('元素配置'), findsOneWidget);
    expect(find.text('配置内容'), findsOneWidget);
    expect(find.text('底部操作'), findsOneWidget);
    expect(
      tester.getSize(find.byType(TolyPopPanel)).height,
      lessThan(300),
    );

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.text('元素配置'), findsNothing);
  });

  testWidgets('确认面板返回用户选择', (WidgetTester tester) async {
    bool? result;
    Future<void> openPanel(BuildContext context) async {
      result = await TolyConfirmPanel.show(
        context: context,
        title: '隐私协议',
        message: '请阅读并同意相关协议',
        cancelLabel: '取消',
        confirmLabel: '同意并继续',
      );
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) => TextButton(
            onPressed: () => openPanel(context),
            child: const Text('确认'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('确认'));
    await tester.pumpAndSettle();
    expect(find.text('隐私协议'), findsOneWidget);

    await tester.tap(find.text('同意并继续'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });
}
