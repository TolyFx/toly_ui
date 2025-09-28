import 'package:flutter/material.dart';
import 'package:tolyui_feedback_modal/tolyui_feedback_modal.dart';
import 'package:tolyui_message/tolyui_message.dart';

part '01_basic.dart';

part '02_async_task.dart';

part '03_async_task_status.dart';

typedef DebugValueSetter = void Function(String value);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyMessage(
      child: MaterialApp(
        title: 'TolyPopPicker Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          dividerTheme: DividerThemeData(
            color: Color(0xffefefef),
            thickness: 0.5,
            space: 0.5,
          ),
          useMaterial3: true,
          extensions: const [
            TolyPopPickerTheme(),
          ],
        ),
        home: const PopPickerDemo(),
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

  void _showPickerWithTitle() {
    showTolyPopPicker(
      context: context,
      title: const Text('选择操作',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      tasks: [
        TolyMenuItem(
          info: '编辑',
          task: () {
            setState(() => _selectedAction = '编辑');
          },
        ),
        TolyMenuItem(
          info: '删除',
          task: () {
            setState(() => _selectedAction = '删除');
          },
        ),
        TolyMenuItem(
          info: '分享',
          task: () {
            setState(() => _selectedAction = '分享');
          },
        ),
      ],
    );
  }

  void _showPickerWithMessage() {
    showTolyPopPicker(
      context: context,
      title: Text(
        '请选择您要执行的操作',
        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
      ),
      cancelText: '关闭',
      tasks: [
        TolyMenuItem(
          info: '保存到本地',
          task: () {
            setState(() => _selectedAction = '保存到本地');
          },
        ),
        TolyMenuItem(
          info: '发送给朋友',
          task: () {
            setState(() => _selectedAction = '发送给朋友');
          },
        ),
        TolyMenuItem(
          info: '复制链接',
          task: () {
            setState(() => _selectedAction = '复制链接');
          },
        ),
      ],
    );
  }

  void _showPickerWithCustomRadius() {
    showTolyPopPicker(
      context: context,
      title: const Text('选中应用语言'),
      message: '选中的语言将会影响应用程序表现',
      theme: const TolyPopPickerTheme(
          borderRadius: 20.0,
          separatorHeight: 8,
          itemHeight: 54,
          titlePadding: EdgeInsets.symmetric(vertical: 12),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.black,
          ),
          itemTextStyle: TextStyle(
            color: Colors.indigo,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          cancelTextStyle: TextStyle(
            color: Colors.blueAccent,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          )),
      tasks: ['简体中文', 'English']
          .map((e) => TolyMenuItem(
                info: e,
                task: () => setState(() => _selectedAction = e),
              ))
          .toList(),
    );
  }

  void _showPickerWithCustomTheme() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(
            extensions: [
              const TolyPopPickerTheme(
                borderRadius: 16.0,
                backgroundColor: Color(0xFFF5F5F5),
                separatorColor: Colors.blue,
                itemHeight: 60.0,
                itemTextStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500),
                cancelTextStyle: TextStyle(fontSize: 16, color: Colors.red),
              ),
            ],
          ),
          child: Scaffold(
            appBar: AppBar(title: const Text('自定义主题页面')),
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  showTolyPopPicker(
                    context: context,
                    title: const Text('自定义主题'),
                    tasks: [
                      TolyMenuItem(
                        info: '蓝色主题',
                        task: () => setState(() => _selectedAction = '蓝色主题'),
                      ),
                      TolyMenuItem(
                        info: '自定义样式',
                        task: () => setState(() => _selectedAction = '自定义样式'),
                      ),
                    ],
                  );
                },
                child: const Text('显示主题选择器'),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('TolyPopPicker 示例'),
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
              child: const Text('异步+状态监听'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showPickerWithTitle,
              child: const Text('带标题的选择器'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showPickerWithMessage,
              child: const Text('带消息的选择器'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showPickerWithCustomRadius,
              child: const Text('选中语言(指定主题)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _showPickerWithCustomTheme,
              child: const Text('ThemeExtension 自定义'),
            ),
          ],
        ),
      ),
    );
  }
}
