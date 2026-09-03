/// 提供 JSON 编辑器与查看器的独立交互调试应用。
library;

import 'package:flutter/material.dart';
import 'package:tolyui_json_editor/tolyui_json_editor.dart';

const String _sampleJson = '''{
  "project": "tolyui_json_editor",
  "version": "0.0.1+1",
  "features": [
    "syntax highlighting",
    "validation",
    "format and minify",
    "source folding"
  ],
  "settings": {
    "enabled": true,
    "refreshRate": 60,
    "theme": null
  }
}''';

void main() {
  runApp(const JsonEditorExampleApp());
}

class JsonEditorExampleApp extends StatefulWidget {
  const JsonEditorExampleApp({super.key});

  @override
  State<JsonEditorExampleApp> createState() => _JsonEditorExampleAppState();
}

class _JsonEditorExampleAppState extends State<JsonEditorExampleApp> {
  /// 当前应用主题模式。
  ThemeMode _themeMode = ThemeMode.light;

  /// 切换亮色与暗色主题，便于核对组件主题适配。
  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  /// 创建不带紫色色偏的石墨灰与青绿色亮色主题。
  ThemeData _buildLightTheme() {
    const ColorScheme colors = ColorScheme.light(
      primary: Color(0xff0f766e),
      onPrimary: Colors.white,
      primaryContainer: Color(0xffccfbf1),
      onPrimaryContainer: Color(0xff134e4a),
      secondary: Color(0xff0891b2),
      onSecondary: Colors.white,
      surface: Color(0xfffafafa),
      onSurface: Color(0xff18181b),
      outline: Color(0xffa1a1aa),
      outlineVariant: Color(0xffe4e4e7),
    );
    return ThemeData(
      colorScheme: colors,
      scaffoldBackgroundColor: const Color(0xfff4f4f5),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xfffafafa),
        foregroundColor: Color(0xff18181b),
      ),
      useMaterial3: true,
    );
  }

  /// 创建不带紫色色偏的深灰与青绿色暗色主题。
  ThemeData _buildDarkTheme() {
    const ColorScheme colors = ColorScheme.dark(
      primary: Color(0xff5eead4),
      onPrimary: Color(0xff042f2e),
      primaryContainer: Color(0xff115e59),
      onPrimaryContainer: Color(0xffccfbf1),
      secondary: Color(0xff67e8f9),
      onSecondary: Color(0xff083344),
      surface: Color(0xff18181b),
      onSurface: Color(0xfff4f4f5),
      outline: Color(0xff71717a),
      outlineVariant: Color(0xff3f3f46),
    );
    return ThemeData(
      colorScheme: colors,
      scaffoldBackgroundColor: const Color(0xff09090b),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff18181b),
        foregroundColor: Color(0xfff4f4f5),
      ),
      useMaterial3: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TolyUI JSON Editor',
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: _themeMode,
      home: JsonEditorWorkbench(onToggleTheme: _toggleTheme),
    );
  }
}

class JsonEditorWorkbench extends StatefulWidget {
  /// 切换应用主题的动作。
  final VoidCallback onToggleTheme;

  const JsonEditorWorkbench({super.key, required this.onToggleTheme});

  @override
  State<JsonEditorWorkbench> createState() => _JsonEditorWorkbenchState();
}

class _JsonEditorWorkbenchState extends State<JsonEditorWorkbench> {
  /// 编辑器当前 JSON 文本。
  String _json = _sampleJson;

  /// 恢复用于调试的有效 JSON 示例。
  void _resetSample() {
    setState(() => _json = _sampleJson);
  }

  /// 注入错误 JSON，便于调试校验提示和禁用工具栏状态。
  void _loadInvalidSample() {
    setState(() => _json = '{"invalid": true,}');
  }

  /// 接收编辑器变更并实时驱动右侧预览。
  void _handleChanged(String value) {
    setState(() => _json = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TolyUI JSON Editor Workbench'),
        actions: <Widget>[
          IconButton(
            tooltip: '切换主题',
            onPressed: widget.onToggleTheme,
            icon: const Icon(Icons.brightness_6_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildActions(),
            const SizedBox(height: 16),
            Expanded(child: _buildWorkbench()),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: <Widget>[
        FilledButton.tonalIcon(
          onPressed: _resetSample,
          icon: const Icon(Icons.restart_alt),
          label: const Text('恢复示例'),
        ),
        OutlinedButton.icon(
          onPressed: _loadInvalidSample,
          icon: const Icon(Icons.error_outline),
          label: const Text('载入错误 JSON'),
        ),
      ],
    );
  }

  Widget _buildWorkbench() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(child: _buildEditorPanel()),
              const SizedBox(width: 16),
              Expanded(child: _buildViewerPanel()),
            ],
          );
        }
        return DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              const TabBar(
                tabs: <Widget>[
                  Tab(text: '编辑器'),
                  Tab(text: '预览'),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TabBarView(
                  children: <Widget>[_buildEditorPanel(), _buildViewerPanel()],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEditorPanel() {
    return _WorkbenchPanel(
      title: '实时编辑',
      description: '可测试校验、格式化、压缩和主题样式。',
      child: SingleChildScrollView(
        child: TolyJsonEditor(
          value: _json,
          label: 'JSON 内容',
          hint: '请输入 JSON',
          minLines: 18,
          maxLines: 32,
          showLineNumbers: true,
          onChanged: _handleChanged,
        ),
      ),
    );
  }

  Widget _buildViewerPanel() {
    return _WorkbenchPanel(
      title: '源码预览',
      description: '可测试复制、行号切换以及对象和数组折叠。',
      child: TolyJsonViewer(jsonString: _json, showLineNumbers: true),
    );
  }
}

class _WorkbenchPanel extends StatelessWidget {
  /// 面板标题。
  final String title;

  /// 面板用途说明。
  final String description;

  /// 面板承载的调试组件。
  final Widget child;

  const _WorkbenchPanel({
    required this.title,
    required this.description,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(description, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
