import 'package:flutter/material.dart';
import 'toly_tree.dart';

/// 拖拽位置枚举
///
/// 定义节点可以被放置的三种位置：
/// - [above]: 放置在目标节点上方（同级）
/// - [below]: 放置在目标节点下方（同级）
/// - [inside]: 放置在目标节点内部（作为子节点）
enum DropPosition { above, below, inside }

/// 拖拽操作的结果数据
///
/// 包含拖拽操作的完整信息，用于处理节点移动逻辑
class DragResult<T> {
  /// 被拖拽的节点
  final TreeNode<T> dragNode;

  /// 目标节点，如果为 null 表示拖拽到根级别
  final TreeNode<T>? targetNode;

  /// 放置位置
  final DropPosition position;

  const DragResult({
    required this.dragNode,
    this.targetNode,
    required this.position,
  });
}

/// 常用的拖拽规则预设
///
/// 提供一些常见的拖拽限制规则，可以直接使用或组合使用
class DragRules {
  /// 禁止拖拽到内部（只允许同级排序）
  ///
  /// 适用于不需要层级结构变化，只需要同级排序的场景
  ///
  /// 示例：
  /// ```dart
  /// TolyDraggableTree(
  ///   canDrop: DragRules.noInside<MyData>(),
  ///   // ...
  /// )
  /// ```
  static bool? Function(
          TreeNode<T> dragNode, TreeNode<T>? targetNode, DropPosition position)
      noInside<T>() {
    return (dragNode, targetNode, position) => position != DropPosition.inside;
  }

  /// 只允许叶子节点拖拽
  ///
  /// 适用于只允许最底层节点移动的场景，如文件系统中只能移动文件不能移动文件夹
  ///
  /// 示例：
  /// ```dart
  /// TolyDraggableTree(
  ///   canDrop: DragRules.leafOnly<MyData>(),
  ///   // ...
  /// )
  /// ```
  static bool? Function(
          TreeNode<T> dragNode, TreeNode<T>? targetNode, DropPosition position)
      leafOnly<T>() {
    return (dragNode, targetNode, position) => dragNode.isLeaf;
  }
}

/// 拖拽反馈样式预设
///
/// 提供常用的拖拽时显示样式，让拖拽操作更加直观
class DragFeedbacks {
  /// 简单阴影样式
  ///
  /// 为拖拽节点添加白色背景和阴影效果，适合大多数场景
  ///
  /// 示例：
  /// ```dart
  /// TolyDraggableTree(
  ///   dragFeedbackBuilder: DragFeedbacks.shadow<MyData>(_buildNode),
  ///   // ...
  /// )
  /// ```
  static Widget Function(TreeNode<T> node) shadow<T>(
      Widget Function(TreeNode<T>) nodeBuilder) {
    return (node) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: nodeBuilder(node),
        );
  }

  /// 高亮边框样式
  ///
  /// 为拖拽节点添加蓝色边框和半透明背景，突出显示拖拽状态
  ///
  /// 示例：
  /// ```dart
  /// TolyDraggableTree(
  ///   dragFeedbackBuilder: DragFeedbacks.highlight<MyData>(_buildNode),
  ///   // ...
  /// )
  /// ```
  static Widget Function(TreeNode<T> node) highlight<T>(
      Widget Function(TreeNode<T>) nodeBuilder) {
    return (node) => Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: nodeBuilder(node),
        );
  }
}

/// 基于 TolyTree 的可拖拽树形组件
///
/// 支持节点拖拽排序和层级调整的树形组件。提供丰富的自定义选项和开箱即用的默认行为。
///
/// ## 基本用法
///
/// ```dart
/// TolyDraggableTree<MyData>(
///   nodes: treeNodes,
///   nodeBuilder: (node) => Text(node.data.name),
///   onNodeMoved: (result) {
///     print('${result.dragNode.data.name} moved to ${result.position}');
///   },
/// )
/// ```
///
/// ## 高级用法
///
/// ```dart
/// TolyDraggableTree<FileItem>(
///   nodes: fileNodes,
///   nodeBuilder: _buildFileNode,
///   canDrop: (dragNode, targetNode, position) {
///     // 文件只能放入文件夹
///     if (!dragNode.data.isFolder && position == DropPosition.inside) {
///       return targetNode?.data.isFolder ?? false;
///     }
///     return true;
///   },
///   dragFeedbackBuilder: DragFeedbacks.shadow<FileItem>(_buildFileNode),
///   enableBuiltinNodeManagement: true,
///   autoExpandOnDrop: true,
/// )
/// ```
class TolyDraggableTree<T> extends StatefulWidget {
  /// 树形数据节点列表
  final List<TreeNode<T>> nodes;

  /// 节点构建器，定义每个节点的显示内容
  final Widget Function(TreeNode<T>) nodeBuilder;

  /// 节点点击回调
  final Function(TreeNode<T>)? onTap;

  /// 节点展开/折叠回调
  final Function(TreeNode<T>)? onExpand;

  /// 拖拽规则验证函数
  ///
  /// 返回 true 表示允许拖拽，false 表示禁止
  /// 如果不提供，将使用默认规则（防止拖拽到自身或子节点）
  ///
  /// 可以使用 [DragRules] 中的预设规则或自定义实现
  final bool Function(
          TreeNode<T> dragNode, TreeNode<T>? targetNode, DropPosition position)?
      canDrop;

  /// 节点移动完成回调
  ///
  /// 在拖拽操作完成后触发，提供完整的移动信息
  final void Function(DragResult<T> result)? onNodeMoved;

  /// 拖拽时的反馈样式构建器
  ///
  /// 定义拖拽过程中跟随鼠标的节点样式
  /// 如果不提供，将使用默认的阴影样式
  ///
  /// 可以使用 [DragFeedbacks] 中的预设样式或自定义实现
  final Widget Function(TreeNode<T> node)? dragFeedbackBuilder;

  /// 拖拽时原位置节点的样式构建器
  ///
  /// 定义拖拽过程中原位置节点的显示样式
  /// 如果不提供，将使用半透明效果
  final Widget Function(TreeNode<T> node)? childWhenDraggingBuilder;

  /// 是否在拖拽到文件夹内部时自动展开文件夹
  ///
  /// 默认为 true，便于用户查看拖拽结果
  final bool autoExpandOnDrop;

  /// 是否启用内置的节点管理
  ///
  /// 如果为 true，组件会自动处理节点的移动操作
  /// 如果为 false，需要在 [onNodeMoved] 中手动处理
  ///
  /// 默认为 true，简化使用
  final bool autoManageNode;

  /// 子节点缩进距离（像素）
  final double indent;

  /// 自定义展开图标
  final Widget? expandIcon;

  /// 自定义折叠图标
  final Widget? collapseIcon;

  /// 展开/折叠动画时长
  final Duration animationDuration;

  /// 展开/折叠动画曲线
  final Curve animationCurve;

  /// 是否显示连接线
  final bool showConnectingLines;

  /// 连接线颜色
  final Color? connectingLineColor;

  /// 连接线宽度
  final double connectingLineWidth;

  const TolyDraggableTree({
    super.key,
    required this.nodes,
    required this.nodeBuilder,
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
  TreeNode<T>? _draggedNode;
  TreeNode<T>? _hoveredNode;
  DropPosition? _dropPosition;
  int _treeKey = 0;

  @override
  Widget build(BuildContext context) {
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

  Widget _buildDraggableNode(TreeNode<T> node) {
    final isHovered = _hoveredNode == node;

    return Draggable<TreeNode<T>>(
      data: node,
      feedback: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 100,
            maxWidth: 300,
            minHeight: 32,
          ),
          child: widget.dragFeedbackBuilder?.call(node) ??
              _defaultDragFeedback(node),
        ),
      ),
      childWhenDragging: widget.childWhenDraggingBuilder?.call(node) ??
          Opacity(
            opacity: 0.3,
            child: widget.nodeBuilder(node),
          ),
      onDragStarted: () {
        setState(() {
          _draggedNode = node;
        });
      },
      onDragEnd: (details) {
        setState(() {
          _draggedNode = null;
          _hoveredNode = null;
          _dropPosition = null;
        });
      },
      child: DragTarget<TreeNode<T>>(
        onWillAccept: (dragNode) {
          if (dragNode == null || dragNode == node) return false;
          // 检查是否可以放置在任意位置
          return _canDropHere(dragNode, node, DropPosition.above) ||
              _canDropHere(dragNode, node, DropPosition.below) ||
              _canDropHere(dragNode, node, DropPosition.inside);
        },
        onMove: (details) {
          if (details.data == node) return;

          final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox == null || !renderBox.hasSize) return;

          final localPosition = renderBox.globalToLocal(details.offset);
          final position =
              _getDropPosition(localPosition, renderBox.size, node);

          if (_canDropHere(details.data, node, position)) {
            setState(() {
              _hoveredNode = node;
              _dropPosition = position;
            });
          }
        },
        onLeave: (data) {
          setState(() {
            _hoveredNode = null;
            _dropPosition = null;
          });
        },
        onAccept: (dragNode) {
          final position = _dropPosition ?? DropPosition.inside;
          final result = DragResult(
            dragNode: dragNode,
            targetNode: node,
            position: position,
          );

          if (widget.autoManageNode) {
            _handleBuiltinNodeMoved(result);
          }

          widget.onNodeMoved?.call(result);
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            decoration: _buildDropDecoration(isHovered),
            child: widget.nodeBuilder(node),
          );
        },
      ),
    );
  }

  bool _canDropHere(
      TreeNode<T> dragNode, TreeNode<T> targetNode, DropPosition position) {
    if (dragNode == targetNode) return false;
    if (_isAncestor(dragNode, targetNode)) return false;
    final customResult = widget.canDrop?.call(dragNode, targetNode, position);
    return customResult ?? _defaultCanDrop(dragNode, targetNode, position);
  }

  /// 默认的拖拽规则：防止拖拽到自身或子节点
  ///
  /// 这是最基本的拖拽限制，防止创建循环引用
  bool _defaultCanDrop(
      TreeNode<T> dragNode, TreeNode<T> targetNode, DropPosition position) {
    return !_isAncestor(dragNode, targetNode);
  }

  /// 默认的拖拽反馈样式
  ///
  /// 提供简洁的白色背景和轻微阴影效果
  Widget _defaultDragFeedback(TreeNode<T> node) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: widget.nodeBuilder(node),
    );
  }

  bool _isAncestor(TreeNode<T> ancestor, TreeNode<T> descendant) {
    for (final child in ancestor.children) {
      if (child == descendant || _isAncestor(child, descendant)) {
        return true;
      }
    }
    return false;
  }

  DropPosition _getDropPosition(
      Offset localPosition, Size size, TreeNode<T> node) {
    final third = size.height / 3;
    if (localPosition.dy < third) {
      return DropPosition.above;
    } else if (localPosition.dy > size.height - third) {
      return DropPosition.below;
    } else {
      return DropPosition.inside;
    }
  }

  BoxDecoration? _buildDropDecoration(bool isHovered) {
    if (!isHovered || _dropPosition == null) return null;

    const color = Colors.blue;
    switch (_dropPosition!) {
      case DropPosition.above:
        return const BoxDecoration(
          border: Border(top: BorderSide(color: color, width: 2)),
        );
      case DropPosition.below:
        return const BoxDecoration(
          border: Border(bottom: BorderSide(color: color, width: 2)),
        );
      case DropPosition.inside:
        return BoxDecoration(
          border: Border.all(color: color, width: 2),
          borderRadius: BorderRadius.circular(4),
        );
    }
  }

  void _handleBuiltinNodeMoved(DragResult<T> result) {
    setState(() {
      // 从原位置移除
      _removeNodeFromTree(result.dragNode);

      // 添加到新位置
      _insertNodeToTree(result.dragNode, result.targetNode, result.position);
    });

    // 如果是移入文件夹内部且开启自动展开，展开文件夹
    if (widget.autoExpandOnDrop &&
        result.position == DropPosition.inside &&
        result.targetNode != null) {
      final targetNode = _findNodeById(result.targetNode!.id);
      if (targetNode != null) {
        targetNode.isExpanded = true;
        // 内部强制重建
        setState(() {
          _treeKey++;
        });
      }
    }
  }

  void _removeNodeFromTree(TreeNode<T> node) {
    for (final rootNode in widget.nodes) {
      if (_removeNodeRecursive(rootNode, node)) {
        return;
      }
    }
    widget.nodes.remove(node);
  }

  bool _removeNodeRecursive(TreeNode<T> parent, TreeNode<T> nodeToRemove) {
    if (parent.children.remove(nodeToRemove)) {
      return true;
    }
    for (final child in parent.children) {
      if (_removeNodeRecursive(child, nodeToRemove)) {
        return true;
      }
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
        if (widget.autoExpandOnDrop) {
          target.isExpanded = true;
        }
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
    for (final rootNode in widget.nodes) {
      final result = _findNodeParentAndIndex(rootNode, target);
      if (result != null) {
        final (parent, index) = result;
        if (parent != null) {
          parent.children.insert(above ? index : index + 1, node);
        } else {
          final rootIndex = widget.nodes.indexOf(target);
          widget.nodes.insert(above ? rootIndex : rootIndex + 1, node);
        }
        return;
      }
    }
  }

  (TreeNode<T>?, int)? _findNodeParentAndIndex(
      TreeNode<T> root, TreeNode<T> target) {
    for (int i = 0; i < root.children.length; i++) {
      if (root.children[i] == target) {
        return (root, i);
      }
      final result = _findNodeParentAndIndex(root.children[i], target);
      if (result != null) {
        return result;
      }
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
