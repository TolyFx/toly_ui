# TolyTree

TolyTree 是 TolyUI 框架中的树形组件，用于展示具有层级关系的数据结构。组件支持节点展开收起、选中状态管理、异步加载子节点以及虚拟滚动等功能，适用于文件目录、组织架构、分类管理等场景。

## 特性

TolyTree 提供了完整的树形数据展示能力。组件支持节点的展开收起动画，可以通过复选框进行多选操作，并支持三态复选框来表示父子节点的选中关系。对于大数据量场景，组件提供了虚拟滚动优化。异步加载功能让你可以在展开节点时动态获取子节点数据，避免一次性加载过多内容。

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  toly_tree: ^0.0.1
```

## 使用

### 基础用法

最简单的树形结构展示，通过 TreeNode 构建层级数据，使用 nodeBuilder 自定义节点内容。

```dart
final nodes = [
  TreeNode(
    id: '1',
    data: '根节点',
    children: [
      TreeNode(id: '1-1', data: '子节点 1'),
      TreeNode(id: '1-2', data: '子节点 2'),
    ],
  ),
];

TolyTree<String>(
  nodes: nodes,
  nodeBuilder: (node) => Text(node.data),
)
```

### 可选中的树

通过 onTap 回调处理节点选中状态，TreeNode 的 selectState 属性会自动计算三态复选框的状态。

```dart
TolyTree<String>(
  nodes: nodes,
  nodeBuilder: (node) {
    return Row(
      children: [
        TolyCheckBox(
          value: node.isSelected,
          indeterminate: node.selectState == null,
          onChanged: (value) {
            setState(() {
              _updateNodeSelection(node, value);
            });
          },
        ),
        SizedBox(width: 8),
        Text(node.data),
      ],
    );
  },
  onTap: (node) {
    setState(() {
      _updateNodeSelection(node, !node.isSelected);
    });
  },
)
```

### 异步加载子节点

通过 loadData 回调实现懒加载，在展开节点时动态获取子节点数据。节点加载时会显示加载指示器。

```dart
TolyTree<String>(
  nodes: nodes,
  nodeBuilder: (node) => Text(node.data),
  loadData: (node) async {
    await Future.delayed(Duration(seconds: 1));
    return [
      TreeNode(id: '${node.id}-1', data: '动态子节点 1'),
      TreeNode(id: '${node.id}-2', data: '动态子节点 2'),
    ];
  },
)
```

### 虚拟滚动

对于大数据量场景，通过设置 height 属性启用虚拟滚动，只渲染可见区域的节点。

```dart
TolyTree<String>(
  nodes: nodes,
  height: 400,
  nodeBuilder: (node) => Text(node.data),
)
```

### 显示连接线

通过 showConnectingLines 属性显示节点之间的连接线，帮助用户理解层级关系。

```dart
TolyTree<String>(
  nodes: nodes,
  showConnectingLines: true,
  connectingLineColor: Colors.grey.withOpacity(0.3),
  connectingLineWidth: 1.0,
  nodeBuilder: (node) => Text(node.data),
)
```

### 自定义展开图标和缩进

通过 expandIcon 和 indent 属性自定义树的视觉样式。

```dart
TolyTree<String>(
  nodes: nodes,
  indent: 32.0,
  expandIcon: Icon(Icons.arrow_right, size: 20),
  nodeBuilder: (node) => Text(node.data),
)
```

## API

### TolyTree 属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| nodes | List<TreeNode<T>> | 必填 | 树节点数据列表 |
| nodeBuilder | Widget Function(TreeNode<T>) | 必填 | 节点内容构建器 |
| onTap | Function(TreeNode<T>)? | null | 节点点击回调 |
| onExpand | Function(TreeNode<T>)? | null | 节点展开/收起回调 |
| loadData | Future<List<TreeNode<T>>> Function(TreeNode<T>)? | null | 异步加载子节点回调 |
| height | double? | null | 树的高度，设置后启用虚拟滚动 |
| indent | double | 24.0 | 层级缩进距离 |
| expandIcon | Widget? | null | 展开图标，默认为右箭头 |
| collapseIcon | Widget? | null | 收起图标（非虚拟滚动模式） |
| animationDuration | Duration | 200ms | 展开/收起动画时长 |
| animationCurve | Curve | Curves.easeInOut | 动画曲线 |
| showConnectingLines | bool | false | 是否显示连接线 |
| connectingLineColor | Color? | null | 连接线颜色 |
| connectingLineWidth | double | 1.0 | 连接线宽度 |

### TreeNode 属性

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| id | String | 必填 | 节点唯一标识 |
| data | T | 必填 | 节点数据 |
| children | List<TreeNode<T>> | [] | 子节点列表 |
| isExpanded | bool | false | 是否展开 |
| isSelected | bool | false | 是否选中 |
| selectable | bool | true | 是否可选中 |
| isLeaf | bool? | null | 是否为叶子节点 |
| isLoading | bool | false | 是否正在加载 |
| level | int | 0 | 节点层级（自动计算） |

### TreeNode 方法

- `selectState`: 获取节点的三态复选框状态（true/false/null）
- `hasChildren`: 判断节点是否有子节点
- `fromMap`: 从 Map 数据构建 TreeNode

## 设计理念

TolyTree 的设计注重性能和易用性的平衡。对于小规模数据，组件使用完整的 Widget 树来保证流畅的展开收起动画。对于大规模数据，虚拟滚动模式只渲染可见节点，大幅降低内存占用和渲染开销。

三态复选框的自动计算让父子节点的选中关系变得简单直观。当父节点的所有子节点都选中时，父节点显示为选中状态；当部分子节点选中时，父节点显示为半选状态；当所有子节点都未选中时，父节点显示为未选中状态。这种设计符合用户对树形选择的认知习惯。

异步加载功能让树形组件可以处理动态数据源。通过 isLeaf 属性可以明确标记叶子节点，避免不必要的加载请求。加载过程中的指示器提供了清晰的视觉反馈，让用户知道数据正在获取中。

## 许可证

本项目采用 MIT 许可证。

## 关于 TolyUI

TolyUI 是一个为 Flutter 开发者打造的 UI 组件库，致力于提供简洁、优雅、实用的组件解决方案。

展示网站: http://toly1994.com/ui
