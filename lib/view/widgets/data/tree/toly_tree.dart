import 'package:flutter/material.dart';

/// 树节点数据模型
class TreeNode<T> {
  final String id;
  final T data;
  final List<TreeNode<T>> children;
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
  });

  bool get hasChildren => children.isNotEmpty;
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
  });

  @override
  State<TolyTree<T>> createState() => _TolyTreeState<T>();
}

class _TolyTreeState<T> extends State<TolyTree<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.nodes.map((node) => _TreeNodeWidget(
        node: node,
        nodeBuilder: widget.nodeBuilder,
        onTap: widget.onTap,
        onExpand: widget.onExpand,
        indent: widget.indent,
        expandIcon: widget.expandIcon,
        collapseIcon: widget.collapseIcon,
        animationDuration: widget.animationDuration,
        level: 0,
      )).toList(),
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
    widget.onTap?.call(widget.node);
  }

  @override
  Widget build(BuildContext context) {
    widget.node.level = widget.level;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: _handleTap,
          child: Container(
            constraints: const BoxConstraints(minHeight: 40),
            padding: EdgeInsets.only(left: widget.level * widget.indent),
            child: Row(
              children: [
                _buildExpandIcon(),
                Expanded(child: widget.nodeBuilder(widget.node)),
              ],
            ),
          ),
        ),
        if (widget.node.hasChildren)
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.node.children.map((child) => _TreeNodeWidget(
                node: child,
                nodeBuilder: widget.nodeBuilder,
                onTap: widget.onTap,
                onExpand: widget.onExpand,
                indent: widget.indent,
                expandIcon: widget.expandIcon,
                collapseIcon: widget.collapseIcon,
                animationDuration: widget.animationDuration,
                level: widget.level + 1,
              )).toList(),
            ),
          ),
      ],
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