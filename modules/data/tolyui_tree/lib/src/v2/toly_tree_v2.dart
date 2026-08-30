import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../toly_tree.dart';
import 'toly_tree_v2_types.dart';
import 'toly_tree_v2_row.dart';

/// 面向桌面端、支持受控状态和完整行构建的第二代树组件。
class TolyTreeV2<T> extends StatefulWidget {
  const TolyTreeV2({
    super.key,
    required this.nodes,
    required this.nodeBuilder,
    this.itemBuilder,
    this.onTap,
    this.onExpand,
    this.loadData,
    this.height,
    this.indent = 24,
    this.expandIcon,
    this.collapseIcon,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.showConnectingLines = false,
    this.connectingLineColor,
    this.connectingLineWidth = 1,
    this.itemExtent = 32,
    this.padding = EdgeInsets.zero,
    this.selectionMode = TolyTreeSelectionMode.single,
    this.expandedIds,
    this.selectedIds,
    this.onExpandedIdsChanged,
    this.onSelectedIdsChanged,
    this.onRenameRequested,
    this.onDeleteRequested,
    this.autofocus = false,
    this.expandOnNodeTap = true,
    this.selectOnKeyboardNavigation = true,
    this.draggable = false,
    this.canDrop,
    this.onDrop,
    this.dragFeedbackBuilder,
    this.dropPositionResolver,
  });

  /// 与 V1 一致的根节点列表。
  final List<TreeNode<T>> nodes;

  /// 与 V1 一致的节点内容构建器。
  final TolyTreeNodeBuilder<T> nodeBuilder;

  /// 可选的完整节点行构建器。
  final TolyTreeItemBuilder<T>? itemBuilder;

  /// 节点点击回调。
  final TolyTreeNodeCallback<T>? onTap;

  /// 节点展开状态变化回调。
  final TolyTreeNodeCallback<T>? onExpand;

  /// 节点异步加载回调。
  final TolyTreeLoadData<T>? loadData;

  /// 指定树高度；为空时使用父级约束。
  final double? height;

  /// 每层缩进距离。
  final double indent;

  /// 折叠状态图标。
  final Widget? expandIcon;

  /// 展开状态图标。
  final Widget? collapseIcon;

  /// 为保持 V1 接口一致而保留的动画时长。
  final Duration animationDuration;

  /// 为保持 V1 接口一致而保留的动画曲线。
  final Curve animationCurve;

  /// 是否显示连接线。
  final bool showConnectingLines;

  /// 连接线颜色。
  final Color? connectingLineColor;

  /// 连接线宽度。
  final double connectingLineWidth;

  /// 固定节点行高，用于虚拟列表定位。
  final double itemExtent;

  /// 列表内容边距。
  final EdgeInsetsGeometry padding;

  /// 节点选择模式。
  final TolyTreeSelectionMode selectionMode;

  /// 外部受控展开标识；为空时兼容 TreeNode.isExpanded。
  final Set<String>? expandedIds;

  /// 外部受控选择标识；为空时兼容 TreeNode.isSelected。
  final Set<String>? selectedIds;

  /// 展开标识变化回调。
  final TolyTreeIdsChanged? onExpandedIdsChanged;

  /// 选择标识变化回调。
  final TolyTreeIdsChanged? onSelectedIdsChanged;

  /// F2 快捷键操作回调。
  final TolyTreeNodeAction<T>? onRenameRequested;

  /// Delete 快捷键操作回调。
  final TolyTreeNodeAction<T>? onDeleteRequested;

  /// 是否自动获取键盘焦点。
  final bool autofocus;

  /// 点击可展开节点时是否同时切换展开状态，默认与 V1 一致。
  final bool expandOnNodeTap;

  /// 使用方向键移动焦点时是否同步选择节点。
  final bool selectOnKeyboardNavigation;

  /// 是否允许拖动树节点。
  final bool draggable;

  /// 业务侧放置规则。
  final TolyTreeCanDrop<T>? canDrop;

  /// 受控拖拽完成回调；组件不会直接修改节点结构。
  final TolyTreeOnDrop<T>? onDrop;

  /// 自定义拖拽反馈构建器。
  final TolyTreeDragFeedbackBuilder<T>? dragFeedbackBuilder;

  /// 自定义行内放置位置计算规则。
  final TolyTreeDropPositionResolver<T>? dropPositionResolver;

  @override
  State<TolyTreeV2<T>> createState() => _TolyTreeV2State<T>();
}

final class _TolyTreeV2State<T> extends State<TolyTreeV2<T>> {
  /// 接收桌面键盘事件的焦点节点。
  final FocusNode _focusNode = FocusNode();

  /// 非受控模式下组件内部维护的展开标识。
  final Set<String> _expandedIds = <String>{};

  /// 非受控模式下组件内部维护的选择标识。
  final Set<String> _selectedIds = <String>{};

  /// 当前通过键盘或指针聚焦的节点标识。
  String? _focusedId;

  /// 当前可见节点的扁平快照。
  List<TolyTreeVisibleNode<T>> _visibleNodes = <TolyTreeVisibleNode<T>>[];

  @override
  void initState() {
    super.initState();
    _syncLegacyState();
  }

  @override
  void didUpdateWidget(TolyTreeV2<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expandedIds == null || widget.selectedIds == null) {
      _syncLegacyState();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _visibleNodes = _flattenVisibleNodes();
    final Widget treeContent = Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onKeyEvent: _handleKeyEvent,
      child: ListView.builder(
        padding: widget.padding,
        itemCount: _visibleNodes.length,
        itemExtent: widget.itemExtent,
        itemBuilder: _buildItem,
      ),
    );
    final Widget tree = widget.draggable && widget.onDrop != null
        ? TolyTreeV2RootDropTarget<T>(
            canDrop: widget.canDrop,
            onDrop: widget.onDrop!,
            child: treeContent,
          )
        : treeContent;
    return widget.height == null
        ? tree
        : SizedBox(height: widget.height, child: tree);
  }

  /// 从兼容节点字段初始化非受控状态。
  void _syncLegacyState() {
    _expandedIds.clear();
    _selectedIds.clear();
    _visitNodes(widget.nodes, (TreeNode<T> node) {
      if (node.isExpanded) {
        _expandedIds.add(node.id);
      }
      if (node.isSelected) {
        _selectedIds.add(node.id);
      }
    });
  }

  void _visitNodes(List<TreeNode<T>> nodes, TolyTreeNodeCallback<T> visitor) {
    for (final TreeNode<T> node in nodes) {
      visitor(node);
      _visitNodes(node.children, visitor);
    }
  }

  Set<String> get _effectiveExpandedIds => widget.expandedIds ?? _expandedIds;

  Set<String> get _effectiveSelectedIds => widget.selectedIds ?? _selectedIds;

  /// 仅扁平化展开路径上的可见节点。
  List<TolyTreeVisibleNode<T>> _flattenVisibleNodes() {
    final List<TolyTreeVisibleNode<T>> result = <TolyTreeVisibleNode<T>>[];
    _appendVisibleNodes(widget.nodes, 0, null, result);
    return result;
  }

  void _appendVisibleNodes(
    List<TreeNode<T>> nodes,
    int depth,
    String? parentId,
    List<TolyTreeVisibleNode<T>> result,
  ) {
    for (final TreeNode<T> node in nodes) {
      node.level = depth;
      result.add(
        TolyTreeVisibleNode<T>(node: node, depth: depth, parentId: parentId),
      );
      if (_effectiveExpandedIds.contains(node.id)) {
        _appendVisibleNodes(node.children, depth + 1, node.id, result);
      }
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    final TolyTreeVisibleNode<T> visible = _visibleNodes[index];
    return TolyTreeV2Row<T>(
      key: ValueKey<String>('toly_tree_v2_${visible.node.id}'),
      visible: visible,
      isExpanded: _effectiveExpandedIds.contains(visible.node.id),
      isSelected: _effectiveSelectedIds.contains(visible.node.id),
      isFocused: _focusedId == visible.node.id,
      indent: widget.indent,
      expandIcon: widget.expandIcon,
      collapseIcon: widget.collapseIcon,
      nodeBuilder: widget.nodeBuilder,
      itemBuilder: widget.itemBuilder,
      onTap: () => _activateNode(visible.node),
      onToggleExpansion: () => _toggleExpansion(visible.node),
      onToggleSelection: () => _toggleSelection(visible.node),
      draggable: widget.draggable,
      canDrop: widget.canDrop,
      onDrop: widget.onDrop,
      dragFeedbackBuilder: widget.dragFeedbackBuilder,
      dropPositionResolver: widget.dropPositionResolver,
    );
  }

  /// 聚焦、选择并通知业务方当前点击节点。
  void _activateNode(TreeNode<T> node) {
    _focusNode.requestFocus();
    setState(() => _focusedId = node.id);
    if (widget.expandOnNodeTap && node.hasChildren) {
      _toggleExpansion(node);
    }
    if (node.selectable) {
      _selectNode(node);
      widget.onTap?.call(node);
    }
  }

  void _selectNode(TreeNode<T> node) {
    if (widget.selectionMode == TolyTreeSelectionMode.none) {
      return;
    }
    final Set<String> nextIds = <String>{..._effectiveSelectedIds};
    if (widget.selectionMode == TolyTreeSelectionMode.single) {
      nextIds
        ..clear()
        ..add(node.id);
    } else {
      nextIds.add(node.id);
    }
    _commitSelection(nextIds);
  }

  void _toggleSelection(TreeNode<T> node) {
    if (!node.selectable ||
        widget.selectionMode == TolyTreeSelectionMode.none) {
      return;
    }
    final Set<String> nextIds = <String>{..._effectiveSelectedIds};
    if (!nextIds.remove(node.id)) {
      if (widget.selectionMode == TolyTreeSelectionMode.single) {
        nextIds.clear();
      }
      nextIds.add(node.id);
    }
    _commitSelection(nextIds);
  }

  void _commitSelection(Set<String> nextIds) {
    if (widget.selectedIds == null) {
      setState(() {
        _selectedIds
          ..clear()
          ..addAll(nextIds);
        _syncNodeSelectionFlags();
      });
    }
    widget.onSelectedIdsChanged?.call(Set<String>.unmodifiable(nextIds));
  }

  void _syncNodeSelectionFlags() {
    _visitNodes(widget.nodes, (TreeNode<T> node) {
      node.isSelected = _selectedIds.contains(node.id);
    });
  }

  /// 切换展开状态，并在首次展开时按需加载子节点。
  Future<void> _toggleExpansion(TreeNode<T> node) async {
    if (node.isLoading || node.isLeaf == true) {
      return;
    }
    if (!_effectiveExpandedIds.contains(node.id) &&
        node.children.isEmpty &&
        widget.loadData != null) {
      setState(() => node.isLoading = true);
      try {
        final List<TreeNode<T>> children = await widget.loadData!(node);
        node.children.addAll(children);
      } on Object {
        if (mounted) {
          setState(() => node.isLoading = false);
        }
        return;
      }
      if (!mounted) {
        return;
      }
      node.isLoading = false;
    }
    final Set<String> nextIds = <String>{..._effectiveExpandedIds};
    if (!nextIds.remove(node.id)) {
      nextIds.add(node.id);
    }
    if (widget.expandedIds == null) {
      setState(() {
        _expandedIds
          ..clear()
          ..addAll(nextIds);
        node.isExpanded = nextIds.contains(node.id);
      });
    }
    widget.onExpandedIdsChanged?.call(Set<String>.unmodifiable(nextIds));
    widget.onExpand?.call(node);
  }

  KeyEventResult _handleKeyEvent(FocusNode focusNode, KeyEvent event) {
    if (event is! KeyDownEvent || _visibleNodes.isEmpty) {
      return KeyEventResult.ignored;
    }
    final int index = _focusedIndex;
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      _focusVisibleIndex((index + 1).clamp(0, _visibleNodes.length - 1));
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      _focusVisibleIndex(
        (index < 0 ? 0 : index - 1).clamp(0, _visibleNodes.length - 1),
      );
      return KeyEventResult.handled;
    }
    if (index < 0) {
      return KeyEventResult.ignored;
    }
    final TolyTreeVisibleNode<T> visible = _visibleNodes[index];
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (!_effectiveExpandedIds.contains(visible.node.id)) {
        _toggleExpansion(visible.node);
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (_effectiveExpandedIds.contains(visible.node.id)) {
        _toggleExpansion(visible.node);
      } else if (visible.parentId != null) {
        _focusNodeById(visible.parentId!);
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      _activateNode(visible.node);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.space) {
      _toggleSelection(visible.node);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.f2 &&
        widget.onRenameRequested != null) {
      widget.onRenameRequested!(visible.node);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.delete &&
        widget.onDeleteRequested != null) {
      widget.onDeleteRequested!(visible.node);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  int get _focusedIndex => _visibleNodes.indexWhere(
        (TolyTreeVisibleNode<T> item) => item.node.id == _focusedId,
      );

  void _focusVisibleIndex(int index) {
    final TreeNode<T> node = _visibleNodes[index].node;
    setState(() => _focusedId = node.id);
    if (widget.selectOnKeyboardNavigation && node.selectable) {
      _selectNode(node);
    }
  }

  void _focusNodeById(String nodeId) {
    setState(() => _focusedId = nodeId);
    if (!widget.selectOnKeyboardNavigation) {
      return;
    }
    for (final TolyTreeVisibleNode<T> visible in _visibleNodes) {
      if (visible.node.id == nodeId && visible.node.selectable) {
        _selectNode(visible.node);
        return;
      }
    }
  }
}
