# TolyUI Tag

一个功能丰富的Flutter标签组件库，提供基础标签、可选择标签和标签组功能，支持多种样式变体和主题定制。

## 功能特性

- **基础标签 (Tag)**: 支持多种样式变体（填充、实心、轮廓）
- **可选择标签 (CheckableTag)**: 支持选中/未选中状态切换
- **标签组 (CheckableTagGroup)**: 支持单选和多选模式
- **丰富的自定义选项**: 颜色、图标、关闭按钮等
- **动画效果**: 平滑的悬浮和关闭动画
- **主题定制**: 完整的主题系统支持
- **响应式交互**: 支持悬浮、点击、禁用状态

## 安装

在 `pubspec.yaml` 文件中添加依赖：

```yaml
dependencies:
  tolyui_tag: ^0.0.1
```

然后运行：

```bash
flutter pub get
```

## 使用方法

### 导入包

```dart
import 'package:tolyui_tag/tolyui_tag.dart';
```

### 基础标签

```dart
// 基础标签
Tag(
  child: Text('默认标签'),
)

// 带颜色的标签
Tag(
  color: Colors.blue,
  child: Text('蓝色标签'),
)

// 可关闭标签
Tag(
  closable: true,
  onClose: () => print('标签已关闭'),
  child: Text('可关闭标签'),
)

// 带图标的标签
Tag(
  icon: Icon(Icons.star, size: 12),
  child: Text('带图标标签'),
)
```

### 标签样式变体

```dart
// 填充样式（默认）
Tag(
  variant: TagVariant.filled,
  color: Colors.green,
  child: Text('填充标签'),
)

// 实心样式
Tag(
  variant: TagVariant.solid,
  color: Colors.red,
  child: Text('实心标签'),
)

// 轮廓样式
Tag(
  variant: TagVariant.outlined,
  color: Colors.orange,
  child: Text('轮廓标签'),
)
```

### 可选择标签

```dart
bool isChecked = false;

CheckableTag(
  checked: isChecked,
  onChange: (checked) {
    setState(() {
      isChecked = checked;
    });
  },
  child: Text('可选择标签'),
)
```

### 标签组

```dart
// 单选标签组
String? selectedValue;

CheckableTagGroup<String>(
  options: [
    CheckableTagOption(value: 'option1', label: Text('选项1')),
    CheckableTagOption(value: 'option2', label: Text('选项2')),
    CheckableTagOption(value: 'option3', label: Text('选项3')),
  ],
  value: selectedValue,
  onChange: (value) {
    setState(() {
      selectedValue = value;
    });
  },
)

// 多选标签组
List<String> selectedValues = [];

CheckableTagGroup<String>(
  multiple: true,
  options: [
    CheckableTagOption(value: 'tag1', label: Text('标签1')),
    CheckableTagOption(value: 'tag2', label: Text('标签2')),
    CheckableTagOption(value: 'tag3', label: Text('标签3')),
  ],
  values: selectedValues,
  onChangeMultiple: (values) {
    setState(() {
      selectedValues = values;
    });
  },
)
```

### 主题定制

```dart
final customTheme = TagTheme(
  defaultBg: Colors.grey[100]!,
  defaultColor: Colors.black87,
  colorPrimary: Colors.purple,
  borderRadius: 8.0,
  fontSize: 14.0,
  // ... 其他主题属性
);

Tag(
  theme: customTheme,
  child: Text('自定义主题标签'),
)
```

## API 参考

### Tag 属性

| 属性 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| child | Widget? | null | 标签内容 |
| color | Color? | null | 标签颜色 |
| variant | TagVariant | filled | 样式变体 |
| closable | bool | false | 是否可关闭 |
| onClose | VoidCallback? | null | 关闭回调 |
| icon | Widget? | null | 前置图标 |
| disabled | bool | false | 是否禁用 |
| onTap | VoidCallback? | null | 点击回调 |
| theme | TagTheme? | null | 自定义主题 |

### CheckableTag 属性

| 属性 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| checked | bool | required | 是否选中 |
| onChange | ValueChanged<bool>? | null | 状态变化回调 |
| child | Widget? | null | 标签内容 |
| disabled | bool | false | 是否禁用 |
| theme | TagTheme? | null | 自定义主题 |

### CheckableTagGroup 属性

| 属性 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| options | List<CheckableTagOption<T>> | required | 选项列表 |
| multiple | bool | false | 是否多选 |
| value | T? | null | 单选值 |
| values | List<T>? | null | 多选值 |
| onChange | ValueChanged<T?>? | null | 单选回调 |
| onChangeMultiple | ValueChanged<List<T>>? | null | 多选回调 |
| gap | double | 8.0 | 标签间距 |
| disabled | bool | false | 是否禁用 |

## 许可证

本项目采用 MIT 许可证。详情请参阅 [LICENSE](LICENSE) 文件。
