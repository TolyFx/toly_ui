# TolyJsonEditor

JSON 编辑器组件，支持语法高亮、格式化、压缩和验证。

## 功能特性

- ✅ JSON 语法高亮（Key、String、Number、Boolean、Null）
- ✅ 实时验证，显示错误信息
- ✅ 格式化（Format）和压缩（Minify）
- ✅ 自定义样式（亮色/暗色主题）
- ✅ 禁用状态支持
- ✅ 可配置工具栏和验证显示

## 安装

在 `pubspec.yaml` 中添加：

```yaml
dependencies:
  tolyui_json_editor: ^0.0.1+1
```

## 使用示例

### 基础用法

```dart
import 'package:tolyui_json_editor/tolyui_json_editor.dart';

TolyJsonEditor(
  value: '{"name": "John", "age": 30}',
  label: 'JSON 配置',
  onChanged: (json) => print('JSON changed: $json'),
)
```

### 自定义样式

```dart
TolyJsonEditor(
  value: jsonString,
  style: JsonEditorStyle.dark(),
  minLines: 6,
  maxLines: 20,
)
```

### 禁用状态

```dart
TolyJsonEditor(
  value: jsonString,
  enabled: false,
  showToolbar: false,
)
```

### 隐藏工具栏

```dart
TolyJsonEditor(
  value: jsonString,
  showToolbar: false,
  showValidation: false,
)
```

## API 文档

### TolyJsonEditor

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| value | String | required | JSON 文本内容 |
| label | String? | null | 标签文本 |
| hint | String? | null | 占位提示 |
| minLines | int | 4 | 最小行数 |
| maxLines | int | 12 | 最大行数 |
| onChanged | ValueChanged<String>? | null | 值变化回调 |
| style | JsonEditorStyle? | null | 样式配置 |
| enabled | bool | true | 是否启用 |
| showToolbar | bool | true | 是否显示工具栏 |
| showValidation | bool | true | 是否显示验证状态 |

### JsonEditorStyle

提供三种工厂方法：

- `JsonEditorStyle.fromTheme(ThemeData)` - 从主题创建
- `JsonEditorStyle.light()` - 亮色主题
- `JsonEditorStyle.dark()` - 暗色主题

可自定义的颜色：

- 语法高亮：keyColor, stringColor, numberColor, boolColor, nullColor, bracketColor
- 边框：borderColor, focusBorderColor
- 状态：errorColor, validColor
- 背景：backgroundColor, disabledColor
- 其他：cursorColor, toolbarIconColor, disabledIconColor

## 完整示例

```dart
class JsonEditorDemo extends StatefulWidget {
  @override
  State<JsonEditorDemo> createState() => _JsonEditorDemoState();
}

class _JsonEditorDemoState extends State<JsonEditorDemo> {
  String _json = '{"name": "John", "age": 30}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('JSON Editor Demo')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: TolyJsonEditor(
          value: _json,
          label: 'User Config',
          hint: 'Enter JSON here...',
          minLines: 6,
          maxLines: 20,
          onChanged: (value) => setState(() => _json = value),
          style: JsonEditorStyle.fromTheme(Theme.of(context)),
        ),
      ),
    );
  }
}
```

## License

Apache-2.0
