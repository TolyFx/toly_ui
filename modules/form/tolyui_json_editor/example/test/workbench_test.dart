// 验证独立调试应用可以启动并切换到错误 JSON 状态。

import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_json_editor_example/main.dart';

void main() {
  testWidgets('调试台支持载入错误 JSON', (WidgetTester tester) async {
    await tester.pumpWidget(const JsonEditorExampleApp());

    expect(find.text('TolyUI JSON Editor Workbench'), findsOneWidget);
    expect(find.text('实时编辑'), findsOneWidget);

    await tester.tap(find.text('载入错误 JSON'));
    await tester.pump();

    expect(find.text('Invalid'), findsOneWidget);
  });
}
