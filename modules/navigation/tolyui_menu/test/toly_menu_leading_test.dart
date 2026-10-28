import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_menu/tolyui_menu.dart';

void main() {
  testWidgets('无图标层去除占位，子层独立保留图标列', independentLevels);
  testWidgets('同层混合图标与勾选时仍对齐文字', mixedLeading);
}

Widget app(List<TolyMenuEntry> entries, TolyMenuController controller) =>
    MaterialApp(
        theme: ThemeData(extensions: [
          TolyMenuThemeData.fromColorScheme(const ColorScheme.light())
              .copyWith(fitContent: true)
        ]),
        home: Scaffold(
            body: TolyMenuAnchor(
                controller: controller, entries: entries, builder: trigger)));

Widget trigger(BuildContext context, TolyMenuController controller) =>
    const Text('打开');

double inset(WidgetTester tester, String text, int depth) =>
    tester.getTopLeft(find.text(text)).dx -
    tester
        .getTopLeft(find.byKey(ValueKey<String>('toly-menu-level-$depth')))
        .dx;

Future<void> independentLevels(WidgetTester tester) async {
  final TolyMenuController controller = TolyMenuController();
  await tester.pumpWidget(app(const [
    TolyMenuItem(id: 'parent', label: '无图标父项', children: [
      TolyMenuItem(id: 'icon', label: '图标子项', leading: Icon(Icons.crop)),
      TolyMenuItem(id: 'plain', label: '无图标子项')
    ]),
    TolyMenuDivider(id: 'divider'),
    TolyMenuItem(id: 'other', label: '另一父项')
  ], controller));
  await tester.tap(find.text('打开'));
  await tester.pumpAndSettle();
  final double rootInset = inset(tester, '无图标父项', 0);
  expect(rootInset, lessThan(20));
  await tester.tap(find.text('无图标父项'));
  await tester.pumpAndSettle();
  expect(inset(tester, '图标子项', 1), closeTo(rootInset + 22, .1));
  expect(inset(tester, '无图标子项', 1), closeTo(rootInset + 22, .1));
  controller.close();
  await tester.pumpAndSettle();
  await tester.pumpWidget(const SizedBox());
  controller.dispose();
}

Future<void> mixedLeading(WidgetTester tester) async {
  final TolyMenuController controller = TolyMenuController();
  await tester.pumpWidget(app(const [
    TolyMenuItem(id: 'checked', label: '勾选项', checked: true),
    TolyMenuItem(
        id: 'plain',
        label: '普通项',
        children: [TolyMenuItem(id: 'child', label: '纯文字子项')])
  ], controller));
  await tester.tap(find.text('打开'));
  await tester.pumpAndSettle();
  final double checkedInset = inset(tester, '勾选项', 0);
  expect(find.byIcon(Icons.check), findsOneWidget);
  expect(inset(tester, '普通项', 0), checkedInset);
  await tester.tap(find.text('普通项'));
  await tester.pumpAndSettle();
  expect(inset(tester, '纯文字子项', 1), closeTo(checkedInset - 22, .1));
  expect(tester.takeException(), isNull);
  controller.close();
  await tester.pumpAndSettle();
  await tester.pumpWidget(const SizedBox());
  controller.dispose();
}
