import 'package:flutter/material.dart';
import 'package:tolyui_feedback/tolyui_feedback.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TolyPopPicker Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        extensions: const [
          TolyPopPickerTheme(),
        ],
      ),
      home: const PopPickerDemo(),
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

  void _showBasicPicker() {
    showTolyPopPicker(
      context: context,
      tasks: [
        TolyPopItem(
          info: '拍照',
          task: () {
            setState(() => _selectedAction = '拍照');
          },
        ),
        TolyPopItem(
          info: '从相册选择',
          task: () {
            setState(() => _selectedAction = '从相册选择');
          },
        ),
      ],
    );
  }

  void _showPickerWithTitle() {
    showTolyPopPicker(
      context: context,
      title: const Text('选择操作',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      tasks: [
        TolyPopItem(
          info: '编辑',
          task: () {
            setState(() => _selectedAction = '编辑');
          },
        ),
        TolyPopItem(
          info: '删除',
          task: () {
            setState(() => _selectedAction = '删除');
          },
        ),
        TolyPopItem(
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
        TolyPopItem(
          info: '保存到本地',
          task: () {
            setState(() => _selectedAction = '保存到本地');
          },
        ),
        TolyPopItem(
          info: '发送给朋友',
          task: () {
            setState(() => _selectedAction = '发送给朋友');
          },
        ),
        TolyPopItem(
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
      title: const Text('选中你擅长的语言'),
      theme: const TolyPopPickerTheme(
          borderRadius: 20.0,
          separatorHeight: 8,
          itemHeight: 58,
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
          itemTextStyle: TextStyle(
              color: Colors.indigo, fontSize: 16, fontWeight: FontWeight.w500),
          cancelTextStyle: TextStyle(
              color: Colors.blueAccent,
              fontSize: 16,
              fontWeight: FontWeight.w600)),
      tasks: ['Dart', 'Kotlin', 'Java']
          .map((e) => TolyPopItem(
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
                      TolyPopItem(
                        info: '蓝色主题',
                        task: () => setState(() => _selectedAction = '蓝色主题'),
                      ),
                      TolyPopItem(
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
              onPressed: _showBasicPicker,
              child: const Text('基础选择器'),
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
