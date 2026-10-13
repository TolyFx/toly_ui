# TolyDropSelect 使用指南

`TolyDropSelect<T>` 是面向桌面端属性面板设计的紧凑型下拉选择器。它支持泛型值、受控状态、前置图标、尾缀信息、禁用选项，以及与触发框同宽的下拉面板。

组件本身不绑定具体业务数据或导出格式，截图中的导出格式选择器只是其中一种典型用法。

## 完整案例：导出属性面板

下面的案例复现截图中的结构和交互：顶部显示“导出属性 / EXPORT”，下拉框展示当前格式及扩展名；展开后，选中项以主题色高亮，对钩位于扩展名之前，菜单与触发框保持同宽。

```dart
import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

enum ExportFormat {
  jsonHash,
  jsonArray,
  cocosPlist,
  libGdxAtlas,
}

class ExportPropertiesPanel extends StatefulWidget {
  const ExportPropertiesPanel({super.key});

  @override
  State<ExportPropertiesPanel> createState() =>
      _ExportPropertiesPanelState();
}

class _ExportPropertiesPanelState extends State<ExportPropertiesPanel> {
  static const List<TolyDropSelectOption<ExportFormat>> _options =
      <TolyDropSelectOption<ExportFormat>>[
    TolyDropSelectOption<ExportFormat>(
      value: ExportFormat.jsonHash,
      label: 'JSON (Hash)',
      trailing: Text('.json'),
    ),
    TolyDropSelectOption<ExportFormat>(
      value: ExportFormat.jsonArray,
      label: 'JSON (Array)',
      trailing: Text('.json'),
    ),
    TolyDropSelectOption<ExportFormat>(
      value: ExportFormat.cocosPlist,
      label: 'Cocos2d-x / Axmol plist',
      trailing: Text('.plist'),
    ),
    TolyDropSelectOption<ExportFormat>(
      value: ExportFormat.libGdxAtlas,
      label: 'LibGDX / Spine Atlas',
      trailing: Text('.atlas'),
    ),
  ];

  ExportFormat _format = ExportFormat.jsonHash;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: 404,
      child: DecoratedBox(
        decoration: BoxDecoration(color: colors.surface),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '导出属性',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const Spacer(),
                  Text(
                    'EXPORT',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                          letterSpacing: 1.4,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              TolyDropSelect<ExportFormat>(
                value: _format,
                options: _options,
                height: 44,
                itemGap: 4,
                onChanged: _handleFormatChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFormatChanged(ExportFormat value) {
    setState(() => _format = value);
  }
}
```

这里的 `SizedBox(width: 404)` 为组件提供明确的横向约束，因此下拉面板会自动与触发框等宽。`trailing` 用于展示扩展名，不需要自行拼接对钩；当前项被选中时，组件会自动把对钩放在 `trailing` 前面。

## 引入组件

```dart
import 'package:tolyui_navigation/tolyui_navigation.dart';
```

如果项目依赖聚合包 `tolyui`，也可以使用：

```dart
import 'package:tolyui/tolyui.dart';
```

## 基础用法

`TolyDropSelect` 是受控组件。`value` 表示当前值，选择新项目后组件通过 `onChanged` 通知外部更新状态。

```dart
enum ExportFormat { jsonHash, jsonArray, cocosPlist, libGdxAtlas }

class ExportFormatSelect extends StatefulWidget {
  const ExportFormatSelect({super.key});

  @override
  State<ExportFormatSelect> createState() => _ExportFormatSelectState();
}

class _ExportFormatSelectState extends State<ExportFormatSelect> {
  ExportFormat _format = ExportFormat.jsonHash;

  static const List<TolyDropSelectOption<ExportFormat>> _options =
      <TolyDropSelectOption<ExportFormat>>[
        TolyDropSelectOption<ExportFormat>(
          value: ExportFormat.jsonHash,
          label: 'JSON (Hash)',
          trailing: Text('.json'),
        ),
        TolyDropSelectOption<ExportFormat>(
          value: ExportFormat.jsonArray,
          label: 'JSON (Array)',
          trailing: Text('.json'),
        ),
        TolyDropSelectOption<ExportFormat>(
          value: ExportFormat.cocosPlist,
          label: 'Cocos2d-x / Axmol plist',
          trailing: Text('.plist'),
        ),
        TolyDropSelectOption<ExportFormat>(
          value: ExportFormat.libGdxAtlas,
          label: 'LibGDX / Spine Atlas',
          trailing: Text('.atlas'),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: TolyDropSelect<ExportFormat>(
        value: _format,
        options: _options,
        onChanged: _handleFormatChanged,
      ),
    );
  }

  void _handleFormatChanged(ExportFormat value) {
    setState(() => _format = value);
  }
}
```

选择项目后，组件会自动关闭菜单。外部必须更新 `value`，新的选中状态才会显示在触发框和菜单中。

## 选项配置

每个选项使用 `TolyDropSelectOption<T>` 描述：

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| `value` | `T` | 必填 | 业务值，通过 `==` 与组件当前值比较 |
| `label` | `String` | 必填 | 触发框和菜单项中显示的主文本 |
| `leading` | `Widget?` | `null` | 菜单项前置组件；选中后也可显示在触发框中 |
| `trailing` | `Widget?` | `null` | 尾缀组件，适合扩展名、快捷键或状态说明 |
| `enabled` | `bool` | `true` | 是否允许选择该项目 |

选中项目的菜单尾部会先显示对钩，再显示 `trailing`。组件会为尾缀合并默认的紧凑文字和图标样式。

```dart
const TolyDropSelectOption<String>(
  value: 'json',
  label: 'JSON (Hash)',
  leading: Icon(Icons.data_object),
  trailing: Text('.json'),
)
```

## 固定前置组件

默认情况下，触发框使用当前选项的 `leading`。设置 `prefix` 后，所有选项共用固定的触发框前置组件：

```dart
TolyDropSelect<String>(
  value: format,
  options: options,
  prefix: const Icon(Icons.file_present_outlined),
  onChanged: handleFormatChanged,
)
```

`prefix` 只影响触发框，不会替换菜单项各自的 `leading`。

## 尺寸和间距

```dart
TolyDropSelect<String>(
  value: value,
  options: options,
  height: 32,
  maxMenuHeight: 240,
  menuGap: 6,
  itemGap: 4,
  onChanged: handleChanged,
)
```

| 参数 | 默认值 | 说明 |
| --- | --- | --- |
| `height` | `28` | 触发框高度 |
| `maxMenuHeight` | `280` | 菜单最大高度，超出后由菜单系统处理滚动 |
| `menuGap` | `4` | 触发框和菜单之间的垂直距离 |
| `itemGap` | `4` | 相邻菜单项之间的垂直距离；设为 `0` 可取消 |

菜单宽度自动使用组件收到的最大宽度。为了确保下拉项目与触发框严格对齐，应给组件提供有界宽度：

```dart
SizedBox(
  width: 320,
  child: TolyDropSelect<String>(
    value: value,
    options: options,
    onChanged: handleChanged,
  ),
)
```

在 `Row` 中使用时，可以用 `Expanded` 或 `SizedBox` 提供宽度约束。没有有界宽度时，菜单使用 `160` 作为回退宽度。

## 占位、禁用和只读

当 `value` 为 `null`，或在 `options` 中找不到相等的值时，触发框显示 `placeholder`：

```dart
TolyDropSelect<String>(
  value: null,
  placeholder: '请选择导出格式',
  options: options,
  onChanged: handleChanged,
)
```

设置 `enabled: false` 可以禁用整个组件；将 `onChanged` 设为 `null` 也会使触发框进入不可交互状态。

```dart
TolyDropSelect<String>(
  value: value,
  options: options,
  enabled: canEdit,
  onChanged: canEdit ? handleChanged : null,
)
```

单个选项可以通过 `TolyDropSelectOption.enabled` 禁用，禁用项仍然展示，但不会响应选择。

## 主题

组件读取当前 `ThemeData.colorScheme` 和 `ThemeData.brightness`，会自动适配亮色与暗色主题。常用颜色来源如下：

- 选中状态：`colorScheme.primary`
- 面板背景：`colorScheme.surface`
- 普通文本：`colorScheme.onSurface`
- 次级信息：`colorScheme.onSurfaceVariant`

如果需要改变整体视觉，请优先在应用主题中配置 `ColorScheme`，避免为单个下拉框复制样式。

## 常见问题

### 选择后界面没有更新

`TolyDropSelect` 不会在内部保存业务值。请在 `onChanged` 中更新外部状态，并将新值重新传给 `value`。

### 下拉菜单没有和触发框同宽

检查父组件是否提供了明确的宽度约束。在横向布局中使用 `Expanded`、`Flexible` 或 `SizedBox`。

### 选项对象是自定义类型，但无法显示选中状态

组件通过 `option.value == value` 判断选中状态。请复用同一个对象实例，或为自定义值类型正确实现 `operator ==` 和 `hashCode`。

### 如何隐藏选中对钩

当前版本会固定为选中项显示对钩，并将对钩放在 `trailing` 前面，暂未提供关闭参数。

