import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

void main() {
  testWidgets('已显示提示随倍率改变尺寸、锚点和间距', _liveScale);
  testWidgets('缩小后的提示可在窗口右下区域命中并正常离开', _scaledHitTest);
  testWidgets('边缘处放大避让后缩小，箭头恢复对应方向', _edgeScale);
}

Future<void> _edgeScale(WidgetTester tester) async {
  final _ScaleFixture fixture = _ScaleFixture();
  fixture.zoom.value = .5;
  addTearDown(fixture.zoom.dispose);
  await tester.pumpWidget(fixture.page(alignment: const Alignment(.9, .9)));
  fixture.tooltip.currentState!.ensureTooltipVisible();
  await tester.pumpAndSettle();
  for (final double scale in [.5, 2, .5]) {
    fixture.zoom.value = scale;
    await tester.pumpAndSettle();
    final Container panel = tester.widget<Container>(_panel());
    final BubbleDecoration decoration = panel.decoration! as BubbleDecoration;
    expect(decoration.placement.isBottom, scale == .5);
    final Rect bounds = _screenRect(tester, _panel());
    expect(bounds.left, greaterThanOrEqualTo(0));
    expect(bounds.right, lessThanOrEqualTo(800));
    expect(bounds.top, greaterThanOrEqualTo(0));
    expect(bounds.bottom, lessThanOrEqualTo(600));
  }
  await tester.pumpWidget(const SizedBox.shrink());
}

class _ScaleFixture {
  /// 模拟宿主画布倍率变化。
  final ValueNotifier<double> zoom = ValueNotifier<double>(1);

  /// 手动显示避免缩放测试引入鼠标离开行为。
  final GlobalKey<TolyTooltipState> tooltip = GlobalKey<TolyTooltipState>();

  Widget build(BuildContext context, double scale, Widget? child) =>
      Transform.scale(
          scale: scale,
          child: TolyTooltip(
              key: tooltip,
              scale: scale,
              message: '缩放详情',
              gap: 12,
              textStyle: const TextStyle(fontSize: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              waitDuration: Duration.zero,
              exitDuration: const Duration(milliseconds: 100),
              child: const SizedBox(
                  key: ValueKey<String>('scaled-target'),
                  width: 9,
                  height: 9,
                  child: ColoredBox(color: Colors.blue))));

  Widget page({Alignment alignment = Alignment.center}) => MaterialApp(
      home: Scaffold(
          body: Align(
              alignment: alignment,
              child: ValueListenableBuilder<double>(
                  valueListenable: zoom, builder: build))));
}

bool _isPanel(Widget widget) =>
    widget is Container && widget.decoration is BubbleDecoration;

Finder _panel() => find
    .ancestor(of: find.text('缩放详情'), matching: find.byWidgetPredicate(_isPanel))
    .first;

Rect _screenRect(WidgetTester tester, Finder finder) {
  final RenderBox box = tester.renderObject<RenderBox>(finder);
  return MatrixUtils.transformRect(
      box.getTransformTo(null), Offset.zero & box.size);
}

Future<void> _liveScale(WidgetTester tester) async {
  final _ScaleFixture fixture = _ScaleFixture();
  addTearDown(fixture.zoom.dispose);
  await tester.pumpWidget(fixture.page());
  fixture.tooltip.currentState!.ensureTooltipVisible();
  await tester.pumpAndSettle();
  final Rect base = _screenRect(tester, _panel());
  for (final double scale in [.5, 2, 1]) {
    fixture.zoom.value = scale;
    await tester.pumpAndSettle();
    final Rect panel = _screenRect(tester, _panel());
    final Rect target = _screenRect(
        tester, find.byKey(const ValueKey<String>('scaled-target')));
    expect(panel.width, closeTo(base.width * scale, .01));
    expect(panel.height, closeTo(base.height * scale, .01));
    expect(panel.center.dx, closeTo(target.center.dx, .01));
    expect(panel.top - target.bottom, closeTo(12 * scale, .01));
  }
  await tester.pumpWidget(const SizedBox.shrink());
}

Future<void> _scaledHitTest(WidgetTester tester) async {
  final _ScaleFixture fixture = _ScaleFixture();
  fixture.zoom.value = .5;
  addTearDown(fixture.zoom.dispose);
  await tester.pumpWidget(fixture.page(alignment: const Alignment(.75, .65)));
  final TestGesture mouse =
      await tester.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: Offset.zero);
  addTearDown(mouse.removePointer);
  final Rect target =
      _screenRect(tester, find.byKey(const ValueKey<String>('scaled-target')));
  await mouse.moveTo(target.center);
  await tester.pumpAndSettle();
  expect(find.text('缩放详情'), findsOneWidget);
  await mouse.moveTo(_screenRect(tester, _panel()).center);
  await tester.pump(const Duration(milliseconds: 300));
  await tester.pumpAndSettle();
  expect(find.text('缩放详情'), findsOneWidget);
  await mouse.moveTo(Offset.zero);
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pumpAndSettle();
  expect(find.text('缩放详情'), findsNothing);
  await tester.pumpWidget(const SizedBox.shrink());
}
