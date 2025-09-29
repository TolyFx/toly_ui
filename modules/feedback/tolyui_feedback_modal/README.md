# TolyUI Feedback Modal

一个功能强大的 Flutter 底部弹窗选择器，支持异步任务、状态监听、超时取消和主题自定义。

## 功能特性

- ✅ **异步任务支持** - 支持异步操作和状态回调
- ✅ **超时取消机制** - 任务超时自动取消，避免资源浪费
- ✅ **状态监听** - 实时监听加载、成功、失败、超时状态
- ✅ **主题自定义** - 支持亮色/暗色主题，可自定义所有样式
- ✅ **灵活配置** - 支持标题、消息、取消按钮等多种配置
- ✅ **类型安全** - 完整的泛型支持

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  tolyui_feedback_modal: ^1.0.0
```

## 基础用法

### 简单选择器

```dart
showTolyPopPicker(
  context: context,
  title: Text('选择操作'),
  tasks: [
    TolyMenuItem(
      info: '编辑',
      task: () => print('编辑'),
    ),
    TolyMenuItem(
      info: '删除', 
      task: () => print('删除'),
    ),
  ],
);
```

### 异步任务

```dart
showTolyPopPicker<String>(
  context: context,
  title: Text('网络操作'),
  tasks: [
    TolyMenuItem<String>(
      info: '上传文件',
      task: () async {
        await Future.delayed(Duration(seconds: 2));
        return '上传成功';
      },
    ),
  ],
);
```

### 状态监听

```dart
showTolyPopPicker(
  context: context,
  tasks: [...],
  onStatusChange: (status) {
    if (status is Loading) {
      print('加载中...');
    } else if (status is Success) {
      print('成功: ${status.data}');
    } else if (status is Failure) {
      print('失败: ${status.error}');
    } else if (status is Timeout) {
      print('超时');
    }
  },
);
```

## 主题自定义

### 使用预设主题

```dart
// 亮色主题
MaterialApp(
  theme: ThemeData(
    extensions: [TolyPopPickerTheme.light()],
  ),
);

// 暗色主题
MaterialApp(
  theme: ThemeData(
    extensions: [TolyPopPickerTheme.dark()],
  ),
);
```

### 自定义主题

```dart
showTolyPopPicker(
  context: context,
  theme: TolyPopPickerTheme(
    backgroundColor: Colors.blue,
    borderRadius: 20.0,
    itemHeight: 60.0,
    itemTextStyle: TextStyle(
      fontSize: 18,
      color: Colors.white,
    ),
  ),
  tasks: [...],
);
```

## 超时控制

任务默认 5 秒超时，超时后自动取消：

```dart
TolyMenuItem(
  info: '长时间任务',
  task: () async {
    // 这个任务如果超过 5 秒会被自动取消
    await Future.delayed(Duration(seconds: 10));
    return '完成';
  },
);
```

## API 参考

### showTolyPopPicker 参数

| 参数 | 类型 | 描述 |
|------|------|------|
| context | BuildContext | 上下文 |
| tasks | List<TolyMenuItem<T>> | 任务列表 |
| title | Widget? | 标题 |
| message | String? | 消息文本 |
| theme | TolyPopPickerTheme? | 自定义主题 |
| cancelText | String | 取消按钮文本 |
| onStatusChange | OnStateChange<T>? | 状态变化回调 |

### TolyMenuItem 参数

| 参数 | 类型 | 描述 |
|------|------|------|
| info | String | 显示文本 |
| task | Task<T>? | 异步任务 |
| content | Widget? | 自定义内容 |
| loadingBuilder | WidgetBuilder? | 加载状态构建器 |

## 许可证

MIT License
