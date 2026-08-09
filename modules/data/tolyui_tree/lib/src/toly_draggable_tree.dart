import 'package:flutter/material.dart';
import 'toly_tree.dart';

/// 拖拽位置枚举
enum DropPosition { above, below, inside }

/// 拖拽操作的结果数据
class DragResult<T> {
  final TreeNode<T> dragNode;
  final TreeNode<T>? targetNode;
  final DropPosition position;

  const DragResult({
    required this.dragNode,
    this.targetNode,
    required this.position,
  });
}

/// 常用的拖拽规则预设
class DragRules {
  static bool? Function(
          TreeNode<T> dragNode, TreeNode<T>? targetNode, DropPosition position)
      noInside<T>() {
    return (dragNode, targetNode, position) => position != DropPosition.inside;
  }

  static bool? Function(
          TreeNode<T> dragNode, TreeNode<T>? targetNode, DropPosition position)
      leafOnly<T>() {
    return (dragNode, targetNode, position) => dragNode.isLeaf;
  }
}

/// 拖拽反馈样式预设
class DragFeedbacks {
  static Widget Function(TreeNode<T> node) shadow<T>(
      Widget Function(TreeNode<T>) nodeBuilder) {
    return (node) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: nodeBuilder(node),
        );
  }

  static Widget Function(TreeNode<T> node) highlight<T>(
      Widget Function(TreeNode<T>) nodeBuilder) {
    return (node) => Container(
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: nodeBuilder(node),
        );
  }
}

/// 完全自定义 item 的构建器
///
/// [node] - 当前节点
/// [level] - 节点层级（0 为根级）
/// [isExpanded] - 是否展开
/// [onToggleExpand] - 切换展开/折叠的回调
typedef FullItemBuilder<T> = Widget Function(
  TreeNode<T> node,
  int level,
  bool isExpanded,
  VoidCallback onToggleExpand,
);

/// 基于 TolyTree 的可拖拽树形组件
class TolyDraggableTree<T> extends StatefulWidget {
  final List<TreeNode<T>> nodes;

  /// 节点内容构建器（仅构建内容部分，缩进和展开图标由组件处理）
  final Widget Function(TreeNode<T>) nodeBuilder;

  /// 完全自定义 item 构建器（构建整个 item，包括缩进、展开图标等）
  /// 如果提供此回调，将忽略 nodeBuilder、indent、expandIcon 等属性
  final FullItemBuilder<T>? fullItemBuilder;

  final Function(TreeNode<T>)? onTap;
  final Function(TreeNode<T>)? onExpand;
  final bool Function(
          TreeNode<T> dragNode, TreeNode<T>? targetNode, DropPosition position)?
      canDrop;
  final void Function(DragResult<T> result)? onNodeMoved;
  final Widget Function(TreeNode<T> node)? dragFeedbackBuilder;
  final Widget Function(TreeNode<T> node)? childWhenDraggingBuilder;
  final bool autoExpandOnDrop;
  final bool autoManageNode;
  final double indent;
  final Widget? expandIcon;
  final Widget? collapseIcon;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool showConnectingLines;
  final Color? connectingLineColor;
  final double connectingLineWidth;

  const TolyDraggableTree({
    super.key,
    required this.nodes,
    required this.nodeBuilder,
    this.fullItemBuilder,
    this.onTap,
    this.onExpand,
    this.canDrop,
    this.onNodeMoved,
    this.dragFeedbackBuilder,
    this.childWhenDraggingBuilder,
    this.autoExpandOnDrop = true,
    this.autoManageNode = true,
    this.indent = 24.0,
    this.expandIcon,
    this.collapseIcon,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.showConnectingLines = false,
    this.connectingLineColor,
    this.connectingLineWidth = 1.0,
  });

  @override
  State<TolyDraggableTree<T>> createState() => _TolyDraggableTreeState<T>();
}

class _TolyDraggableTreeState<T> extends State<TolyDraggableTree<T>> {
  TreeNode<T>? _hoveredNode;
  DropPosition? _dropPosition;
  int _treeKey = 0;

  // 扁平化节点缓存
  List<(TreeNode<T>, int)>? _cachedFlatNodes;
  List<TreeNode<T>>? _lastNodes;
  int? _lastExpandedHash;

  /// 计算展开状态的 hash（用于检测展开/折叠变化）
  int _computeExpandedHash(List<TreeNode<T>> nodes) {
    int hash = 0;
    for (final node in nodes) {
      if (node.isExpanded) {
        hash ^= node.id.hashCode;
      }
      if (node.children.isNotEmpty) {
        hash ^= _computeExpandedHash(node.children);
      }
    }
    return hash;
  }

  /// 获取扁平化节点列表（带缓存）
  List<(TreeNode<T>, int)> _getFlatNodes() {
    final expandedHash = _computeExpandedHash(widget.nodes);

    // 检查是否需要重新扁平化
    final needsRebuild = _cachedFlatNodes == null ||
        _lastNodes != widget.nodes ||
        _lastExpandedHash != expandedHash;

    if (needsRebuild) {
      _cachedFlatNodes = _flattenNodes(widget.nodes, 0);
      _lastNodes = widget.nodes;
      _lastExpandedHash = expandedHash;
    }

    return _cachedFlatNodes!;
  }

  @override
  Widget build(BuildContext context) {
    // 如果提供了 fullItemBuilder，使用自定义渲染
    if (widget.fullItemBuilder != null) {
      return _buildCustomTree();
    }

    // 否则使用 TolyTree 默认渲染
    return TolyTree<T>(
      key: widget.autoExpandOnDrop ? ValueKey(_treeKey) : widget.key,
      nodes: widget.nodes,
      nodeBuilder: _buildDraggableNode,
      onTap: widget.onTap,
      onExpand: widget.onExpand,
      indent: widget.indent,
      expandIcon: widget.expandIcon,
      collapseIcon: widget.collapseIcon,
      animationDuration: widget.animationDuration,
      animationCurve: widget.animationCurve,
      showConnectingLines: widget.showConnectingLines,
      connectingLineColor: widget.connectingLineColor,
      connectingLineWidth: widget.connectingLineWidth,
    );
  }

  /// 使用 fullItemBuilder 构建自定义树
  Widget _buildCustomTree() {
    final flatNodes = _getFlatNodes();
    return ListView.builder(
      itemCount: flatNodes.length,
      itemExtent: 32, // 固定高度，提升滚动性能
      itemBuilder: (context, index) {
        final (node, level) = flatNodes[index];
        return _buildFullDraggableNode(node, level);
      },
    );
  }

  /// 扁平化节点列表，返回 (node, level) 元组
  List<(TreeNode<T>, int)> _flattenNodes(List<TreeNode<T>> nodes, int level) {
    final result = <(TreeNode<T>, int)>[];
    for (final node in nodes) {
      result.add((node, level));
      if (node.isExpanded && node.children.isNotEmpty) {
        result.addAll(_flattenNodes(node.children, level + 1));
      }
    }
    return result;
  }

  /// 构建完全自定义的可拖拽节点
  Widget _buildFullDraggableNode(TreeNode<T> node, int level) {
    final isHovered = _hoveredNode == node;

    return Draggable<TreeNode<T>>(
      data: node,
      feedback: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(minWidth: 100, maxWidth: 300, minHeight: 32),
          child: widget.dragFeedbackBuilder?.call(node) ??
              _defaultDragFeedback(node),
        ),
      ),
      childWhenDragging: widget.childWhenDraggingBuilder?.call(node) ??
          Opacity(
              opacity: 0.3,
              child: widget.fullItemBuilder!(
                  node, level, node.isExpanded, () => _toggleExpand(node))),
      onDragEnd: (details) {
        setState(() {
          _hoveredNode = null;
          _dropPosition = null;
        });
      },
      child: _FullDragTargetNode<T>(
        node: node,
        level: level,
        isHovered: isHovered,
        dropPosition: _dropPosition,
        canDropHere: _canDropHere,
        getDropPosition: _getDropPosition,
        buildDropDecoration: _buildDropDecoration,
        fullItemBuilder: widget.fullItemBuilder!,
        autoManageNode: widget.autoManageNode,
        onNodeMoved: widget.onNodeMoved,
        handleBuiltinNodeMoved: _handleBuiltinNodeMoved,
        onToggleExpand: () => _toggleExpand(node),
        onHoverChanged: (hoveredNode, position) {
          setState(() {
            _hoveredNode = hoveredNode;
            _dropPosition = position;
          });
        },
        onLeave: () {
          setState(() {
            _hoveredNode = null;
            _dropPosition = null;
          });
        },
      ),
    );
  }

  void _toggleExpand(TreeNode<T> node) {
    setState(() {
      node.isExpanded = !node.isExpanded;
    });
    widget.onExpand?.call(node);
  }

  Widget _buildDraggableNode(TreeNode<T> node) {
    final isHovered = _hoveredNode == node;

    return Draggable<TreeNode<T>>(
      data: node,
      feedback: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(minWidth: 100, maxWidth: 300, minHeight: 32),
          child: widget.dragFeedbackBuilder?.call(node) ??
              _defaultDragFeedback(node),
        ),
      ),
      childWhenDragging: widget.childWhenDraggingBuilder?.call(node) ??
          Opacity(opacity: 0.3, child: widget.nodeBuilder(node)),
      onDragEnd: (details) {
        setState(() {
          _hoveredNode = null;
          _dropPosition = null;
        });
      },
      child: _DragTargetNode<T>(
        node: node,
        isHovered: isHovered,
        dropPosition: _dropPosition,
        canDropHere: _canDropHere,
        getDropPosition: _getDropPosition,
        buildDropDecoration: _buildDropDecoration,
        nodeBuilder: widget.nodeBuilder,
        autoManageNode: widget.autoManageNode,
        onNodeMoved: widget.onNodeMoved,
        handleBuiltinNodeMoved: _handleBuiltinNodeMoved,
        onHoverChanged: (hoveredNode, position) {
          setState(() {
            _hoveredNode = hoveredNode;
            _dropPosition = position;
          });
        },
        onLeave: () {
          setState(() {
            _hoveredNode = null;
            _dropPosition = null;
          });
        },
      ),
    );
  }

  bool _canDropHere(
      TreeNode<T> dragNode, TreeNode<T> targetNode, DropPosition position) {
    if (dragNode == targetNode) return false;
    if (_isAncestor(dragNode, targetNode)) return false;
    final customResult = widget.canDrop?.call(dragNode, targetNode, position);
    return customResult ?? !_isAncestor(dragNode, targetNode);
  }

  Widget _defaultDragFeedback(TreeNode<T> node) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 4,
              offset: const Offset(0, 2)),
        ],
      ),
      child: widget.nodeBuilder(node),
    );
  }

  bool _isAncestor(TreeNode<T> ancestor, TreeNode<T> descendant) {
    for (final child in ancestor.children) {
      if (child == descendant || _isAncestor(child, descendant)) return true;
    }
    return false;
  }

  DropPosition _getDropPosition(
      Offset localPosition, Size size, TreeNode<T> node) {
    final third = size.height / 3;
    if (localPosition.dy < third) return DropPosition.above;
    if (localPosition.dy > size.height - third) return DropPosition.below;
    return DropPosition.inside;
  }

  BoxDecoration? _buildDropDecoration(bool isHovered) {
    if (!isHovered || _dropPosition == null) return null;
    const color = Colors.blue;
    switch (_dropPosition!) {
      case DropPosition.above:
        return const BoxDecoration(
            border: Border(top: BorderSide(color: color, width: 2)));
      case DropPosition.below:
        return const BoxDecoration(
            border: Border(bottom: BorderSide(color: color, width: 2)));
      case DropPosition.inside:
        return BoxDecoration(
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(4));
    }
  }

  void _handleBuiltinNodeMoved(DragResult<T> result) {
    setState(() {
      _removeNodeFromTree(result.dragNode);
      _insertNodeToTree(result.dragNode, result.targetNode, result.position);
    });

    if (widget.autoExpandOnDrop &&
        result.position == DropPosition.inside &&
        result.targetNode != null) {
      final targetNode = _findNodeById(result.targetNode!.id);
      if (targetNode != null) {
        targetNode.isExpanded = true;
        setState(() => _treeKey++);
      }
    }
  }

  void _removeNodeFromTree(TreeNode<T> node) {
    for (final rootNode in widget.nodes) {
      if (_removeNodeRecursive(rootNode, node)) return;
    }
    widget.nodes.remove(node);
  }

  bool _removeNodeRecursive(TreeNode<T> parent, TreeNode<T> nodeToRemove) {
    if (parent.children.remove(nodeToRemove)) return true;
    for (final child in parent.children) {
      if (_removeNodeRecursive(child, nodeToRemove)) return true;
    }
    return false;
  }

  void _insertNodeToTree(
      TreeNode<T> node, TreeNode<T>? target, DropPosition position) {
    if (target == null) {
      widget.nodes.add(node);
      return;
    }
    switch (position) {
      case DropPosition.inside:
        target.children.add(node);
        if (widget.autoExpandOnDrop) target.isExpanded = true;
        break;
      case DropPosition.above:
        _insertNodeRelative(node, target, true);
        break;
      case DropPosition.below:
        _insertNodeRelative(node, target, false);
        break;
    }
  }

  void _insertNodeRelative(TreeNode<T> node, TreeNode<T> target, bool above) {
    // Check root level first
    final rootIndex = widget.nodes.indexOf(target);
    if (rootIndex >= 0) {
      widget.nodes.insert(above ? rootIndex : rootIndex + 1, node);
      return;
    }
    // Search in children
    for (final rootNode in widget.nodes) {
      final result = _findNodeParentAndIndex(rootNode, target);
      if (result != null) {
        final (parent, index) = result;
        parent.children.insert(above ? index : index + 1, node);
        return;
      }
    }
  }

  (TreeNode<T>, int)? _findNodeParentAndIndex(
      TreeNode<T> root, TreeNode<T> target) {
    for (int i = 0; i < root.children.length; i++) {
      if (root.children[i] == target) return (root, i);
      final result = _findNodeParentAndIndex(root.children[i], target);
      if (result != null) return result;
    }
    return null;
  }

  TreeNode<T>? _findNodeById(String id) {
    for (final rootNode in widget.nodes) {
      final result = _findNodeByIdRecursive(rootNode, id);
      if (result != null) return result;
    }
    return null;
  }

  TreeNode<T>? _findNodeByIdRecursive(TreeNode<T> node, String id) {
    if (node.id == id) return node;
    for (final child in node.children) {
      final result = _findNodeByIdRecursive(child, id);
      if (result != null) return result;
    }
    return null;
  }
}

/// 独立的 DragTarget 节点组件，用于正确获取 RenderBox
class _DragTargetNode<T> extends StatefulWidget {
  final TreeNode<T> node;
  final bool isHovered;
  final DropPosition? dropPosition;
  final bool Function(TreeNode<T>, TreeNode<T>, DropPosition) canDropHere;
  final DropPosition Function(Offset, Size, TreeNode<T>) getDropPosition;
  final BoxDecoration? Function(bool) buildDropDecoration;
  final Widget Function(TreeNode<T>) nodeBuilder;
  final bool autoManageNode;
  final void Function(DragResult<T>)? onNodeMoved;
  final void Function(DragResult<T>) handleBuiltinNodeMoved;
  final void Function(TreeNode<T>?, DropPosition?) onHoverChanged;
  final VoidCallback onLeave;

  const _DragTargetNode({
    required this.node,
    required this.isHovered,
    required this.dropPosition,
    required this.canDropHere,
    required this.getDropPosition,
    required this.buildDropDecoration,
    required this.nodeBuilder,
    required this.autoManageNode,
    required this.onNodeMoved,
    required this.handleBuiltinNodeMoved,
    required this.onHoverChanged,
    required this.onLeave,
  });

  @override
  State<_DragTargetNode<T>> createState() => _DragTargetNodeState<T>();
}

class _DragTargetNodeState<T> extends State<_DragTargetNode<T>> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DragTarget<TreeNode<T>>(
      onWillAcceptWithDetails: (details) {
        final dragNode = details.data;
        if (dragNode == widget.node) return false;
        return widget.canDropHere(dragNode, widget.node, DropPosition.above) ||
            widget.canDropHere(dragNode, widget.node, DropPosition.below) ||
            widget.canDropHere(dragNode, widget.node, DropPosition.inside);
      },
      onMove: (details) {
        if (details.data == widget.node) return;

        final RenderBox? renderBox =
            _key.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox == null || !renderBox.hasSize) return;

        final localPosition = renderBox.globalToLocal(details.offset);
        final position =
            widget.getDropPosition(localPosition, renderBox.size, widget.node);

        if (widget.canDropHere(details.data, widget.node, position)) {
          widget.onHoverChanged(widget.node, position);
        }
      },
      onLeave: (data) => widget.onLeave(),
      onAcceptWithDetails: (details) {
        final position = widget.dropPosition ?? DropPosition.inside;
        final result = DragResult(
          dragNode: details.data,
          targetNode: widget.node,
          position: position,
        );

        if (widget.autoManageNode) {
          widget.handleBuiltinNodeMoved(result);
        }
        widget.onNodeMoved?.call(result);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          key: _key,
          decoration: widget.buildDropDecoration(widget.isHovered),
          child: widget.nodeBuilder(widget.node),
        );
      },
    );
  }
}

/// 完全自定义 item 的 DragTarget 节点组件
class _FullDragTargetNode<T> extends StatefulWidget {
  final TreeNode<T> node;
  final int level;
  final bool isHovered;
  final DropPosition? dropPosition;
  final bool Function(TreeNode<T>, TreeNode<T>, DropPosition) canDropHere;
  final DropPosition Function(Offset, Size, TreeNode<T>) getDropPosition;
  final BoxDecoration? Function(bool) buildDropDecoration;
  final FullItemBuilder<T> fullItemBuilder;
  final bool autoManageNode;
  final void Function(DragResult<T>)? onNodeMoved;
  final void Function(DragResult<T>) handleBuiltinNodeMoved;
  final VoidCallback onToggleExpand;
  final void Function(TreeNode<T>?, DropPosition?) onHoverChanged;
  final VoidCallback onLeave;

  const _FullDragTargetNode({
    required this.node,
    required this.level,
    required this.isHovered,
    required this.dropPosition,
    required this.canDropHere,
    required this.getDropPosition,
    required this.buildDropDecoration,
    required this.fullItemBuilder,
    required this.autoManageNode,
    required this.onNodeMoved,
    required this.handleBuiltinNodeMoved,
    required this.onToggleExpand,
    required this.onHoverChanged,
    required this.onLeave,
  });

  @override
  State<_FullDragTargetNode<T>> createState() => _FullDragTargetNodeState<T>();
}

class _FullDragTargetNodeState<T> extends State<_FullDragTargetNode<T>> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DragTarget<TreeNode<T>>(
      onWillAcceptWithDetails: (details) {
        final dragNode = details.data;
        if (dragNode == widget.node) return false;
        return widget.canDropHere(dragNode, widget.node, DropPosition.above) ||
            widget.canDropHere(dragNode, widget.node, DropPosition.below) ||
            widget.canDropHere(dragNode, widget.node, DropPosition.inside);
      },
      onMove: (details) {
        if (details.data == widget.node) return;

        final RenderBox? renderBox =
            _key.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox == null || !renderBox.hasSize) return;

        final localPosition = renderBox.globalToLocal(details.offset);
        final position =
            widget.getDropPosition(localPosition, renderBox.size, widget.node);

        if (widget.canDropHere(details.data, widget.node, position)) {
          widget.onHoverChanged(widget.node, position);
        }
      },
      onLeave: (data) => widget.onLeave(),
      onAcceptWithDetails: (details) {
        final position = widget.dropPosition ?? DropPosition.inside;
        final result = DragResult(
          dragNode: details.data,
          targetNode: widget.node,
          position: position,
        );

        if (widget.autoManageNode) {
          widget.handleBuiltinNodeMoved(result);
        }
        widget.onNodeMoved?.call(result);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          key: _key,
          decoration: widget.buildDropDecoration(widget.isHovered),
          child: widget.fullItemBuilder(
            widget.node,
            widget.level,
            widget.node.isExpanded,
            widget.onToggleExpand,
          ),
        );
      },
    );
  }
}
