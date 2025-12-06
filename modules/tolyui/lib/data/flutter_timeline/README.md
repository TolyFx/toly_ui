# Ant Timeline - Flutter Implementation

Flutter 版本的 Ant Design Timeline 组件实现。

## 功能特性

- 🎨 完全还原 Ant Design Timeline 组件的视觉效果
- 📱 支持垂直和水平两种方向
- 🔄 支持多种显示模式（左侧、右侧、交替）
- 🎯 自定义图标、颜色和内容
- ⏳ 支持加载状态
- 🌙 自动适配 Material Design 主题

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  ant_timeline: ^1.0.0
```

## 基础用法

```dart
import 'package:ant_timeline/ant_timeline.dart';

// 基础时间轴
AntTimeline(
  items: [
    TimelineItemType(
      content: Text('Create a services site 2015-09-01'),
    ),
    TimelineItemType(
      content: Text('Solve initial network problems 2015-09-01'),
    ),
    TimelineItemType(
      content: Text('Technical testing 2015-09-01'),
    ),
  ],
)

// 自定义图标和颜色
AntTimeline(
  items: [
    TimelineItemType(
      content: Text('Create a services site'),
      color: Colors.green,
    ),
    TimelineItemType(
      icon: Icon(Icons.access_time, size: 16),
      color: Colors.red,
      content: Text('Technical testing'),
    ),
    TimelineItemType(
      content: Text('Loading...'),
      loading: true,
    ),
  ],
)
```

## API 参数

### AntTimeline

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| items | `List<TimelineItemType>` | `[]` | 时间轴项目列表 |
| mode | `TimelineMode` | `TimelineMode.start` | 显示模式 |
| orientation | `TimelineOrientation` | `TimelineOrientation.vertical` | 方向 |
| variant | `TimelineVariant` | `TimelineVariant.outlined` | 变体样式 |
| reverse | `bool` | `false` | 是否反向显示 |
| style | `BoxDecoration?` | - | 根容器样式 |
| styles | `TimelineStyles?` | - | 各部分样式配置 |

### TimelineItemType

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| title | `Widget?` | - | 标题 |
| content | `Widget?` | - | 内容 |
| color | `Color?` | - | 颜色 |
| icon | `Widget?` | - | 自定义图标 |
| loading | `bool` | `false` | 是否显示加载状态 |
| placement | `TimelineMode?` | - | 位置（仅在交替模式下有效） |

## 显示模式

```dart
// 左侧显示
AntTimeline(mode: TimelineMode.start)

// 右侧显示  
AntTimeline(mode: TimelineMode.end)

// 交替显示
AntTimeline(mode: TimelineMode.alternate)
```

## 方向设置

```dart
// 垂直方向（默认）
AntTimeline(orientation: TimelineOrientation.vertical)

// 水平方向
AntTimeline(orientation: TimelineOrientation.horizontal)
```

## 自定义样式

```dart
AntTimeline(
  styles: TimelineStyles(
    root: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(8),
    ),
    itemIcon: BoxDecoration(
      border: Border.all(color: Colors.blue),
    ),
    itemTitle: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.blue,
    ),
  ),
)
```

## 与原组件的差异

| 原组件特性 | Flutter 实现 | 说明 |
| --- | --- | --- |
| `pending/pendingDot` | `loading` 属性 | 推荐在 items 中直接添加 loading 项目 |
| CSS 类名 | `classNames` | 保持 API 一致性，实际不生效 |
| `left/right` 模式 | `start/end` | 使用更语义化的命名 |
| 响应式布局 | 自动适配 | Flutter 原生支持 |

## 示例

运行示例应用：

```bash
cd example
flutter run
```

## 许可证

MIT License