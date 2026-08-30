import 'package:flutter_test/flutter_test.dart';
import 'package:toly_menu/toly_menu.dart';

void main() {
  test('控制器只保留一条级联展开路径', () {
    final TolyMenuController controller = TolyMenuController();
    controller.open();
    controller.activate(depth: 0, index: 1, expandable: true);
    controller.activate(depth: 1, index: 2, expandable: true);
    expect(controller.expandedPath, <int>[1, 2]);

    controller.activate(depth: 0, index: 3, expandable: true);
    expect(controller.expandedPath, <int>[3]);
    expect(controller.activePath, <int>[3]);

    controller.close();
    expect(controller.isOpen, isFalse);
    expect(controller.expandedPath, isEmpty);
  });

  test('键盘移动会跳过分隔线和禁用项', () {
    final TolyMenuController controller = TolyMenuController();
    const List<TolyMenuEntry> entries = <TolyMenuEntry>[
      TolyMenuDivider(id: 'divider'),
      TolyMenuItem(id: 'disabled', label: '禁用', enabled: false),
      TolyMenuItem(id: 'first', label: '第一项'),
      TolyMenuItem(id: 'second', label: '第二项'),
    ];
    controller.move(depth: 0, entries: entries, delta: 1);
    expect(controller.activeIndexAt(0), 2);
    controller.move(depth: 0, entries: entries, delta: 1);
    expect(controller.activeIndexAt(0), 3);
  });
}
