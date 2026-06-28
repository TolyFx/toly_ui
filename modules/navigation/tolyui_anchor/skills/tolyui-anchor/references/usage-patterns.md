# TolyUI Anchor 使用模式

## 包接口

导入：

```dart
import 'package:tolyui_anchor/tolyui_anchor.dart';
```

核心类型：

- `TolyAnchorController`：持有滚动控制和激活索引状态。
- `TolyAnchorLink`：导航项，包含 `title`、`href` 和可选的 `children`。
- `TolyAnchor`：导航列表。支持 `linkBuilder`、`scrollController`、`scrollOffset`、`shrinkWrap` 和 `scrollDirection`。
- `TolyAnchorScrollable`：由 `ScrollablePositionedList` 支撑的内容列表。

本地源码：

- 模块 API：`modules/navigation/tolyui_anchor/lib/src/toly_anchor.dart`
- 导出文件：`modules/navigation/tolyui_anchor/lib/tolyui_anchor.dart`
- 应用示例：`lib/view/widgets/navigation/anchor/anchor_demo1.dart` 至 `anchor_demo4.dart`

## 基础左侧导航

适用于文档页面、设置页面和简单的章节导航。

```dart
class ExampleAnchorPage extends StatefulWidget {
  const ExampleAnchorPage({super.key});

  @override
  State<ExampleAnchorPage> createState() => _ExampleAnchorPageState();
}

class _ExampleAnchorPageState extends State<ExampleAnchorPage> {
  final TolyAnchorController _controller = TolyAnchorController();

  final List<TolyAnchorLink> _links = const [
    TolyAnchorLink(title: '概览', href: 'overview'),
    TolyAnchorLink(title: '特性', href: 'features'),
    TolyAnchorLink(title: 'API', href: 'api'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 160,
          child: TolyAnchor(
            controller: _controller,
            links: _links,
          ),
        ),
        const VerticalDivider(),
        Expanded(
          child: TolyAnchorScrollable(
            controller: _controller,
            itemCount: _links.length,
            itemBuilder: (context, index) => _buildSection(_links[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(TolyAnchorLink link) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(link.title),
    );
  }
}
```

现有示例：`lib/view/widgets/navigation/anchor/anchor_demo1.dart`。

## 自定义链接样式

当锚点项需要图标、激活背景、紧凑行、计数器或标签样式时，使用 `linkBuilder`。必须手动连接点击事件。

```dart
Widget _buildLink(BuildContext context, TolyAnchorLink link, bool active) {
  final index = _links.indexOf(link);

  return InkWell(
    onTap: () => _controller.scrollToIndex(index),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: active
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08)
            : null,
        border: Border(
          left: BorderSide(
            color: active
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: Text(
        link.title,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          color: active
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade800,
        ),
      ),
    ),
  );
}
```

现有示例：

- 设置风格图标导航：`lib/view/widgets/navigation/anchor/anchor_demo2.dart`
- 紧凑长列表导航：`lib/view/widgets/navigation/anchor/anchor_demo3.dart`

## 长导航列表

适用于数百个章节的场景。`TolyAnchor` 内部使用 `ListView.builder`；`TolyAnchorScrollable` 懒加载构建内容。

模式：

```dart
final TolyAnchorController _controller = TolyAnchorController();
final ScrollController _navScrollController =
    ScrollController(keepScrollOffset: false);

late final List<TolyAnchorLink> _links;

@override
void dispose() {
  _controller.dispose();
  _navScrollController.dispose();
  super.dispose();
}

// ...
Expanded(
  child: TolyAnchor(
    controller: _controller,
    links: _links,
    linkBuilder: _buildCompactLink,
    scrollController: _navScrollController,
  ),
)
```

保持链接构建器轻量。对于非常大的列表，如果能一次性捕获或映射稳定的索引，避免昂贵的列表搜索。

现有示例：`lib/view/widgets/navigation/anchor/anchor_demo3.dart`。

## 横向锚点标签

适用于顶部标签，导航为横向，内容保持竖直。

```dart
Column(
  children: [
    SizedBox(
      height: 48,
      child: TolyAnchor(
        controller: _controller,
        links: _links,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        linkBuilder: _buildTabLink,
      ),
    ),
    Expanded(
      child: TolyAnchorScrollable(
        controller: _controller,
        itemCount: _links.length,
        itemBuilder: (context, index) => _buildSection(index),
      ),
    ),
  ],
)
```

为标签栏使用固定高度，并为每个标签提供足够的水平内边距。如果标签列表很长，确保父容器允许横向滚动。

现有示例：`lib/view/widgets/navigation/anchor/anchor_demo4.dart`。

## 常见陷阱

- `activeTag` 当前返回 `item_$activeIndex`；不要依赖它回显原始的 `href`。
- `TolyAnchorLink` 上存在 `children`，但当前 `TolyAnchor` 渲染器将 `links` 视为扁平列表。
- 当前测试期望 `activeTag` 为 `null`，但实现返回 `item_0`；如果涉及控制器行为，请验证并更新测试。
- 如果激活高亮不跟随内容滚动，检查两个 widget 是否共享同一个控制器，以及 `itemCount` 是否匹配 `links.length`。
- 如果导航不滚动以保持激活项可见，传入一个稳定的导航 `ScrollController`，避免使用新控制器重建整个锚点树。
