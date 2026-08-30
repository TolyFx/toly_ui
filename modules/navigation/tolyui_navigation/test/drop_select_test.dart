import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_navigation/tolyui_navigation.dart';

void main() {
  testWidgets('紧凑下拉菜单展示并回传泛型值', (WidgetTester tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    String value = 'cover';
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 160,
            child: TolyDropSelect<String>(
              value: value,
              options: const <TolyDropSelectOption<String>>[
                TolyDropSelectOption<String>(
                  value: 'cover',
                  label: '覆盖',
                  trailing: Text('.json'),
                ),
                TolyDropSelectOption<String>(value: 'contain', label: '包含'),
              ],
              onChanged: (String changed) => value = changed,
            ),
          ),
        ),
      ),
    );

    expect(find.text('覆盖'), findsOneWidget);
    expect(find.text('.json'), findsOneWidget);
    await tester.tap(
      find.byKey(const ValueKey<String>('toly-drop-select-trigger')),
    );
    await tester.pumpAndSettle();

    expect(find.text('.json'), findsNWidgets(2));
    expect(find.byIcon(Icons.check), findsOneWidget);

    final double triggerWidth = tester
        .getSize(find.byKey(const ValueKey<String>('toly-drop-select-trigger')))
        .width;
    final double itemWidth =
        tester.getSize(find.byKey(const ValueKey<String>('contain'))).width;
    expect(itemWidth, triggerWidth - 8);

    final Rect firstItem = tester.getRect(
      find.byKey(const ValueKey<String>('cover')),
    );
    final Rect secondItem = tester.getRect(
      find.byKey(const ValueKey<String>('contain')),
    );
    expect(secondItem.top - firstItem.bottom, 4);

    await tester.tap(find.byKey(const ValueKey<String>('contain')));
    await tester.pumpAndSettle();

    expect(value, 'contain');
    debugDefaultTargetPlatformOverride = null;
  });
}
