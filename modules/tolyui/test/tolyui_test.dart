import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui/tolyui.dart';

void main() {
  testWidgets('横向数字输入支持编辑和加减按钮', (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController(text: '8');
    String changed = '';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 220,
            child: TolyInput(
              controller: controller,
              type: NumberInput(
                min: 0,
                max: 10,
                controlLayout: NumberControlLayout.horizontal,
              ),
              unit: 'px',
              onChanged: (String value) => changed = value,
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.remove), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(controller.text, '9');
    expect(changed, '9');

    await tester.enterText(find.byType(TextField), '6');
    expect(changed, '6');

    controller.dispose();
  });
}
