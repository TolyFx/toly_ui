import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_menu/tolyui_menu.dart';

void main() {
  Widget app(List<TolyMenuEntry> entries) => MaterialApp(
        theme: ThemeData(extensions: [
          TolyMenuThemeData.fromColorScheme(const ColorScheme.light())
              .copyWith(panelWidth: 210, fitContent: true),
        ]),
        home: Scaffold(
            body: Align(
          alignment: Alignment.bottomRight,
          child: TolyMenuAnchor(
            entries: entries,
            builder: (BuildContext context, TolyMenuController controller) =>
                const SizedBox(width: 60, height: 28, child: Text('菜单')),
          ),
        )),
      );

  testWidgets('短菜单按最长内容收拢，窗口右下角按实际尺寸避让', (WidgetTester tester) async {
    await tester.pumpWidget(app(const [
      TolyMenuItem(id: 'create', label: '新建文件夹'),
      TolyMenuItem(id: 'other', label: '打开'),
    ]));
    await tester.tap(find.text('菜单'));
    await tester.pumpAndSettle();
    final Rect panel =
        tester.getRect(find.byKey(const ValueKey<String>('toly-menu-level-0')));
    expect(panel.width, lessThan(210));
    expect(panel.width, greaterThan(tester.getSize(find.text('新建文件夹')).width));
    expect(panel.right, lessThanOrEqualTo(792));
    expect(panel.bottom, lessThanOrEqualTo(592));
    expect(tester.takeException(), isNull);
  });

  testWidgets('各级菜单分别包裹，计算自定义尾缀的真实宽度', (WidgetTester tester) async {
    await tester.pumpWidget(app(const [
      TolyMenuItem(id: 'parent', label: '移动', children: [
        TolyMenuItem(
            id: 'child',
            label: '目标',
            trailing: SizedBox(width: 100, child: Text('自定义尾缀'))),
      ]),
    ]));
    await tester.tap(find.text('菜单'));
    await tester.pumpAndSettle();
    final double rootWidth = tester
        .getSize(find.byKey(const ValueKey<String>('toly-menu-level-0')))
        .width;
    await tester.tap(find.text('移动'));
    await tester.pumpAndSettle();
    final Rect childPanel =
        tester.getRect(find.byKey(const ValueKey<String>('toly-menu-level-1')));
    expect(childPanel.width, greaterThan(rootWidth));
    expect(childPanel.width, lessThanOrEqualTo(210));
    expect(childPanel.right, lessThanOrEqualTo(792));
    expect(tester.takeException(), isNull);
  });
}
