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

在现代应用开发中，树形结构是一种极其常见的数据展示方式。无论是文件管理器的目录结构、组织架构图、分类导航，还是权限配置界面，都需要以层级关系来组织和展示信息。然而，构建一个功能完善、性能优良的树形组件并非易事，需要考虑数据绑定、状态管理、虚拟滚动、异步加载等多个方面。


![](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/97c2085606b1406a96d571f407483e65~tplv-k3u1fbpfcp-jj:0:0:0:0:q75.image#?w=867&h=313&s=44377&e=png&b=ffffff)

TolyUI 的 [toly_tree](https://pub.dev/packages/toly_tree) 模块正是为了解决这些痛点而设计。它不仅提供了基础的树形展示能力，还支持选择交互、自定义数据结构、大数据量处理、异步加载等高级功能，让开发者能够轻松构建出专业级的树形界面。

使用者可以独立引入模块包，或者使用 tolyui 全家桶：

```yaml
# 仅使用 tolyui_tree
dependencies: 
   tolyui_tag: ^last_version

# 使用 tolyui 全家桶 
dependencies: 
    tolyui: ^last_version
```



---


#### 1. 基础树形

树形组件的核心功能是展示层级数据结构。**TolyTree** 组件通过递归渲染实现层级嵌套，支持节点的展开收起操作。

- 左侧演示文件目录结构，
- 右侧展示带连接线的学科分类树。

![](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/86b96e2b3556433e8b347a3f044292d9~tplv-k3u1fbpfcp-jj:0:0:0:0:q75.image#?w=1308&h=512&s=482058&e=gif&f=113&b=fefefc)


通过递归渲染实现无限层级嵌套，点击节点前的展开图标可以控制子节点的显示隐藏。这种结构常用于文件管理器、组织架构图、分类导航等需要层级展示的场景。
-  `showConnectingLines` 属性可以显示节点间的连接线，让层级关系更加清晰直观。

```dart
TolyTree<String>(
  nodes: _treeData.map(TreeNode<String>.fromMap).toList(),
  nodeBuilder: (node) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(node.data),
  ),
)

// 带连接线的树形
TolyTree<String>(
  showConnectingLines: true,
  nodes: natureScienceTree.map(TreeNode<String>.fromMap).toList(),
  nodeBuilder: (node) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(node.data),
  ),
)
```

---

树形的节点是 `TreeNode`,支持泛型数据，数据结构如下：

```dart
class TreeNode<T> {
  final String id;
  final T data;
  final List<TreeNode<T>> children;
  final bool selectable;
  final bool? isLeaf;
  bool isExpanded;
  bool isSelected;
  bool isLoading;
  int level;
```

为了便于构造树形结构，为 `TreeNode` 支持了 `fromMap` 方法，支持如下所示的 json 结构。这样便于通过接口下发树形的结构数据：

```dart
{
  'id': '1-1',
  'data': '数学 Mathematics',
  'children': [
    {
      'id': '1-1-1',
      'data': '代数 Algebra',
      'children': [
        {
          'id': '1-1-1-1',
          'data': '线性代数 Linear Algebra',
          'isLeaf': true
        },
        {
          'id': '1-1-1-2',
          'data': '抽象代数 Abstract Algebra',
          'isLeaf': true
        },
        {'id': '1-1-1-3', 'data': '群论 Group Theory', 'isLeaf': true},
      ],
    },
    {
      'id': '1-1-2',
      'data': '分析 Analysis',
      'children': [
        {'id': '1-1-2-1', 'data': '微积分 Calculus', 'isLeaf': true},
        {
          'id': '1-1-2-2',
          'data': '实分析 Real Analysis',
          'isLeaf': true
        },
        {
          'id': '1-1-2-3',
          'data': '复分析 Complex Analysis',
          'isLeaf': true
        },
      ],
    },
    {
      'id': '1-1-3',
      'data': '几何 Geometry',
      'children': [
        {
          'id': '1-1-3-1',
          'data': '欧几里得几何 Euclidean Geometry',
          'isLeaf': true
        },
        {
          'id': '1-1-3-2',
          'data': '微分几何 Differential Geometry',
          'isLeaf': true
        },
        {'id': '1-1-3-3', 'data': '拓扑学 Topology', 'isLeaf': true},
      ],
    },
  ],
},
```



---

#### 2. 可选择树形

在权限配置、分类选择等场景中，树形组件需要支持选择功能。**TolyTreeSelector** 提供了完整的三态选择能力。


![](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/4e2e959175c84659b1883c40142badca~tplv-k3u1fbpfcp-jj:0:0:0:0:q75.image#?w=1308&h=512&s=295284&e=gif&f=118&b=fefefc)


展示支持三态选择的树形组件。点击复选框可以选中或取消选中节点，父节点的选中状态会自动影响所有子节点。当子节点部分选中时，父节点会显示为半选中状态。右侧实时显示已选中的节点数量和标签列表。组件还支持设置某些节点为不可选中状态，这些节点会以灰色显示且无法被选中。

```dart
class _TreeDemo2State extends State<TreeDemo2> {
  List<TreeNode<String>> _nodes = [];
  List<TreeNode<String>> _selectedNodes = [];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: TolyTreeSelector<String>(
            nodes: _nodes,
            onSelectionChanged: (selectedNodes) {
              setState(() {
                _selectedNodes = selectedNodes;
              });
            },
          ),
        ),
        SizedBox(
          width: 300,
          child: Column(
            children: [
              Text('已选择: ${_selectedNodes.length}'),
              Wrap(
                children: _selectedNodes
                    .map((n) => TolyTag(child: Text(n.data)))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
```

这种交互模式常用于权限管理、分类选择、数据筛选等需要多选操作的场景。

---

#### 3. 自定义数据结构

对于复杂的业务场景，往往需要展示更丰富的节点信息。TolyTree 支持自定义数据类型，提供类型安全的数据访问。


![](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/89f8ca156a0943c4a248d4aa7c4f7672~tplv-k3u1fbpfcp-jj:0:0:0:0:q75.image#?w=1308&h=512&s=861383&e=gif&f=87&b=fdfdfb)

展示如何使用自定义数据类型构建树形组件。比如下面通过 **FileMeta** 类封装文件信息，包含名称、类型、图标、颜色、大小和更新时间等属性。每个节点根据文件类型显示不同的图标和颜色，文件夹显示子项数量，文件显示大小和修改日期。点击节点会在控制台输出详细信息，包括节点类型、层级和子项情况。

```dart
class FileMeta {
  final String name;
  final String type;
  final IconData icon;
  final Color color;
  final String? size;
  final DateTime? updateTime;
  final int? fileCount;

  const FileMeta({
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    this.size,
    this.updateTime,
    this.fileCount,
  });

  factory FileMeta.fromJson(dynamic json) {
    return FileMeta(
      name: json['name'] ?? '',
      type: json['type'] ?? 'file',
      icon: _getIconFromType(json['type']),
      color: _getColorFromType(json['type']),
      size: json['size'],
      updateTime: json['updateTime'] != null ? DateTime.parse(json['updateTime']) : null,
      fileCount: json['fileCount'],
    );
  }
}
```

同样使用 `TreeNode<FileMeta>.fromMap` 构造，自定义的数据类型解析可以使用 `dataParser` 回调处理：

```dart
List<TreeNode<FileMeta>> _buildSampleData() {
  return _backendData
      .map((map) =>
          TreeNode<FileMeta>.fromMap(map, dataParser: FileMeta.fromJson))
      .toList();
}
```

这种方式提供了类型安全的数据访问和更丰富的展示效果，适用于文件管理、资源浏览等需要详细信息展示的场景。

---

#### 4. 虚拟滚动树形

当处理大量数据时，性能成为关键考虑因素。TolyTree 支持虚拟滚动模式，只渲染可见区域的节点。展示大数据量下的虚拟滚动树形组件。本案例包含 60,000 个节点，通过设置固定高度启用虚拟滚动模式。


![](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/5b630858aa1c4369bb58d7a9ced04b5c~tplv-k3u1fbpfcp-jj:0:0:0:0:q75.image#?w=1308&h=512&s=992051&e=gif&f=176&b=fefefc)

组件只会渲染可见区域内的节点，大幅提升性能和流畅度。支持完整的展开收起交互，在滚动过程中保持节点状态。点击某些节点时会动态加载新的子节点。

```dart
TolyTree<YourType>(
    height: 300, // 启用虚拟滚动
    // 其他同理...
)
```

这种模式适用于大型数据库浏览、文件系统管理、组织架构展示等需要处理大量层级数据的场景。

---

#### 5. 异步加载树形

对于动态数据源，树形组件需要支持按需加载。TolyTree 提供了完整的异步加载能力。展示支持异步加载子节点的树形组件。如下案例中：初始状态下只显示根节点，带有"点击加载"提示的节点可以展开加载子内容。


![](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/63556c19c46a48eda0e06073e7052da1~tplv-k3u1fbpfcp-jj:0:0:0:0:q75.image#?w=1308&h=512&s=859902&e=gif&f=229&b=fefefc)

点击这些节点时会显示加载动画，模拟 2 秒的网络请求过程，然后动态渲染新的子节点。不同的节点会返回不同的子内容，有些子节点还可以继续异步加载更深层级的内容。

```dart
TolyTree<_AsyncData>(
  nodes: _buildInitialData(),
  loadData: _loadChildren,
  nodeBuilder: (node) => Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    child: Row(
      children: [
        Icon(node.data.icon, size: 16, color: node.data.color),
        const SizedBox(width: 8),
        Text(node.data.name),
        if (node.isLeaf == null && node.children.isEmpty)
          const Text('(点击加载)', style: TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    ),
  ),
)

Future<List<TreeNode<_AsyncData>>> _loadChildren(TreeNode<_AsyncData> node) async {
  // 模拟网络延迟
  await Future.delayed(const Duration(seconds: 2));
  
  switch (node.id) {
    case '1':
      return [
        TreeNode<_AsyncData>(
          id: '1-1',
          data: const _AsyncData(name: '系统文件', icon: Icons.folder, color: Colors.red),
        ),
        TreeNode<_AsyncData>(
          id: '1-2',
          data: const _AsyncData(name: '应用程序', icon: Icons.folder, color: Colors.green),
        ),
      ];
    default:
      return [];
  }
}
```

这种模式适用于大型数据集、远程文件系统、API 数据浏览等需要按需加载的场景。

---

#### 6. 动画曲线树形
为了提升用户体验，TolyTree 支持自定义动画效果。通过不同的动画曲线，可以创造出个性化的交互体验。如下案例中，四个区域分别展示线性动画、缓入缓出、弹性效果和回弹效果四种不同的动画曲线。


![](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1b710e638a7748238f199367d4f4d31a~tplv-k3u1fbpfcp-jj:0:0:0:0:q75.image#?w=1308&h=512&s=665874&e=gif&f=127&b=fdfdfb)

- `animationDuration` 可以设置动画时长
- `animationCurve` 可以设置动画曲线效果



```dart
Widget _buildCurveSection(String title, Curve curve) {
  return Column(
    children: [
      Text(title),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TolyTree<_FileMeta>(
          nodes: _buildSampleData(title),
          animationDuration: const Duration(milliseconds: 600),
          animationCurve: curve,
          nodeBuilder: (node) => Row(
            children: [
              Icon(node.data.icon, size: 14, color: node.data.color),
              const SizedBox(width: 6),
              Text(node.data.name),
            ],
          ),
        ),
      ),
    ],
  );
}

```

这种对比展示帮助开发者选择最适合项目风格的动画效果，彰显个性化特征。

---

#### 7. 拖拽排序树形

在文件管理、项目结构编辑、菜单配置等场景中，用户经常需要通过拖拽来调整节点的位置和层级关系。**TolyDraggableTree** 提供了完整的拖拽排序能力，支持同级排序和跨级移动。


![](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/6c47001eff634617baf81d2f31d8f68d~tplv-k3u1fbpfcp-jj:0:0:0:0:q75.image#?w=1308&h=512&s=313734&e=gif&f=128&b=fefefc)

展示支持拖拽排序的树形组件。文件可以拖入文件夹，文件夹可以拖入其他文件夹，支持同级排序和跨级移动。拖拽过程中会显示蓝色的放置提示线：上方线表示插入到目标上方，下方线表示插入到目标下方，边框表示放入目标内部。拖拽完成后会显示操作成功消息。

```dart
TolyDraggableTree<FileItem>(
  nodes: nodes,
  nodeBuilder: (node) => _buildFileNode(node),
  onNodeMoved: onMove,
),
```



---

#### 尾声

toly_tree 模块为 Flutter 应用提供了完整的树形数据展示和交互能力。从基础的层级展示到高级的虚拟滚动，从静态数据到动态加载，从简单选择到复杂的三态交互，它都能够胜任。

组件的设计遵循了数据驱动的原则，通过 TreeNode 数据结构统一管理节点信息，支持泛型以适应不同的业务数据类型。同时提供了丰富的自定义选项，包括节点渲染器、动画效果、交互回调等，让开发者能够根据具体需求进行灵活配置。

无论你是在构建文件管理系统、权限配置界面，还是开发数据浏览工具，toly_tree 都能帮助你创建出既美观又实用的树形界面。

随着 tolyui 的逐步迭代，越来越多的新功能将会支持。感谢你关注 tolyui 的成长，如果喜欢，也希望你能在 github 中点赞支持~

> github 开源地址： [github.com/TolyFx/toly_ui](https://github.com/TolyFx/toly_ui)
---

更多文章和视频知识资讯，大家可以关注我的公众号、掘金和 B 站 。让我们一起成长，变得更强。我们下次再见~

-    QQ交流群： 1046304516
-   掘金账号： [张风捷特烈](https://juejin.cn/user/149189281194766 "https://juejin.cn/user/149189281194766")
-   bilibli 账号： [张风捷特烈](https://link.juejin.cn?target=https%3A%2F%2Fspace.bilibili.com%2F390457600 "https://space.bilibili.com/390457600")
-   公众号： [编程之王](https://link.juejin.cn?target=https%3A%2F%2Fmp.weixin.qq.com%2Fs%2Fq8Vs5i3SU-4QPoU3-0xOSg "https://mp.weixin.qq.com/s/q8Vs5i3SU-4QPoU3-0xOSg")
