import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tolyui_feedback/mobile/toly_pop_picker/toly_pop_picker_theme.dart';

void main() {
  group('TolyPopPickerTheme', () {
    test('默认值正确', () {
      const theme = TolyPopPickerTheme();
      expect(theme.borderRadius, 12.0);
      expect(theme.backgroundColor, Colors.white);
      expect(theme.separatorHeight, 10.0);
      expect(theme.itemHeight, 52.0);
      expect(theme.cancelHeight, 50.0);
    });

    test('copyWith 覆盖指定字段', () {
      const theme = TolyPopPickerTheme();
      final copied = theme.copyWith(
        borderRadius: 20.0,
        backgroundColor: Colors.black,
        itemHeight: 60.0,
      );

      expect(copied.borderRadius, 20.0);
      expect(copied.backgroundColor, Colors.black);
      expect(copied.itemHeight, 60.0);
      // 未覆盖的字段保持默认
      expect(copied.separatorHeight, 10.0);
      expect(copied.cancelHeight, 50.0);
    });

    test('copyWith 不传参数时返回相同值', () {
      const theme = TolyPopPickerTheme(
        borderRadius: 16,
        backgroundColor: Colors.red,
      );
      final copied = theme.copyWith();

      expect(copied.borderRadius, 16);
      expect(copied.backgroundColor, Colors.red);
    });

    test('lerp 在 t=0 时返回 this', () {
      const a = TolyPopPickerTheme(borderRadius: 10, itemHeight: 40);
      const b = TolyPopPickerTheme(borderRadius: 20, itemHeight: 60);

      final result = a.lerp(b, 0);
      expect(result.borderRadius, 10);
      expect(result.itemHeight, 40);
    });

    test('lerp 在 t=1 时返回 other', () {
      const a = TolyPopPickerTheme(borderRadius: 10, itemHeight: 40);
      const b = TolyPopPickerTheme(borderRadius: 20, itemHeight: 60);

      final result = a.lerp(b, 1);
      expect(result.borderRadius, 20);
      expect(result.itemHeight, 60);
    });

    test('lerp 在 t=0.5 时返回中间值', () {
      const a = TolyPopPickerTheme(
        borderRadius: 10,
        itemHeight: 40,
        cancelHeight: 50,
        separatorHeight: 8,
      );
      const b = TolyPopPickerTheme(
        borderRadius: 20,
        itemHeight: 60,
        cancelHeight: 70,
        separatorHeight: 12,
      );

      final result = a.lerp(b, 0.5);
      expect(result.borderRadius, 15);
      expect(result.itemHeight, 50);
      expect(result.cancelHeight, 60);
      expect(result.separatorHeight, 10);
    });

    test('lerp 对非 TolyPopPickerTheme 类型返回 this', () {
      const theme = TolyPopPickerTheme(borderRadius: 10);
      final result = theme.lerp(null, 0.5);
      expect(result.borderRadius, 10);
    });

    test('颜色 lerp 正确插值', () {
      const a = TolyPopPickerTheme(backgroundColor: Colors.white);
      const b = TolyPopPickerTheme(backgroundColor: Colors.black);

      final result = a.lerp(b, 0.5);
      // 中间值应该是灰色
      expect(result.backgroundColor.red, closeTo(128, 2));
      expect(result.backgroundColor.green, closeTo(128, 2));
      expect(result.backgroundColor.blue, closeTo(128, 2));
    });

    testWidgets('of 从 ThemeExtension 获取主题', (tester) async {
      const customTheme = TolyPopPickerTheme(
        borderRadius: 24,
        backgroundColor: Colors.blue,
      );

      late TolyPopPickerTheme resolvedTheme;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: const [customTheme],
          ),
          home: Builder(
            builder: (context) {
              resolvedTheme = TolyPopPickerTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolvedTheme.borderRadius, 24);
      expect(resolvedTheme.backgroundColor, Colors.blue);
    });

    testWidgets('of 在无 ThemeExtension 时返回默认主题', (tester) async {
      late TolyPopPickerTheme resolvedTheme;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              resolvedTheme = TolyPopPickerTheme.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(resolvedTheme.borderRadius, 12.0);
      expect(resolvedTheme.backgroundColor, Colors.white);
    });
  });
}
