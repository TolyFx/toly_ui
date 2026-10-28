import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_message/tolyui_message.dart';

/// 包只需要语义动作，测试不依赖任何产品或系统插件。
class OpenResultIntent extends NoticeIntent {
  const OpenResultIntent({super.allowAutoClose});

  @override
  String get label => '查看结果';
}

class TestIntentHandler implements NoticeIntentHandler {
  /// 执行期间可由测试阻塞。
  Completer<void>? pending;

  /// 动作执行次数。
  int count = 0;

  /// 模拟平台支持检查。
  bool supported = true;

  /// 模拟执行失败。
  bool fail = false;

  @override
  bool supports(NoticeIntent intent) => supported;

  @override
  Future<void> execute(NoticeIntent intent) async {
    count++;
    if (fail) throw StateError('不能打开结果');
    await pending?.future;
  }
}

Widget buildMessages(BuildContext context, Widget? child) =>
    TolyMessage(theme: Theme.of(context), child: child ?? const SizedBox());

Widget app([String title = '页面']) => MaterialApp(
      theme: ThemeData(colorSchemeSeed: Colors.purple),
      builder: buildMessages,
      home: Scaffold(body: Text(title)),
    );

Future<void> animateIn(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  testWidgets('既有Notice API缺省使用磨砂卡片、主题色和加粗标题', (WidgetTester tester) async {
    await tester.pumpWidget(app());
    $message.infoNotice(title: const Text('普通通知'), subtitle: const Text('内容'));
    await animateIn(tester);
    expect(find.byType(NotificationPanel), findsOneWidget);
    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(tester.getSize(find.byType(NotificationPanel)).width, 300);
    expect(
        DefaultTextStyle.of(tester.element(find.text('普通通知'))).style.fontWeight,
        FontWeight.w700);
    final Icon icon = tester.widget(find.byIcon(CupertinoIcons.info));
    expect(icon.color,
        Theme.of(tester.element(find.text('内容'))).colorScheme.primary);
    await tester.pumpWidget(app('已更新'));
    expect(find.text('已更新'), findsOneWidget);
    expect(find.text('普通通知'), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 4));

    $message.successNotice(
        title: const Text('成功'), subtitle: const Text('已保存'));
    await animateIn(tester);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 4));
    $message.warningNotice(title: const Text('警告'), subtitle: const Text('注意'));
    await animateIn(tester);
    expect(find.byIcon(Icons.error), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 4));
    $message.errorNotice(title: const Text('失败'), subtitle: const Text('错误'));
    await animateIn(tester);
    expect(find.byIcon(CupertinoIcons.exclamationmark_circle_fill),
        findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 4));
  });

  testWidgets('包内执行Intent、默认常驻、防止重复执行，关闭不会访问释放动画', (WidgetTester tester) async {
    final TestIntentHandler handler = TestIntentHandler();
    handler.pending = Completer<void>();
    await tester.pumpWidget(app());
    $message.successNotice(
      title: const Text('保存成功'),
      subtitle: const Text('图片已保存'),
      intent: const OpenResultIntent(),
      intentHandler: handler,
    );
    await animateIn(tester);
    await tester.pump(const Duration(seconds: 10));
    expect(find.text('保存成功'), findsOneWidget);
    expect(handler.count, 0);
    await tester.tap(find.text('查看结果 →'));
    await tester.pump();
    await tester.tap(find.text('查看结果 →'));
    await tester.pump();
    expect(handler.count, 1);
    await tester.pumpWidget(const SizedBox.shrink());
    handler.pending!.complete();
    await tester.pump(const Duration(seconds: 4));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Intent可显式允许自动关闭，不支持时隐藏入口，失败有缺省通知', (WidgetTester tester) async {
    final TestIntentHandler handler = TestIntentHandler();
    await tester.pumpWidget(app());
    $message.notice(
        title: const Text('自动通知'),
        subtitle: const Text('内容'),
        intent: const OpenResultIntent(allowAutoClose: true),
        intentHandler: handler);
    await animateIn(tester);
    await tester.pumpAndSettle(const Duration(seconds: 4));
    expect(find.text('自动通知'), findsNothing);
    handler.supported = false;
    $message.notice(
        title: const Text('不支持'),
        subtitle: const Text('内容'),
        intent: const OpenResultIntent(),
        intentHandler: handler);
    await animateIn(tester);
    expect(find.text('查看结果 →'), findsNothing);
    await tester.tap(find.byIcon(CupertinoIcons.clear));
    await tester.pumpAndSettle();
    handler.supported = true;
    handler.fail = true;
    $message.notice(
        title: const Text('测试失败'),
        subtitle: const Text('内容'),
        intent: const OpenResultIntent(),
        intentHandler: handler);
    await animateIn(tester);
    await tester.tap(find.text('查看结果 →'));
    await animateIn(tester);
    expect(find.text('操作失败'), findsOneWidget);
    expect(find.textContaining('不能打开结果'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 4));
    expect(tester.takeException(), isNull);
  });
}
