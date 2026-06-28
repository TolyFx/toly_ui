---
name: tolyui-anchor
description: 使用本地 tolyui_anchor 包构建或修改 Flutter 锚点导航。适用于 TolyUI 导航演示或需要 TolyAnchor、TolyAnchorScrollable、TolyAnchorController、锚点链接、滚动监听、自定义 linkBuilder 样式、长锚点列表或横向锚点标签的应用页面。
---

# TolyUI Anchor

使用此技能来添加、修复或解释由本地 `tolyui_anchor` 包提供的锚点导航。

## 组件架构

```mermaid
flowchart TB
    subgraph Controller["TolyAnchorController"]
        ISC["ItemScrollController\n(控制滚动)"]
        IPL["ItemPositionsListener\n(监听可见项)"]
    end
    
    Controller --> Anchor
    Controller --> Scrollable
    
    subgraph Anchor["TolyAnchor"]
        NAV["导航列表"]
    end
    
    subgraph Scrollable["TolyAnchorScrollable"]
        CONTENT["内容区域"]
    end
    
    Anchor <-.->|"联动"| Scrollable
```

## 工作原理

```mermaid
flowchart TD
    A["用户滚动内容"] --> B["ItemPositionsListener 检测可见项"]
    B --> C["更新 activeIndex\n(取第一个可见项)"]
    C --> D["TolyAnchor 收到通知"]
    D --> E["更新导航项高亮状态"]
    D --> F["滚动导航列表确保激活项可见"]
    D --> G["触发 linkBuilder 重新构建"]
```

## 工作流程

1. 检查目标页面，确认它导入了 `package:tolyui_anchor/tolyui_anchor.dart`。
2. 在 `StatefulWidget` 中为每对导航/内容区域创建一个 `TolyAnchorController`。
3. 将锚点数据定义为 `List<TolyAnchorLink>`，其顺序必须与内容项顺序完全匹配。
4. 使用 `TolyAnchor(controller: ..., links: ...)` 渲染导航。
5. 使用 `TolyAnchorScrollable(controller: ..., itemCount: links.length, itemBuilder: ...)` 渲染内容。
6. 在 `dispose` 中释放控制器。

具体的代码模板和本地示例，请阅读 `references/usage-patterns.md`。

## 核心类型

```mermaid
classDiagram
    class TolyAnchorController {
        +int activeIndex
        +String? activeTag
        +ItemScrollController itemScrollController
        +ItemPositionsListener itemPositionsListener
        +scrollToIndex(int index)
        +jumpToIndex(int index)
        +scrollTo(String tag)
        +dispose()
    }
    
    class TolyAnchorLink {
        +String title
        +String href
        +List~TolyAnchorLink~? children
    }
    
    class TolyAnchor {
        +TolyAnchorController controller
        +List~TolyAnchorLink~ links
        +TolyAnchorLinkBuilder? linkBuilder
        +Axis scrollDirection
        +bool shrinkWrap
        +ScrollController? scrollController
    }
    
    class TolyAnchorScrollable {
        +TolyAnchorController controller
        +int itemCount
        +IndexedWidgetBuilder itemBuilder
    }
    
    TolyAnchorController --> TolyAnchor : 控制
    TolyAnchorController --> TolyAnchorScrollable : 控制
    TolyAnchor --> TolyAnchorLink : 渲染
```

## 实现规则

- `TolyAnchor` 和 `TolyAnchorScrollable` 必须共用同一个 `TolyAnchorController`。
- 在自定义 `linkBuilder` 的点击事件中，优先使用 `scrollToIndex(index)`，因为它直接匹配列表顺序。
- 仅当功能天然基于标签驱动时才使用 `scrollTo(href)`；`href` 值由 `TolyAnchor` 注册。
- 保持 `links.length`、`itemCount` 和内容数据长度同步。
- 使用 `StatefulWidget` 持有控制器。不要在 `build` 内部创建控制器。
- 对于长左侧导航，向 `TolyAnchor` 传入专用的 `ScrollController(keepScrollOffset: false)` 并在 dispose 中释放。
- 对于横向顶部标签，设置 `TolyAnchor(scrollDirection: Axis.horizontal, shrinkWrap: true)`，通常保持 `TolyAnchorScrollable` 为竖直方向。
- 通过 `linkBuilder(BuildContext context, TolyAnchorLink link, bool active)` 添加自定义激活样式。

## 适用场景

```mermaid
flowchart LR
    subgraph Docs["文档阅读"]
        D1["API 文档"]
        D2["使用指南"]
        D3["帮助中心"]
    end
    
    subgraph Settings["设置面板"]
        S1["系统设置"]
        S2["用户配置"]
        S3["应用偏好"]
    end
    
    subgraph Content["内容导航"]
        C1["章节目录"]
        C2["文章大纲"]
        C3["商品分类"]
    end
    
    TolyAnchor --> Docs
    TolyAnchor --> Settings
    TolyAnchor --> Content
```

## 参考文档

- `references/usage-patterns.md` - 使用模式和代码模板
- `references/api-reference.md` - API 快速参考
- `references/troubleshooting.md` - 常见问题和解决方案

## 验证

编辑 Flutter 代码后，运行最小范围的检查：

```powershell
flutter analyze
flutter test
```

如果是可视化变更，还需运行应用并验证：

- 点击锚点能滚动内容到对应区域。
- 滚动内容能更新激活的锚点。
- 激活的锚点在长导航列表中保持可见。
- 横向标签不会溢出其固定高度的容器。
