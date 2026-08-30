# TolyTree V2

`TolyTreeV2` 保留 V1 的 `TreeNode<T>`，并兼容 `nodes`、`nodeBuilder`、
`onTap`、`onExpand`、`loadData`、`indent` 与图标等主要入口。

V2 始终将展开路径扁平化后交给 `ListView.builder`，同时提供：

- 外部受控的 `expandedIds` 和 `selectedIds`；
- 单选、多选和不可选模式；
- 无 `InkWell`、无水波纹的默认桌面交互；
- 完整的 `itemBuilder` 节点行构建能力；
- 上下选择、左右展开、Enter、Space、F2 和 Delete；
- 兼容 `TreeNode.isExpanded`、`TreeNode.isSelected` 的非受控模式。

```dart
TolyTreeV2<FileItem>(
  nodes: nodes,
  nodeBuilder: buildFileContent,
  expandedIds: expandedIds,
  selectedIds: selectedIds,
  onExpandedIdsChanged: updateExpandedIds,
  onSelectedIdsChanged: updateSelectedIds,
  itemBuilder: buildDesktopFileRow,
)
```

`itemBuilder` 会收到 `TolyTreeItemDetails<T>`，业务可以完全控制一行的图标、
背景、复选框、尾部操作和右键区域，同时调用其中的标准展开与选择操作。
