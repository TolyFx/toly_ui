---
theme: cyanosis
---

![](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/e1b2f7d2ec8b4ca0ac1b5feadf97637b~tplv-k3u1fbpfcp-jj:0:0:0:0:q75.image#?w=800&h=450&s=33895&e=jpg&b=031126)


#### 《Flutter TolyUI 框架》系列前言:

**TolyUI** 是 [张风捷特烈](https://juejin.cn/user/149189281194766) 打造的 Fluter 全平台应用开发 UI 框架。具备 **全平台**、**组件化**、**源码开放**、**响应式** 四大特点。可以帮助开发者迅速构建具有响应式全平台应用软件：

> 开源地址： <https://github.com/TolyFx/toly_ui>

![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/de8c6bed9bfe46b3865accea7d493d4c~tplv-k3u1fbpfcp-jj:0:0:0:0:q75.image#?w=1563&h=409&s=62505&e=png&b=ffffff)

---

#### 1. 设计动机

在文档阅读、设置面板、目录导航等场景中，锚点导航是一种极其常见的交互模式。用户需要快速跳转到指定内容区域，同时在滚动时自动高亮当前位置。然而，Flutter 原生的滚动控制基于像素偏移，无法直接按索引跳转，且在处理大量数据时存在性能瓶颈。


![](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/97c2085606b1406a96d571f407483e65~tplv-k3u1fbpfcp-jj:0:0:0:0:q75.image#?w=867&h=313&s=44377&e=png&b=ffffff)

TolyUI 的 [tolyui_anchor](https://pub.dev/packages/tolyui_anchor) 模块正是为了解决这些痛点而设计。它基于 `ScrollablePositionedList` 实现索引级滚动控制，支持精确跳转到指定项，内置虚拟滚动确保大数据量下的流畅体验，同时提供自动高亮和导航跟随等交互能力。

使用者可以独立引入模块包，或者使用 tolyui 全家桶：

```yaml
# 仅使用 tolyui_anchor
dependencies: 
   tolyui_anchor: ^last_version

# 使用 tolyui 全家桶 
dependencies: 
    tolyui: ^last_version
```

---

#### 2. 核心概念

TolyAnchor 组件由两个核心部件组成：

- **TolyAnchor**：导航列表组件，展示锚点链接，支持点击跳转和自动高亮
- **TolyAnchorScrollable**：内容区域组件，基于 `ScrollablePositionedList` 实现索引级滚动

两者通过 `TolyAnchorController` 控制器进行协调：

```dart
class TolyAnchorController extends ChangeNotifier {
  /// 滚动到指定索引
  Future<void> scrollToIndex(int index, {Duration duration, Curve curve});
  
  /// 当前激活的索引
  int get activeIndex;
  
  /// 底层滚动控制器
  final ItemScrollController itemScrollController;
  
  /// 位置监听器
  final ItemPositionsListener itemPositionsListener;
}
```

数据模型 `TolyAnchorLink` 定义锚点链接：

```dart
class TolyAnchorLink {
  final String title;  // 显示标题
  final String href;   // 锚点标识
  final List<TolyAnchorLink>? children;  // 子节点（预留）
}
```

---

#### 3. 基础用法

最简单的使用方式是将 `TolyAnchor` 和 `TolyAnchorScrollable` 左右并排布局：

![](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/86b96e2b3556433e8b347a3f044292d9~tplv-k3u1fbpfcp-jj:0:0:0:0:q75.image#?w=1308&h=512&s=482058&e=gif&f=113&b=fefefc)

点击左侧导航项，右侧内容区域会平滑滚动到对应位置；滚动右侧内容时，左侧导航会自动高亮当前可见区域对应的项。

```dart
class _AnchorDemoState extends State<AnchorDemo> {
  final TolyAnchorController _controller = TolyAnchorController();

  final List<TolyAnchorLink> _links = const [
    TolyAnchorLink(title: '概览', href: 'overview'),
    TolyAnchorLink(title: '特性', href: 'features'),
    TolyAnchorLink(title: '安装', href: 'installation'),
    TolyAnchorLink(title: '快速开始', href: 'quick-start'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 150,
          child: TolyAnchor(
            controller: _controller,
            links: _links,
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
    );
  }

  Widget _buildSection(int index) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Text(_links[index].title),
    );
  }
}
```

---

#### 4. 自定义导航样式

通过 `linkBuilder` 参数可以完全自定义导航项的渲染效果，适用于设置面板、分类导航等场景。

![](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4e2e959175c84659b1883c40142badca~tplv-k3u1fbpfcp-jj:0:0:0:0:q75.image#?w=1308&h=512&s=295284&e=gif&f=118&b=fefefc)

```dart
TolyAnchor(
  controller: _controller,
  links: _links,
  linkBuilder: (context, link, active) {
    return InkWell(
      onTap: () => _controller.scrollToIndex(_links.indexOf(link)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: active ? Theme.of(context).colorScheme.primary.withAlpha(20) : null,
          border: Border(
            left: BorderSide(
              color: active ? Theme.of(context).colorScheme.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.settings, color: active ? Theme.of(context).colorScheme.primary : Colors.grey),
            const SizedBox(width: 12),
            Text(
              link.title,
              style: TextStyle(
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                color: active ? Theme.of(context).colorScheme.primary : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  },
)
```

---

#### 5. 横向标签导航

`TolyAnchor` 支持横向滚动模式，适用于顶部标签导航场景。通过设置 `scrollDirection: Axis.horizontal` 即可切换为横向布局。

![](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/89f8ca156a0943c4a248d4aa7c4f7672~tplv-k3u1fbpfcp-jj:0:0:0:0:q75.image#?w=1308&h=512&s=861383&e=gif&f=87&b=fdfdfb)

```dart
Column(
  children: [
    // 顶部横向标签导航
    Container(
      height: 48,
      child: TolyAnchor(
        controller: _controller,
        links: _links,
        scrollDirection: Axis.horizontal,  // 横向滚动
        shrinkWrap: true,
        linkBuilder: _buildTabLink,
      ),
    ),
    // 竖直滚动内容区域
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

---

#### 6. 大数据量性能优化

`TolyAnchor` 内部使用 `ListView.builder` 实现虚拟滚动，仅渲染可视区域的导航项。`TolyAnchorScrollable` 基于 `ScrollablePositionedList`，同样支持按需构建。

![](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5b630858aa1c4369bb58d7a9ced04b5c~tplv-k3u1fbpfcp-jj:0:0:0:0:q75.image#?w=1308&h=512&s=992051&e=gif&f=176&b=fefefc)

即使有 300 个锚点项，内存占用也保持稳定，滚动过程流畅无卡顿。当激活项超出可视区域时，导航列表会自动滚动确保激活项可见。

```dart
// 生成 300 个测试项
final List<TolyAnchorLink> _links = List.generate(
  300,
  (index) => TolyAnchorLink(title: '章节 ${index + 1}', href: 'item_$index'),
);

TolyAnchor(
  controller: _controller,
  links: _links,
  linkBuilder: _buildCompactLink,  // 紧凑样式
)
```

---

#### 7. 高级特性

**滚动控制**

```dart
// 滚动到指定索引（带动画）
await _controller.scrollToIndex(5, duration: Duration(milliseconds: 300));

// 无动画跳转
_controller.jumpToIndex(5);

// 通过标签滚动
await _controller.scrollTo('section-1');
```

**激活项跟随**

当内容滚动时，左侧导航会自动高亮当前可见区域对应的项。如果激活项超出导航列表的可视区域，导航列表会自动滚动确保激活项可见。

```dart
TolyAnchor(
  controller: _controller,
  links: _links,
  scrollOffset: 20.0,  // 激活项距离边缘的偏移量
)
```

---

#### 尾声

tolyui_anchor 模块为 Flutter 应用提供了完整的锚点导航能力。从基础的双栏布局到横向标签导航，从简单样式到完全自定义，从少量数据到大数据量虚拟滚动，它都能够胜任。

组件的设计遵循了职责分离的原则：`TolyAnchor` 负责导航展示和交互，`TolyAnchorScrollable` 负责内容滚动，`TolyAnchorController` 负责状态协调。这种设计使得组件易于理解和扩展。

无论你是在构建文档阅读器、设置面板，还是开发内容导航系统，tolyui_anchor 都能帮助你创建出既美观又实用的锚点导航界面。

随着 tolyui 的逐步迭代，越来越多的新功能将会支持。感谢你关注 tolyui 的成长，如果喜欢，也希望你能在 github 中点赞支持~

> github 开源地址： [github.com/TolyFx/toly_ui](https://github.com/TolyFx/toly_ui)
---

更多文章和视频知识资讯，大家可以关注我的公众号、掘金和 B 站 。让我们一起成长，变得更强。我们下次再见~

-    QQ交流群： 1046304516
-   掘金账号： [张风捷特烈](https://juejin.cn/user/149189281194766 "https://juejin.cn/user/149189281194766")
-   bilibli 账号： [张风捷特烈](https://link.juejin.cn?target=https%3A%2F%2Fspace.bilibili.com%2F390457600 "https://space.bilibili.com/390457600")
-   公众号： [编程之王](https://link.juejin.cn?target=https%3A%2F%2Fmp.weixin.qq.com%2Fs%2Fq8Vs5i3SU-4QPoU3-0xOSg "https://mp.weixin.qq.com/s/q8Vs5i3SU-4QPoU3-0xOSg")
