# Ant Empty - Flutter Implementation

Flutter 版本的 Ant Design Empty 组件实现。

## 功能特性

- 🎨 完全还原 Ant Design Empty 组件的视觉效果
- 📱 支持 Flutter Material Design 主题
- 🔧 灵活的自定义选项
- 🌙 自动适配深色模式
- 📦 轻量级实现，无额外依赖

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  ant_empty: ^1.0.0
```

## 基础用法

```dart
import 'package:ant_empty/ant_empty.dart';

// 基础用法
AntEmpty()

// 简单图片
AntEmpty(image: EmptyImageType.simple)

// 自定义描述
AntEmpty(
  description: Text('暂无数据'),
)

// 带操作按钮
AntEmpty(
  description: Text('暂无数据'),
  children: ElevatedButton(
    onPressed: () {},
    child: Text('立即创建'),
  ),
)
```

## API 参数

| 参数 | 类型 | 默认值 | 说明 |
| --- | --- | --- | --- |
| image | `dynamic` | `EmptyImageType.defaultImage` | 自定义图片，支持 Widget、String(URL) 或 EmptyImageType |
| description | `Widget?` | `Text('暂无数据')` | 描述文本 |
| children | `Widget?` | - | 底部内容，通常是操作按钮 |
| style | `BoxDecoration?` | - | 根容器样式 |
| styles | `EmptyStyles?` | - | 各部分样式配置 |
| classNames | `EmptyClassNames?` | - | 类名配置（保持 API 一致性） |

## 预设图片

```dart
// 使用预设的默认图片
AntEmpty.presentedImageDefault

// 使用预设的简单图片  
AntEmpty.presentedImageSimple
```

## 样式自定义

```dart
AntEmpty(
  styles: EmptyStyles(
    root: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(8),
    ),
    image: BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
    ),
    description: TextStyle(
      color: Colors.grey.shade600,
      fontSize: 16,
    ),
    footer: BoxDecoration(
      padding: EdgeInsets.all(16),
    ),
  ),
)
```

## 与原组件的差异

| 原组件特性 | Flutter 实现 | 说明 |
| --- | --- | --- |
| `imageStyle` | `styles.image` | 推荐使用 styles.image |
| CSS 类名 | `classNames` | 保持 API 一致性，实际不生效 |
| RTL 支持 | 自动支持 | Flutter 原生支持 |
| 主题适配 | Material Theme | 自动适配 Material Design |

## 示例

运行示例应用：

```bash
cd example
flutter run
```

## 许可证

MIT License