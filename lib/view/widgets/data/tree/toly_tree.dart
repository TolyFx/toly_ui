import 'package:flutter/material.dart';
import 'tree_line_painter.dart';

/// 树节点数据模型
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

  TreeNode({
    required this.id,
    required this.data,
    List<TreeNode<T>>? children,
    this.isExpanded = false,
    this.isSelected = false,
    this.level = 0,
    this.selectable = true,
    this.isLeaf,
    this.isLoading = false,
  }) : children = children ?? [];

  factory TreeNode.fromMap(dynamic map, {T Function(dynamic)? dataParser}) {
    List<TreeNode<T>> children = [];
    if (map['children'] != null) {
      children = (map['children'] as List)
          .map((child) => TreeNode<T>.fromMap(child, dataParser: dataParser))
          .toList();
    }

    return TreeNode<T>(
      id: map['id']?.toString() ?? '',
      data: dataParser != null ? dataParser(map['data']) : map['data'] as T,
      children: children,
      isExpanded: map['isExpanded'] ?? false,
      isSelected: map['isSelected'] ?? false,
      selectable: map['selectable'] ?? true,
      isLeaf: map['isLeaf'],
    );
  }

  bool get hasChildren =>
      isLeaf != true && (children.isNotEmpty || isLeaf == null);

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
  final Future<List<TreeNode<T>>> Function(TreeNode<T>)? loadData;
  final double? height;
  final double indent;
  final Widget? expandIcon;
  final Widget? collapseIcon;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool showConnectingLines;
  final Color? connectingLineColor;
  final double connectingLineWidth;

  const TolyTree({
    super.key,
    required this.nodes,
    required this.nodeBuilder,
    this.onTap,
    this.onExpand,
    this.loadData,
    this.height,
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
  State<TolyTree<T>> createState() => _TolyTreeState<T>();
}

class _TolyTreeState<T> extends State<TolyTree<T>> {
  List<TreeNode<T>> _flattenedNodes = [];

  @override
  void initState() {
    super.initState();
    _updateFlattenedNodes();
  }

  @override
  void didUpdateWidget(TolyTree<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateFlattenedNodes();
  }

  void _updateFlattenedNodes() {
    _flattenedNodes = _flattenNodes(widget.nodes, 0);
  }

  List<TreeNode<T>> _flattenNodes(List<TreeNode<T>> nodes, int level) {
    final result = <TreeNode<T>>[];
    for (final node in nodes) {
      node.level = level;
      result.add(node);
      if (node.isExpanded && node.children.isNotEmpty) {
        result.addAll(_flattenNodes(node.children, level + 1));
      }
    }
    return result;
  }

  void _onNodeChanged() {
    setState(() {
      _updateFlattenedNodes();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.height != null) {
      return SizedBox(
        height: widget.height,
        child: ListView.builder(
          itemCount: _flattenedNodes.length,
          itemBuilder: (context, index) {
            final node = _flattenedNodes[index];
            return _VirtualTreeNodeWidget(
              node: node,
              nodeBuilder: widget.nodeBuilder,
              onTap: widget.onTap,
              onExpand: (node) {
                widget.onExpand?.call(node);
                _onNodeChanged();
              },
              loadData: widget.loadData,
              indent: widget.indent,
              expandIcon: widget.expandIcon,
              showConnectingLines: widget.showConnectingLines,
              connectingLineColor:
                  widget.connectingLineColor ?? Colors.grey.withOpacity(0.5),
              connectingLineWidth: widget.connectingLineWidth,
              isLast: _isLastNode(node, index),
            );
          },
        ),
      );
    }

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
          loadData: widget.loadData,
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
        );
      }).toList(),
    );
  }

  bool _isLastNode(TreeNode<T> node, int index) {
    if (index == _flattenedNodes.length - 1) return true;
    final nextNode = _flattenedNodes[index + 1];
    return nextNode.level <= node.level;
  }
}

/// 单个树节点组件
class _TreeNodeWidget<T> extends StatefulWidget {
  final TreeNode<T> node;
  final Widget Function(TreeNode<T>) nodeBuilder;
  final Function(TreeNode<T>)? onTap;
  final Function(TreeNode<T>)? onExpand;
  final Future<List<TreeNode<T>>> Function(TreeNode<T>)? loadData;
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
  final List<bool> ancestorLines;

  const _TreeNodeWidget({
    required this.node,
    required this.nodeBuilder,
    this.onTap,
    this.onExpand,
    this.loadData,
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
      curve: widget.animationCurve,
    );
    _iconAnimation = Tween<double>(
      begin: 0.0,
      end: 0.25, // 90 degrees = 0.25 turns
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

  void _toggleExpand() async {
    if (widget.node.isLoading) return; // 加载中不响应点击
    
    if (!widget.node.isExpanded &&
        widget.node.children.isEmpty &&
        widget.node.isLeaf != true &&
        widget.loadData != null) {
      setState(() {
        widget.node.isLoading = true;
      });

      try {
        final children = await widget.loadData!(widget.node);
        setState(() {
          widget.node.children.addAll(children);
          widget.node.isLoading = false;
          widget.node.isExpanded = true;
        });
        _controller.forward();
      } catch (e) {
        setState(() {
          widget.node.isLoading = false;
        });
        return;
      }
    } else {
      setState(() {
        widget.node.isExpanded = !widget.node.isExpanded;
      });

      if (widget.node.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }

    widget.onExpand?.call(widget.node);
  }

  void _handleTap() {
    if (widget.node.isLoading) return; // 加载中不响应点击
    
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
                  loadData: widget.loadData,
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

    if (widget.node.isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: Center(
          child: SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
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

/// 虚拟滚动专用的简化节点组件
class _VirtualTreeNodeWidget<T> extends StatelessWidget {
  final TreeNode<T> node;
  final Widget Function(TreeNode<T>) nodeBuilder;
  final Function(TreeNode<T>)? onTap;
  final Function(TreeNode<T>)? onExpand;
  final Future<List<TreeNode<T>>> Function(TreeNode<T>)? loadData;
  final double indent;
  final Widget? expandIcon;
  final bool showConnectingLines;
  final Color connectingLineColor;
  final double connectingLineWidth;
  final bool isLast;

  const _VirtualTreeNodeWidget({
    required this.node,
    required this.nodeBuilder,
    this.onTap,
    this.onExpand,
    this.loadData,
    required this.indent,
    this.expandIcon,
    this.showConnectingLines = false,
    this.connectingLineColor = Colors.grey,
    this.connectingLineWidth = 1.0,
    this.isLast = false,
  });

  void _handleTap() {
    if (node.isLoading) return; // 加载中不响应点击
    
    if (node.hasChildren) {
      _toggleExpand();
    }
    if (node.selectable) {
      onTap?.call(node);
    }
  }

  void _toggleExpand() async {
    if (node.isLoading) return; // 加载中不响应点击
    
    if (!node.isExpanded &&
        node.children.isEmpty &&
        node.isLeaf != true &&
        loadData != null) {
      node.isLoading = true;
      try {
        final children = await loadData!(node);
        node.children.addAll(children);
        node.isLoading = false;
        node.isExpanded = true;
      } catch (e) {
        node.isLoading = false;
        return;
      }
    } else {
      node.isExpanded = !node.isExpanded;
    }
    onExpand?.call(node);
  }

  @override
  Widget build(BuildContext context) {
    final content = InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: _handleTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 40),
        padding: EdgeInsets.only(left: node.level * indent),
        child: Row(
          children: [
            _buildExpandIcon(),
            Expanded(
              child: Opacity(
                opacity: node.selectable ? 1.0 : 0.5,
                child: nodeBuilder(node),
              ),
            ),
          ],
        ),
      ),
    );

    return showConnectingLines
        ? CustomPaint(
            painter: TreeLinePainter(
              level: node.level,
              indent: indent,
              color: connectingLineColor,
              strokeWidth: connectingLineWidth,
              isLast: isLast,
              hasChildren: node.hasChildren,
              isExpanded: node.isExpanded,
              ancestorLines: const [],
            ),
            child: content,
          )
        : content;
  }

  Widget _buildExpandIcon() {
    if (!node.hasChildren) {
      return const SizedBox(width: 24);
    }

    if (node.isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return IconButton(
      iconSize: 16,
      onPressed: _toggleExpand,
      icon: Transform.rotate(
        angle: node.isExpanded ? 1.5708 : 0, // 90 degrees
        child: expandIcon ?? const Icon(Icons.chevron_right),
      ),
    );
  }
}
