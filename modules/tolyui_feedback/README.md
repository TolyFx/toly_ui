# TolyUI Feedback

一个功能丰富的 Flutter 反馈组件库，提供多种用户交互反馈组件。

## 📋 功能概览

本插件提供了完整的用户反馈交互解决方案，包含以下核心组件：

| 组件 | 功能 | 特点 |
|------|------|------|
| **TolyPopPicker** | 底部选择器 | 圆角设计、主题定制、安全区适配 |
| **TolyPopover** | 智能弹出层 | 多方向定位、控制器模式、碰撞检测 |
| **TolyTooltip** | 轻量提示框 | 气泡装饰、悬停触发、富文本支持 |
| **BubbleDecoration** | 气泡装饰器 | 自定义尖角、多方向支持、阴影效果 |

### 🎯 核心优势

- **🎨 主题系统**: 支持 ThemeExtension，完美集成 Flutter 主题体系
- **📱 移动优化**: 自动适配安全区，支持各种屏幕尺寸
- **🔧 高度定制**: 丰富的配置选项，满足各种设计需求
- **⚡ 性能优化**: 智能位置计算，流畅的动画效果
- **🛡️ 稳定可靠**: 完善的边界检测和错误处理

## 组件列表

### 📱 TolyPopPicker - 底部选择器

优雅的底部弹出选择器，支持自定义主题和圆角设计。

#### 基础用法

```dart
showTolyPopPicker(
  context: context,
  tasks: [
    TolyPopItem(
      info: '拍照',
      task: () {
        // 处理拍照逻辑
      },
    ),
    TolyPopItem(
      info: '从相册选择',
      task: () {
        // 处理相册选择逻辑
      },
    ),
  ],
);
```

#### 带标题和消息

```dart
showTolyPopPicker(
  context: context,
  title: const Text('选择操作'),
  message: '请选择您要执行的操作',
  cancelText: '关闭',
  tasks: [...],
);
```

#### 自定义主题

```dart
// 方式1: 直接传入主题
showTolyPopPicker(
  context: context,
  theme: const TolyPopPickerTheme(
    borderRadius: 20.0,
    backgroundColor: Colors.grey,
    itemTextStyle: TextStyle(color: Colors.blue),
  ),
  tasks: [...],
);

// 方式2: 使用 ThemeExtension
MaterialApp(
  theme: ThemeData(
    extensions: [
      TolyPopPickerTheme(
        borderRadius: 16.0,
        itemHeight: 60.0,
      ),
    ],
  ),
)
```

#### 主题配置选项

- `borderRadius`: 圆角半径
- `backgroundColor`: 背景颜色
- `separatorColor`: 分隔线颜色
- `itemHeight`: 选项高度
- `itemTextStyle`: 选项文字样式
- `cancelTextStyle`: 取消按钮文字样式
- `titleTextStyle`: 标题文字样式
- `messageTextStyle`: 消息文字样式

### 🎈 TolyPopover 组件

智能定位的弹出层组件，支持多种弹出方向和自定义样式。

#### 基础用法

```dart
TolyPopover(
  placement: Placement.top,
  overlay: Container(
    padding: EdgeInsets.all(12),
    child: Text('这是一个弹出层'),
  ),
  child: ElevatedButton(
    onPressed: () {},
    child: Text('点击显示弹出层'),
  ),
);
```

#### 使用控制器

```dart
final PopoverController controller = PopoverController();

TolyPopover(
  controller: controller,
  placement: Placement.bottom,
  overlayBuilder: (context) => Container(
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('自定义内容'),
        ElevatedButton(
          onPressed: () => controller.close(),
          child: Text('关闭'),
        ),
      ],
    ),
  ),
  child: IconButton(
    onPressed: () => controller.open(),
    icon: Icon(Icons.more_vert),
  ),
);
```

如何使用(How to use):
- http://toly1994.com/ui/#/widgets/feedback/popover

使用细节文章介绍(The article for detail use):
- https://juejin.cn/spost/7366449497063243787

### 💬 TolyTooltip 组件

轻量级提示组件，支持多种显示位置和自定义样式，支持气泡装饰。

#### 基础用法

```dart
TolyTooltip(
  message: '这是一个提示信息',
  placement: Placement.top,
  child: IconButton(
    onPressed: () {},
    icon: Icon(Icons.help),
  ),
);
```

#### 自定义样式

```dart
TolyTooltip(
  message: '自定义样式提示',
  placement: Placement.bottom,
  decorationConfig: DecorationConfig(
    backgroundColor: Colors.blue,
    textColor: Colors.white,
    radius: Radius.circular(8),
    isBubble: true,
  ),
  child: Text('悬停查看提示'),
);
```

如何使用(How to use):
- http://toly1994.com/ui/#/widgets/feedback/tooltip

使用细节文章介绍(The article for detail use):
- https://juejin.cn/spost/7366449497063243787

### 🎨 BubbleDecoration 装饰器

提供气泡样式的装饰器，支持多种方向的气泡尖角。

#### 基础用法

```dart
Container(
  decoration: BubbleDecoration(
    color: Colors.blue,
    borderColor: Colors.blueAccent,
    placement: Placement.top,
    boxSize: Size(100, 50),
    shiftX: 0,
    style: PaintingStyle.fill,
    radius: Radius.circular(8),
    bubbleMeta: BubbleMeta(
      spineHeight: 8,
      angle: 70,
    ),
  ),
  child: Text('气泡容器'),
);
```

### 📢 App 全局消息通知(Message Notification)

依赖于 [tolyui_message](https://pub.dev/packages/tolyui_message)

## 安装

```yaml
dependencies:
  tolyui_feedback: ^latest_version
```

## 导入

```dart
import 'package:tolyui_feedback/tolyui_feedback.dart';
```

## 特性

- ✅ **TolyPopPicker**: 底部选择器，支持自定义主题和圆角
- ✅ **TolyPopover**: 智能定位弹出层，支持多种弹出方向
- ✅ **TolyTooltip**: 轻量级提示组件，支持气泡装饰
- ✅ **BubbleDecoration**: 气泡样式装饰器
- ✅ 支持 ThemeExtension 主题扩展
- ✅ 自动适配安全区
- ✅ 丰富的配置选项
- ✅ 优雅的动画效果
- ✅ 智能位置计算和碰撞检测

## 示例

查看 `example` 目录获取完整的使用示例。

## 许可证

MIT License
