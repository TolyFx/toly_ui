import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  testWidgets('紧凑格式菜单缩小行高和字号，JPEG 不换行也不省略', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: SizedBox(
                width: 78,
                child: TolyDropSelect<String>(
                    value: 'jpeg',
                    height: 24,
                    compact: true,
                    itemGap: 2,
                    options: const [
                      TolyDropSelectOption<String>(value: 'png', label: 'PNG'),
                      TolyDropSelectOption<String>(
                          value: 'jpeg', label: 'JPEG'),
                    ],
                    onChanged: (String value) {})))));
    await tester
        .tap(find.byKey(const ValueKey<String>('toly-drop-select-trigger')));
    await tester.pumpAndSettle();
    final Finder item = find.byKey(const ValueKey<String>('jpeg'));
    expect(tester.getSize(item).height, 24);
    final MenuItemButton button = tester.widget<MenuItemButton>(item);
    expect(button.style!.textStyle!.resolve({})!.fontSize, 11);
    final Finder label = find.descendant(of: item, matching: find.text('JPEG'));
    final Text text = tester.widget<Text>(label);
    expect(text.maxLines, 1);
    expect(text.softWrap, isFalse);
    expect(
        tester.renderObject<RenderParagraph>(label).didExceedMaxLines, isFalse);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
  Future<void> independentWidth(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: Center(
                child: TolyDropSelect<int>(
                    value: 0,
                    height: 24,
                    compact: true,
                    shrinkWrap: true,
                    menuWidth: 144,
                    centerMenu: true,
                    options: const [
                      TolyDropSelectOption<int>(value: 0, label: '比例'),
                      TolyDropSelectOption<int>(value: 100, label: '恢复原始尺寸'),
                    ],
                    onChanged: (int value) {})))));
    final Finder trigger =
        find.byKey(const ValueKey<String>('toly-drop-select-trigger'));
    final double width = tester.getSize(trigger).width;
    expect(width, lessThan(80));
    await tester.tap(trigger);
    await tester.pumpAndSettle();
    final Finder item = find.byKey(const ValueKey<int>(100));
    expect(tester.getSize(item).width, greaterThan(width));
    expect(tester.getCenter(item).dx, closeTo(tester.getCenter(trigger).dx, 1));
    final Finder label =
        find.descendant(of: item, matching: find.text('恢复原始尺寸'));
    expect(
        tester.renderObject<RenderParagraph>(label).didExceedMaxLines, isFalse);
    expect(tester.takeException(), isNull);
  }

  testWidgets('触发框包裹内容，浮层使用独立宽度完整展示长选项', independentWidth);
}
