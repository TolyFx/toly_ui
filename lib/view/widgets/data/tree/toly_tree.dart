import 'package:flutter/material.dart';
import 'tree_line_painter.dart';

/// 树节点数据模型
class TreeNode<T> {
  final String id;
  final T data;
  final List<TreeNode<T>> children;
  final bool selectable;
  bool isExpanded;
  bool isSelected;
  int level;

  TreeNode({
    required this.id,
    required this.data,
    this.children = const [],
    this.isExpanded = false,
    this.isSelected = false,
    this.level = 0,
    this.selectable = true,
  });

  factory TreeNode.fromMap(dynamic map) {
    List<TreeNode<T>> children = [];
    if (map['children'] != null) {
      children = (map['children'] as List)
          .map((child) => TreeNode<T>.fromMap(child))
          .toList();
    }

    return TreeNode<T>(
      id: map['id']?.toString() ?? '',
      data: map['data'] as T,
      children: children,
      isExpanded: map['isExpanded'] ?? false,
      isSelected: map['isSelected'] ?? false,
      selectable: map['selectable'] ?? true,
    );
  }

  bool get hasChildren => children.isNotEmpty;

  /// 获取复选框状态（支持三态）
  bool? get selectState {
    if (children.isEmpty) {
      return isSelected;
    }

    int selectedCount = 0;
    int totalCount = 0;
    bool hasIndeterminate = false;

    for (var child in children) {
      if (!child.selectable) continue; // 跳过不可选中的节点

      final childState = child.selectState;
      totalCount++;

      if (childState == true) {
        selectedCount++;
      } else if (childState == null) {
        hasIndeterminate = true;
      }
    }

    if (totalCount == 0) {
      return false; // 没有可选中的子节点
    }

    if (selectedCount == totalCount) {
      return true; // 全选
    } else if (selectedCount == 0 && !hasIndeterminate) {
      return false; // 全不选
    } else {
      return null; // 第三态（有至少一个选中）
    }
  }
}

/// 树形组件
class TolyTree<T> extends StatefulWidget {
  final List<TreeNode<T>> nodes;
  final Widget Function(TreeNode<T>) nodeBuilder;
  final Function(TreeNode<T>)? onTap;
  final Function(TreeNode<T>)? onExpand;
  final double indent;
  final Widget? expandIcon;
  final Widget? collapseIcon;
  final Duration animationDuration;
  final bool showConnectingLines;
  final Color? connectingLineColor;
  final double connectingLineWidth;

  const TolyTree({
    super.key,
    required this.nodes,
    required this.nodeBuilder,
    this.onTap,
    this.onExpand,
    this.indent = 24.0,
    this.expandIcon,
    this.collapseIcon,
    this.animationDuration = const Duration(milliseconds: 200),
    this.showConnectingLines = false,
    this.connectingLineColor,
    this.connectingLineWidth = 1.0,
  });

  @override
  State<TolyTree<T>> createState() => _TolyTreeState<T>();
}

class _TolyTreeState<T> extends State<TolyTree<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.nodes.asMap().entries.map((entry) {
        final index = entry.key;
        final node = entry.value;
        return _TreeNodeWidget(
          node: node,
          nodeBuilder: widget.nodeBuilder,
          onTap: widget.onTap,
          onExpand: widget.onExpand,
          indent: widget.indent,
          expandIcon: widget.expandIcon,
          collapseIcon: widget.collapseIcon,
          animationDuration: widget.animationDuration,
          level: 0,
          showConnectingLines: widget.showConnectingLines,
          connectingLineColor:
              widget.connectingLineColor ?? Colors.grey.withOpacity(0.5),
          connectingLineWidth: widget.connectingLineWidth,
          isLast: index == widget.nodes.length - 1,
        );
      }).toList(),
    );
  }
}

/// 单个树节点组件
class _TreeNodeWidget<T> extends StatefulWidget {
  final TreeNode<T> node;
  final Widget Function(TreeNode<T>) nodeBuilder;
  final Function(TreeNode<T>)? onTap;
  final Function(TreeNode<T>)? onExpand;
  final double indent;
  final Widget? expandIcon;
  final Widget? collapseIcon;
  final Duration animationDuration;
  final int level;
  final bool showConnectingLines;
  final Color connectingLineColor;
  final double connectingLineWidth;
  final bool isLast;
  final List<bool> ancestorLines;

  const _TreeNodeWidget({
    required this.node,
    required this.nodeBuilder,
    this.onTap,
    this.onExpand,
    required this.indent,
    this.expandIcon,
    this.collapseIcon,
    required this.animationDuration,
    required this.level,
    this.showConnectingLines = false,
    this.connectingLineColor = Colors.grey,
    this.connectingLineWidth = 1.0,
    this.isLast = false,
    this.ancestorLines = const [],
  });

  @override
  State<_TreeNodeWidget<T>> createState() => _TreeNodeWidgetState<T>();
}

class _TreeNodeWidgetState<T> extends State<_TreeNodeWidget<T>>
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
      curve: Curves.easeInOut,
    );
    _iconAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25, // 90 degrees = 0.25 turns
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
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

    // 只有可选中的节点才触发点击事件
    if (widget.node.selectable) {
      widget.onTap?.call(widget.node);
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.node.level = widget.level;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.showConnectingLines
            ? CustomPaint(
                painter: TreeLinePainter(
                  level: widget.level,
                  indent: widget.indent,
                  color: widget.connectingLineColor,
                  strokeWidth: widget.connectingLineWidth,
                  isLast: widget.isLast,
                  hasChildren: widget.node.hasChildren,
                  isExpanded: widget.node.isExpanded,
                  ancestorLines: widget.ancestorLines,
                ),
                child: _buildNodeContent(),
              )
            : _buildNodeContent(),
        if (widget.node.hasChildren)
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.node.children.asMap().entries.map((entry) {
                final index = entry.key;
                final child = entry.value;
                final childAncestorLines =
                    List<bool>.from(widget.ancestorLines);
                childAncestorLines.add(index < widget.node.children.length - 1);
                return _TreeNodeWidget(
                  node: child,
                  nodeBuilder: widget.nodeBuilder,
                  onTap: widget.onTap,
                  onExpand: widget.onExpand,
                  indent: widget.indent,
                  expandIcon: widget.expandIcon,
                  collapseIcon: widget.collapseIcon,
                  animationDuration: widget.animationDuration,
                  level: widget.level + 1,
                  showConnectingLines: widget.showConnectingLines,
                  connectingLineColor: widget.connectingLineColor,
                  connectingLineWidth: widget.connectingLineWidth,
                  isLast: index == widget.node.children.length - 1,
                  ancestorLines: childAncestorLines,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildNodeContent() {
    return InkWell(
      onTap: _handleTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 40),
        padding: EdgeInsets.only(left: widget.level * widget.indent),
        child: Row(
          children: [
            _buildExpandIcon(),
            Expanded(
              child: Opacity(
                opacity: widget.node.selectable ? 1.0 : 0.5,
                child: widget.nodeBuilder(widget.node),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandIcon() {
    if (!widget.node.hasChildren) {
      return const SizedBox(width: 24);
    }

    return IconButton(
      iconSize: 16,
      onPressed: _toggleExpand,
      icon: RotationTransition(
        turns: _iconAnimation,
        child: widget.expandIcon ?? const Icon(Icons.chevron_right),
      ),
    );
  }
}


