# TolyCarousel

TolyCarousel 是 TolyUI 框架中的轮播图组件，提供流畅的图片轮播和内容切换功能。

## 特性

- 支持水平和垂直滚动
- 支持滚动和淡入淡出两种切换效果
- 支持自动播放和自定义间隔时间
- 支持指示器位置配置（上下左右）
- 支持自定义指示器样式
- 支持无限循环滚动
- 提供编程式控制 API

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  toly_carousel: ^0.0.1
```

## 使用

### 基础用法

最简单的轮播图使用方式。

```dart
TolyCarousel(
  height: 200,
  children: [
    Container(color: Colors.red, child: Center(child: Text('1'))),
    Container(color: Colors.blue, child: Center(child: Text('2'))),
    Container(color: Colors.green, child: Center(child: Text('3'))),
  ],
)
```

### 自动播放

通过 autoplay 属性启用自动播放。

```dart
TolyCarousel(
  height: 200,
  autoplay: true,
  autoplaySpeed: 3000,
  children: [
    Container(color: Colors.red),
    Container(color: Colors.blue),
    Container(color: Colors.green),
  ],
)
```

### 淡入淡出效果

使用 fade 效果切换。

```dart
TolyCarousel(
  height: 200,
  effect: CarouselEffect.fade,
  children: [
    Container(color: Colors.red),
    Container(color: Colors.blue),
    Container(color: Colors.green),
  ],
)
```

### 指示器位置

配置指示器的位置。

```dart
TolyCarousel(
  height: 200,
  dotPlacement: DotPlacement.top,
  children: [
    Container(color: Colors.red),
    Container(color: Colors.blue),
    Container(color: Colors.green),
  ],
)
```

### 编程式控制

通过 GlobalKey 控制轮播图。

```dart
final carouselKey = GlobalKey<TolyCarouselState>();

TolyCarousel(
  key: carouselKey,
  height: 200,
  children: [...],
)

// 跳转到指定页
carouselKey.currentState?.goTo(2);

// 下一页
carouselKey.currentState?.next();

// 上一页
carouselKey.currentState?.prev();
```

## API

### TolyCarousel 属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| children | List<Widget> | 必填 | 子组件列表 |
| dots | bool | true | 是否显示指示器 |
| dotPlacement | DotPlacement | bottom | 指示器位置 |
| autoplay | bool | false | 是否自动播放 |
| autoplaySpeed | int | 3000 | 自动播放间隔（毫秒） |
| effect | CarouselEffect | scroll | 切换效果 |
| vertical | bool | false | 是否垂直滚动 |
| initialSlide | int | 0 | 初始显示的索引 |
| infinite | bool | true | 是否无限循环 |
| duration | Duration | 300ms | 切换动画时长 |
| curve | Curve | easeInOut | 切换动画曲线 |
| height | double? | null | 高度 |
| onChanged | ValueChanged<int>? | null | 切换回调 |
| dotBuilder | Widget Function(int, bool)? | null | 自定义指示器 |

## 设计理念

TolyCarousel 的设计参考了 Ant Design 的 Carousel 组件，使用 Flutter 的 PageView 实现流畅的滚动效果。组件支持水平和垂直两种滚动方向，可以灵活配置指示器的位置。

自动播放功能通过 Timer 实现，在组件销毁时会自动清理定时器，避免内存泄漏。组件提供了编程式控制 API，开发者可以通过 GlobalKey 获取 State 对象，调用 goTo、next、prev 等方法控制轮播图的切换。

## 许可证

本项目采用 MIT 许可证。

## 关于 TolyUI

TolyUI 是一个为 Flutter 开发者打造的 UI 组件库，致力于提供简洁、优雅、实用的组件解决方案。

展示网站: http://toly1994.com/ui
