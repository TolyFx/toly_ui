# TolyDefault

TolyDefault 是 TolyUI 框架中的缺省页组件，用于在空状态、无数据、无权限等场景下向用户展示友好的提示信息。组件通过图片、文字和操作按钮的组合，引导用户理解当前状态并采取相应行动。

## 特性

TolyDefault 提供了灵活的缺省页展示能力。组件支持自定义图片、标题、描述文字和操作按钮，可以根据不同场景组合使用。通过简洁的 API 设计，你可以快速构建出符合产品风格的缺省页面。

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  toly_default: ^0.0.1
```

## 使用

### 基础用法

最简单的缺省页展示，只包含图片和标题。

```dart
TolyDefault(
  image: Icon(Icons.inbox, size: 80, color: Colors.grey),
  title: '暂无数据',
)
```

### 使用预设类型

通过 type 属性快速使用内置的缺省页类型。

```dart
TolyDefault(
  type: DefaultType.empty,
)
```

支持的预设类型：
- `DefaultType.empty` - 空数据
- `DefaultType.noResult` - 搜索无结果
- `DefaultType.networkError` - 网络错误
- `DefaultType.noPermission` - 无权限
- `DefaultType.notFound` - 404 未找到
- `DefaultType.serverError` - 服务器错误

### 自定义类型

可以创建自定义的缺省页类型。

```dart
final customType = DefaultType(
  key: 'maintenance',
  icon: Icons.build_outlined,
  title: '系统维护中',
  description: '系统正在升级，预计 2 小时后恢复',
);

TolyDefault(type: customType)
```

### 带描述的缺省页

通过 description 属性添加详细说明，帮助用户理解当前状态。

```dart
TolyDefault(
  image: Icon(Icons.search_off, size: 80, color: Colors.grey),
  title: '未找到相关内容',
  description: '请尝试使用其他关键词搜索',
)
```

### 带操作按钮的缺省页

通过 action 属性添加操作按钮，引导用户采取行动。

```dart
TolyDefault(
  image: Icon(Icons.cloud_off, size: 80, color: Colors.grey),
  title: '网络连接失败',
  description: '请检查网络设置后重试',
  action: ElevatedButton(
    onPressed: () {
      // 重试逻辑
    },
    child: Text('重新加载'),
  ),
)
```

### 自定义图片

使用自定义图片或插画来提升视觉效果。

```dart
TolyDefault(
  image: Image.asset('assets/empty.png'),
  imageSize: 200,
  title: '购物车是空的',
  description: '快去挑选心仪的商品吧',
  action: TextButton(
    onPressed: () {
      // 跳转到商品列表
    },
    child: Text('去逛逛'),
  ),
)
```

### 调整间距

通过 spacing 属性控制元素之间的间距。

```dart
TolyDefault(
  image: Icon(Icons.folder_open, size: 80, color: Colors.grey),
  title: '文件夹为空',
  spacing: 24,
)
```

### 主题定制

通过 DefaultThemeScope 自定义缺省页主题，实现全局样式统一。

```dart
final customTheme = DefaultTheme(
  iconColor: Colors.blue,
  titleStyle: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.blue.shade700,
  ),
);

final customType = DefaultType(
  key: 'custom',
  icon: Icons.folder_open,
  title: '自定义标题',
  description: '自定义描述',
);

DefaultThemeScope(
  theme: customTheme,
  child: TolyDefault(type: customType),
)
```

### 使用图片资源

可以创建使用图片资源的类型。

```dart
final imageType = DefaultType(
  key: 'emptyWithImage',
  imagePath: 'assets/images/empty.png',
  title: '暂无数据',
  description: '当前列表为空',
);

TolyDefault(type: imageType)
```

## API

### TolyDefault 属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| type | DefaultType? | null | 预设类型 |
| image | Widget? | null | 缺省页图片或图标 |
| title | String? | null | 标题文字 |
| description | String? | null | 描述文字 |
| action | Widget? | null | 操作按钮或其他交互组件 |
| spacing | double? | 16 | 元素之间的间距 |
| imageSize | double? | 160 | 图片容器的尺寸 |
| iconColor | Color? | null | 图标颜色 |
| titleStyle | TextStyle? | null | 标题样式 |
| descriptionStyle | TextStyle? | null | 描述样式 |

### DefaultType 属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| key | String | 必填 | 类型唯一标识 |
| icon | IconData? | null | 图标，与 imagePath 二选一 |
| imagePath | String? | null | 图片资源路径，与 icon 二选一 |
| title | String | 必填 | 标题文字 |
| description | String | 必填 | 描述文字 |

### DefaultTheme 属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| iconSize | double | 80 | 图标尺寸 |
| iconColor | Color? | null | 图标颜色 |
| titleStyle | TextStyle? | null | 标题样式 |
| descriptionStyle | TextStyle? | null | 描述样式 |
| spacing | double | 16 | 元素间距 |

## 设计理念

TolyDefault 的设计遵循简洁友好的原则。缺省页不应该让用户感到困惑或沮丧，而应该通过清晰的视觉语言告诉用户发生了什么，以及可以做什么。

组件采用居中布局，让内容成为视觉焦点。图片作为视觉锚点，帮助用户快速理解当前状态。标题用简短的文字说明情况，描述提供更多细节。操作按钮则给出明确的行动指引，让用户知道下一步该做什么。

间距的设计考虑了视觉层次和阅读节奏。图片与文字之间的间距较大，形成明显的视觉分组。标题与描述之间的间距较小，保持内容的连贯性。这种层次感让信息传达更加清晰有效。

预设类型和主题系统让组件更加灵活。通过预设类型，开发者可以快速应用常见场景的缺省页，无需重复配置。通过主题系统，可以在全局统一缺省页的视觉风格，也可以针对特定场景进行定制，满足不同产品的设计需求。

## 许可证

本项目采用 MIT 许可证。

## 关于 TolyUI

TolyUI 是一个为 Flutter 开发者打造的 UI 组件库，致力于提供简洁、优雅、实用的组件解决方案。

展示网站: http://toly1994.com/ui
