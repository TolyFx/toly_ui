import 'package:flutter/widgets.dart';

import '../toly_tree.dart';

/// 树节点选择模式。
enum TolyTreeSelectionMode { none, single, multiple }

/// 树节点相对于目标节点的放置位置。
enum TolyTreeDropPosition { above, inside, below }

/// V2 树节点点击回调。
typedef TolyTreeNodeCallback<T> = void Function(TreeNode<T> node);

/// V2 树节点异步加载回调。
typedef TolyTreeLoadData<T> = Future<List<TreeNode<T>>> Function(
    TreeNode<T> node);

/// V2 树状态集合变化回调。
typedef TolyTreeIdsChanged = void Function(Set<String> nodeIds);

/// V2 树节点快捷操作回调。
typedef TolyTreeNodeAction<T> = void Function(TreeNode<T> node);

/// 兼容 V1 的节点内容构建器。
typedef TolyTreeNodeBuilder<T> = Widget Function(TreeNode<T> node);

/// 完整节点行构建器。
typedef TolyTreeItemBuilder<T> = Widget Function(
    BuildContext context, TolyTreeItemDetails<T> details);

/// 判断拖拽节点能否放置到目标位置。
typedef TolyTreeCanDrop<T> = bool Function(
  TreeNode<T> source,
  TreeNode<T>? target,
  TolyTreeDropPosition position,
);

/// 树节点拖拽完成回调。
typedef TolyTreeOnDrop<T> = void Function(TolyTreeDropResult<T> result);

/// 构建树节点拖拽反馈。
typedef TolyTreeDragFeedbackBuilder<T> = Widget Function(
    BuildContext context, TreeNode<T> node);

/// 根据指针在目标行内的位置计算放置类型。
typedef TolyTreeDropPositionResolver<T> = TolyTreeDropPosition Function(
  Offset localPosition,
  Size targetSize,
  TreeNode<T> target,
);

/// 一次受控树节点拖拽的结果。
final class TolyTreeDropResult<T> {
  const TolyTreeDropResult({
    required this.source,
    required this.target,
    required this.position,
  });

  /// 被拖动节点。
  final TreeNode<T> source;

  /// 目标节点；为空表示树根区域。
  final TreeNode<T>? target;

  /// 相对于目标的放置位置。
  final TolyTreeDropPosition position;
}

/// 完整节点行构建时可使用的状态和标准操作。
final class TolyTreeItemDetails<T> {
  const TolyTreeItemDetails({
    required this.node,
    required this.depth,
    required this.isExpanded,
    required this.isSelected,
    required this.isFocused,
    required this.isHovered,
    required this.isDropTarget,
    required this.dropPosition,
    required this.onTap,
    required this.onToggleExpansion,
    required this.onToggleSelection,
  });

  /// 当前业务节点。
  final TreeNode<T> node;

  /// 当前节点所在层级。
  final int depth;

  /// 当前节点是否展开。
  final bool isExpanded;

  /// 当前节点是否选中。
  final bool isSelected;

  /// 当前节点是否为键盘焦点项。
  final bool isFocused;

  /// 指针是否悬停在当前节点上。
  final bool isHovered;

  /// 当前行是否为有效拖拽目标。
  final bool isDropTarget;

  /// 当前拖拽指针对应的放置位置。
  final TolyTreeDropPosition? dropPosition;

  /// 执行当前节点的标准点击行为。
  final VoidCallback onTap;

  /// 切换当前节点展开状态。
  final VoidCallback onToggleExpansion;

  /// 切换当前节点选择状态。
  final VoidCallback onToggleSelection;
}

/// 扁平化后的可见树节点。
final class TolyTreeVisibleNode<T> {
  const TolyTreeVisibleNode({
    required this.node,
    required this.depth,
    required this.parentId,
  });

  /// 当前节点。
  final TreeNode<T> node;

  /// 当前节点所在层级。
  final int depth;

  /// 直接父节点标识；根节点为空。
  final String? parentId;
}
