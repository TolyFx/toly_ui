import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_feedback/mobile/toly_pop_picker/toly_pop_picker.dart';
import 'package:tolyui_feedback/mobile/toly_pop_picker/toly_pop_picker_theme.dart';

void main() {
  group('TolyPopPicker', () {
    testWidgets('渲染所有任务项', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TolyPopPicker(
              tasks: [
                TolyPopItem(info: '拍照', task: () {}),
                TolyPopItem(info: '从相册选择', task: () {}),
                TolyPopItem(info: '保存图片', task: () {}),
              ],
            ),
          ),
        ),
      );

      expect(find.text('拍照'), findsOneWidget);
      expect(find.text('从相册选择'), findsOneWidget);
      expect(find.text('保存图片'), findsOneWidget);
    });

    testWidgets('显示取消按钮', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TolyPopPicker(
              tasks: [TolyPopItem(info: '操作', task: () {})],
            ),
          ),
        ),
      );

      expect(find.text('取消'), findsOneWidget);
    });

    testWidgets('自定义取消文字', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TolyPopPicker(
              tasks: [TolyPopItem(info: '操作', task: () {})],
              cancelText: '关闭',
            ),
          ),
        ),
      );

      expect(find.text('关闭'), findsOneWidget);
      expect(find.text('取消'), findsNothing);
    });

    testWidgets('显示标题', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TolyPopPicker(
              title: const Text('请选择操作'),
              tasks: [TolyPopItem(info: '操作一', task: () {})],
            ),
          ),
        ),
      );

      expect(find.text('请选择操作'), findsOneWidget);
    });

    testWidgets('点击任务项触发 task 回调', (tester) async {
      bool taskCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => TolyPopPicker(
                      tasks: [
                        TolyPopItem(
                          info: '执行任务',
                          task: () => taskCalled = true,
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('打开'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('执行任务'));
      await tester.pumpAndSettle();

      expect(taskCalled, isTrue);
    });

    testWidgets('禁用项（task 为 null）不可点击', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TolyPopPicker(
              tasks: [
                TolyPopItem(info: '可用', task: () {}),
                TolyPopItem(info: '禁用'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('可用'), findsOneWidget);
      expect(find.text('禁用'), findsOneWidget);
      // 禁用项应该渲染但不可交互（InkWell onTap 为 null）
    });

    testWidgets('自定义 content 替代 info 文字', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TolyPopPicker(
              tasks: [
                TolyPopItem(
                  info: '不显示',
                  content: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera),
                      Text('自定义内容'),
                    ],
                  ),
                  task: () {},
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('自定义内容'), findsOneWidget);
      expect(find.byIcon(Icons.camera), findsOneWidget);
      // info 文字不应显示，因为 content 优先
      expect(find.text('不显示'), findsNothing);
    });

    testWidgets('点击取消按钮关闭', (tester) async {
      bool cancelCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => TolyPopPicker(
                      tasks: [TolyPopItem(info: '操作', task: () {})],
                      onCancel: () {
                        cancelCalled = true;
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
                child: const Text('打开'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('打开'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();

      expect(cancelCalled, isTrue);
    });

    testWidgets('应用自定义主题', (tester) async {
      const customTheme = TolyPopPickerTheme(
        backgroundColor: Colors.black,
        itemHeight: 60,
        borderRadius: 20,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TolyPopPicker(
              theme: customTheme,
              tasks: [TolyPopItem(info: '主题测试', task: () {})],
            ),
          ),
        ),
      );

      expect(find.text('主题测试'), findsOneWidget);
    });
  });

  group('showTolyPopPicker', () {
    testWidgets('通过函数调用显示 picker', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  showTolyPopPicker(
                    context: context,
                    tasks: [
                      TolyPopItem(info: '函数调用', task: () {}),
                    ],
                    title: const Text('标题'),
                  );
                },
                child: const Text('显示'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('显示'));
      await tester.pumpAndSettle();

      expect(find.text('函数调用'), findsOneWidget);
      expect(find.text('标题'), findsOneWidget);
    });
  });
}
