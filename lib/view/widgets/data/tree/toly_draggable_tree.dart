import 'package:flutter/material.dart';
import 'toly_tree.dart';

/// 拖拽位置枚举
enum DropPosition { above, below, inside }

/// 拖拽结果数据
class DragResult<T> {
  final TreeNode<T> dragNode;
  final TreeNode<T>? targetNode;
  final DropPosition position;
  final TreeNode<T>? newParent;

  const DragResult({
    required this.dragNode,
    this.targetNode,
    required this.position,
    this.newParent,
  });
}

/// 可拖拽的树形组件
class TolyDraggableTree<T> extends StatefulWidget {
  final List<TreeNode<T>> nodes;
  final Widget Function(TreeNode<T>) nodeBuilder;
  final Function(TreeNode<T>)? onTap;
  final Function(TreeNode<T>)? onExpand;
  final bool Function(
          TreeNode<T> dragNode, TreeNode<T>? targetNode, DropPosition position)?
      canDrop;
  final void Function(DragResult<T> result)? onNodeMoved;
  final Widget Function(TreeNode<T> node)? dragFeedbackBuilder;
  final Widget Function(TreeNode<T> node)? childWhenDraggingBuilder;
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
    this.onTap,
    this.onExpand,
    this.canDrop,
    this.onNodeMoved,
    this.dragFeedbackBuilder,
    this.childWhenDraggingBuilder,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.nodes.asMap().entries.map((entry) {
        final index = entry.key;
        final node = entry.value;
        return _DraggableTreeNodeWidget(
          node: node,
          nodeBuilder: widget.nodeBuilder,
          onTap: widget.onTap,
          onExpand: widget.onExpand,
          canDrop: widget.canDrop,
          onNodeMoved: widget.onNodeMoved,
          dragFeedbackBuilder: widget.dragFeedbackBuilder,
          childWhenDraggingBuilder: widget.childWhenDraggingBuilder,
          indent: widget.indent,
          expandIcon: widget.expandIcon,
          collapseIcon: widget.collapseIcon,
          animationDuration: widget.animationDuration,
          animationCurve: widget.animationCurve,
          level: 0,
          showConnectingLines: widget.showConnectingLines,
          connectingLineColor:
              widget.connectingLineColor ?? Colors.grey.withOpacity(0.5),
          connectingLineWidth: widget.connectingLineWidth,
          isLast: index == widget.nodes.length - 1,
          draggedNode: _draggedNode,
          hoveredNode: _hoveredNode,
          dropPosition: _dropPosition,
          onDragUpdate: (draggedNode, hoveredNode, position) {
            setState(() {
              _draggedNode = draggedNode;
              _hoveredNode = hoveredNode;
              _dropPosition = position;
            });
          },
          onDragEnd: () {
            setState(() {
              _draggedNode = null;
              _hoveredNode = null;
              _dropPosition = null;
            });
          },
        );
      }).toList(),
    );
  }
}

/// 可拖拽的树节点组件
class _DraggableTreeNodeWidget<T> extends StatefulWidget {
  final TreeNode<T> node;
  final Widget Function(TreeNode<T>) nodeBuilder;
  final Function(TreeNode<T>)? onTap;
  final Function(TreeNode<T>)? onExpand;
  final bool Function(
          TreeNode<T> dragNode, TreeNode<T>? targetNode, DropPosition position)?
      canDrop;
  final void Function(DragResult<T> result)? onNodeMoved;
  final Widget Function(TreeNode<T> node)? dragFeedbackBuilder;
  final Widget Function(TreeNode<T> node)? childWhenDraggingBuilder;
  final double indent;
  final Widget? expandIcon;
  final Widget? collapseIcon;
  final Duration animationDuration;
  final Curve animationCurve;
  final int level;
  final bool showConnectingLines;
  final Color connectingLineColor;
  final double connectingLineWidth;
  final bool isLast;
  final TreeNode<T>? draggedNode;
  final TreeNode<T>? hoveredNode;
  final DropPosition? dropPosition;
  final void Function(TreeNode<T>? draggedNode, TreeNode<T>? hoveredNode,
      DropPosition? position) onDragUpdate;
  final VoidCallback onDragEnd;

  const _DraggableTreeNodeWidget({
    required this.node,
    required this.nodeBuilder,
    this.onTap,
    this.onExpand,
    this.canDrop,
    this.onNodeMoved,
    this.dragFeedbackBuilder,
    this.childWhenDraggingBuilder,
    required this.indent,
    this.expandIcon,
    this.collapseIcon,
    required this.animationDuration,
    required this.animationCurve,
    required this.level,
    this.showConnectingLines = false,
    this.connectingLineColor = Colors.grey,
    this.connectingLineWidth = 1.0,
    this.isLast = false,
    this.draggedNode,
    this.hoveredNode,
    this.dropPosition,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  @override
  State<_DraggableTreeNodeWidget<T>> createState() =>
      _DraggableTreeNodeWidgetState<T>();
}

class _DraggableTreeNodeWidgetState<T>
    extends State<_DraggableTreeNodeWidget<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _iconAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    );
    _iconAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    ));

    if (widget.node.isExpanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      widget.node.isExpanded = !widget.node.isExpanded;
    });

    if (widget.node.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }

    widget.onExpand?.call(widget.node);
  }

  void _handleTap() {
    if (widget.node.hasChildren) {
      _toggleExpand();
    }
    widget.onTap?.call(widget.node);
  }

  bool _canDropHere(TreeNode<T> dragNode, DropPosition position) {
    if (dragNode == widget.node) return false;
    if (_isAncestor(dragNode, widget.node)) return false;
    return widget.canDrop?.call(dragNode, widget.node, position) ?? true;
  }

  bool _isAncestor(TreeNode<T> ancestor, TreeNode<T> descendant) {
    TreeNode<T>? current = descendant;
    while (current != null) {
      if (current == ancestor) return true;
      current = _findParent(current);
    }
    return false;
  }

  TreeNode<T>? _findParent(TreeNode<T> node) {
    // 简化实现，实际项目中需要维护父子关系
    return null;
  }

  DropPosition _getDropPosition(Offset localPosition, Size size) {
    final third = size.height / 3;
    if (localPosition.dy < third) {
      return DropPosition.above;
    } else if (localPosition.dy > size.height - third &&
        widget.node.hasChildren) {
      return DropPosition.inside;
    } else {
      return DropPosition.below;
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.node.level = widget.level;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDraggableNode(),
        if (widget.node.hasChildren)
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.node.children.asMap().entries.map((entry) {
                final index = entry.key;
                final child = entry.value;
                return _DraggableTreeNodeWidget(
                  node: child,
                  nodeBuilder: widget.nodeBuilder,
                  onTap: widget.onTap,
                  onExpand: widget.onExpand,
                  canDrop: widget.canDrop,
                  onNodeMoved: widget.onNodeMoved,
                  dragFeedbackBuilder: widget.dragFeedbackBuilder,
                  childWhenDraggingBuilder: widget.childWhenDraggingBuilder,
                  indent: widget.indent,
                  expandIcon: widget.expandIcon,
                  collapseIcon: widget.collapseIcon,
                  animationDuration: widget.animationDuration,
                  animationCurve: widget.animationCurve,
                  level: widget.level + 1,
                  showConnectingLines: widget.showConnectingLines,
                  connectingLineColor: widget.connectingLineColor,
                  connectingLineWidth: widget.connectingLineWidth,
                  isLast: index == widget.node.children.length - 1,
                  draggedNode: widget.draggedNode,
                  hoveredNode: widget.hoveredNode,
                  dropPosition: widget.dropPosition,
                  onDragUpdate: widget.onDragUpdate,
                  onDragEnd: widget.onDragEnd,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildDraggableNode() {
    final isDragging = widget.draggedNode == widget.node;
    final isHovered = widget.hoveredNode == widget.node;

    return Draggable<TreeNode<T>>(
      data: widget.node,
      feedback: widget.dragFeedbackBuilder?.call(widget.node) ??
          widget.nodeBuilder(widget.node),
      childWhenDragging: widget.childWhenDraggingBuilder?.call(widget.node) ??
          Opacity(
            opacity: 0.3,
            child: _buildNodeContent(),
          ),
      onDragStarted: () {
        widget.onDragUpdate(widget.node, null, null);
      },
      onDragEnd: (details) {
        widget.onDragEnd();
      },
      child: DragTarget<TreeNode<T>>(
        onWillAccept: (dragNode) {
          if (dragNode == null) return false;
          return _canDropHere(dragNode, DropPosition.inside);
        },
        onMove: (details) {
          if (details.data == widget.node) return;

          final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox == null || !renderBox.hasSize) return;

          final localPosition = renderBox.globalToLocal(details.offset);
          final position = _getDropPosition(localPosition, renderBox.size);

          if (_canDropHere(details.data, position)) {
            widget.onDragUpdate(details.data, widget.node, position);
          }
        },
        onAccept: (dragNode) {
          final position = widget.dropPosition ?? DropPosition.inside;
          widget.onNodeMoved?.call(DragResult(
            dragNode: dragNode,
            targetNode: widget.node,
            position: position,
            newParent: position == DropPosition.inside ? widget.node : null,
          ));
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            decoration: _buildDropDecoration(isHovered),
            child: _buildNodeContent(),
          );
        },
      ),
    );
  }

  BoxDecoration? _buildDropDecoration(bool isHovered) {
    if (!isHovered || widget.dropPosition == null) return null;

    const color = Colors.blue;
    switch (widget.dropPosition!) {
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

  Widget _buildNodeContent() {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: _handleTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 40),
        padding: EdgeInsets.only(left: widget.level * widget.indent),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: _buildExpandIcon(),
            ),
            Expanded(child: widget.nodeBuilder(widget.node)),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandIcon() {
    if (!widget.node.hasChildren) {
      return const SizedBox(width: 24);
    }

    return GestureDetector(
      onTap: _toggleExpand,
      child: SizedBox(
        width: 24,
        height: 24,
        child: RotationTransition(
          turns: _iconAnimation,
          child: widget.expandIcon ?? const Icon(Icons.chevron_right, size: 16),
        ),
      ),
    );
  }
}
