# TolyuiDebug

TolyuiDebug 是 TolyUI 框架中的调试工具组件，提供设备外观模拟器等调试辅助功能。

## 特性

- 设备外观框架展示（手机、平板、电脑）
- 支持自定义尺寸、像素密度和样式
- 适用于 Web 端展示多设备效果

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  tolyui_debug: ^0.0.1
```

## 使用

### 基础用法

使用 DeviceFrame 包裹你的内容，模拟设备外观：

```dart
DeviceFrame(
  child: YourApp(),
)
```

### 自定义尺寸和像素密度

```dart
DeviceFrame(
  width: 390,
  height: 844,
  devicePixelRatio: 3.0,
  frameColor: Colors.grey[900]!,
  child: YourApp(),
)
```

## API

### DeviceFrame 属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| child | Widget | - | 设备屏幕内容 |
| width | double | 375 | 屏幕宽度 |
| height | double | 812 | 屏幕高度 |
| devicePixelRatio | double | 3.0 | 设备像素密度 |
| frameColor | Color | Colors.black | 边框颜色 |
| borderRadius | double | 40 | 圆角半径 |
| notchWidth | double | 150 | 刘海宽度 |
| notchHeight | double | 30 | 刘海高度 |

## 设计理念

在 Web 端展示 Flutter 应用时，直接展示内容缺少设备的视觉感受。DeviceFrame 通过模拟真实设备外观和像素密度，让 Web 端的展示更具沉浸感，帮助用户更好地理解不同设备的实际效果。

## 许可证

本项目采用 MIT 许可证。

## 关于 TolyUI

TolyUI 是一个为 Flutter 开发者打造的 UI 组件库，致力于提供简洁、优雅、实用的组件解决方案。

展示网站: http://toly1994.com/ui
