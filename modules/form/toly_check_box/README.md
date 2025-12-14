# TolyCheckBox

TolyCheckBox 是 TolyUI 框架中的复选框组件，提供了简洁优雅的选择交互体验。组件支持选中、未选中和半选三种状态，并内置了悬停效果和禁用状态的视觉反馈。

## 特性

TolyCheckBox 提供了完整的复选框功能，包括基础的选中切换、带标签的复选框、半选状态支持以及禁用状态处理。组件采用数据驱动的设计理念，通过简单的属性配置即可实现丰富的交互效果。

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  toly_check_box: ^0.0.1
```

## 使用

### 基础用法

最简单的复选框使用方式，通过 value 属性控制选中状态，通过 onChanged 回调处理状态变化。

```dart
TolyCheckBox(
  value: isChecked,
  onChanged: (value) {
    setState(() => isChecked = value);
  },
)
```

### 带标签的复选框

通过 label 属性为复选框添加文本标签，labelSpacing 可以调整标签与复选框之间的间距。

```dart
TolyCheckBox(
  value: isChecked,
  label: Text('同意用户协议'),
  onChanged: (value) {
    setState(() => isChecked = value);
  },
)
```

### 半选状态

当需要表示"部分选中"的语义时，可以使用 indeterminate 属性。这在全选/反选场景中特别有用。

```dart
TolyCheckBox(
  value: false,
  indeterminate: true,
  label: Text('全选'),
  onChanged: (value) {
    // 处理全选逻辑
  },
)
```

### 禁用状态

不传入 onChanged 回调即可将复选框设置为禁用状态，此时组件会显示禁用样式且不响应用户交互。

```dart
TolyCheckBox(
  value: true,
  label: Text('已禁用'),
)
```

### 自定义尺寸和圆角

通过 size 属性调整复选框大小，通过 borderRadius 自定义圆角样式。

```dart
TolyCheckBox(
  value: isChecked,
  size: 20,
  borderRadius: BorderRadius.circular(4),
  onChanged: (value) {
    setState(() => isChecked = value);
  },
)
```

## API

### TolyCheckBox 属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| value | bool | 必填 | 复选框的选中状态 |
| onChanged | ValueChanged<bool>? | null | 状态变化回调，为 null 时组件禁用 |
| label | Widget? | null | 复选框标签 |
| indeterminate | bool | false | 是否为半选状态 |
| size | double | 16 | 复选框尺寸 |
| labelSpacing | double | 6 | 标签与复选框的间距 |
| borderRadius | BorderRadius? | null | 自定义圆角，默认为 size * 0.125 |

## 设计理念

TolyCheckBox 的设计遵循简洁实用的原则。组件通过精心设计的视觉反馈让用户清楚地感知当前状态和可交互性。选中状态使用蓝色背景配合白色对勾图标，未选中状态使用边框样式，半选状态则用横线表示部分选中的语义。

悬停效果的加入让桌面端用户获得更好的交互体验，边框颜色的微妙变化提示了组件的可点击性。禁用状态通过灰色调的视觉处理明确传达了不可操作的信息，避免用户产生困惑。

## 许可证

本项目采用 MIT 许可证。

## 关于 TolyUI

TolyUI 是一个为 Flutter 开发者打造的 UI 组件库，致力于提供简洁、优雅、实用的组件解决方案。

展示网站: http://toly1994.com/ui
