import 'package:flutter/material.dart';
import 'package:tolyui_feedback_modal/tolyui_feedback_modal.dart';
import 'package:tolyui_message/tolyui_message.dart';

part '01_basic.dart';

part '02_async_task.dart';

part '03_async_task_status.dart';

part '04_has_title.dart';

part '05_title_with_message.dart';

part '06_theme_style.dart';

part '07_global_theme_style.dart';

part '05_desktop_modal.dart';

typedef DebugValueSetter = void Function(String value);

void main() {
  runApp(const MyApp());
}

ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

void toggleThemeMode() {
  if (themeMode.value == ThemeMode.light) {
    themeMode.value = ThemeMode.dark;
  } else {
    themeMode.value = ThemeMode.light;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyMessage(
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeMode,
        builder: (_, value, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TolyPopPicker Demo',
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            dividerTheme: DividerThemeData(
              color: Color(0xff222222),
              thickness: 0.5,
              space: 0.5,
            ),
          ),
          themeMode: value,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            dividerTheme: DividerThemeData(
              color: Color(0xffefefef),
              thickness: 0.5,
              space: 0.5,
            ),
            useMaterial3: true,
          ),
          home: const PopPickerDemo(),
        ),
      ),
    );
  }
}

class PopPickerDemo extends StatefulWidget {
  const PopPickerDemo({super.key});

  @override
  State<PopPickerDemo> createState() => _PopPickerDemoState();
}

class _PopPickerDemoState extends State<PopPickerDemo> {
  String _selectedAction = '未选择';

  void setValue(String value) {
    _selectedAction = value;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('TolyPopPicker 示例'),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeMode,
            builder: (_, value, __) {
              return IconButton(
                onPressed: toggleThemeMode,
                icon: Icon(value == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('当前选择:', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(
                      _selectedAction,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => showBasicPicker(context, setValue),
              child: const Text('基础选择器'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => showAsyncPicker(context, setValue),
              child: const Text('异步选择器(有结果)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => showAsyncStatusPicker(context, setValue),
              child: const Text('异步/状态监听'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => showHasTitlePicker(context, setValue),
              child: const Text('标题/圆角'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => showThemeStylePicker(context, setValue),
              child: const Text('选中语言(指定主题)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => showGlobalThemeStylePicker(context, setValue),
              child: const Text('全局主题'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => showDesktopModalPicker(context, setValue),
              child: const Text('桌面端模态框'),
            ),
          ],
        ),
      ),
    );
  }
}
