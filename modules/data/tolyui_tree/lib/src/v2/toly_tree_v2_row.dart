import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../toly_tree.dart';
import 'toly_tree_v2_types.dart';

/// 为树列表空白区域提供根级受控放置能力。
final class TolyTreeV2RootDropTarget<T> extends StatelessWidget {
  const TolyTreeV2RootDropTarget({
    super.key,
    required this.child,
    required this.canDrop,
    required this.onDrop,
  });

  /// 树列表内容。
  final Widget child;

  /// 业务侧根级放置规则。
  final TolyTreeCanDrop<T>? canDrop;

  /// 根级拖拽完成回调。
  final TolyTreeOnDrop<T> onDrop;

  @override
  Widget build(BuildContext context) {
    return DragTarget<TreeNode<T>>(
      onWillAcceptWithDetails: _canAccept,
      onAcceptWithDetails: _accept,
      builder: _buildTarget,
    );
  }

  bool _canAccept(DragTargetDetails<TreeNode<T>> details) {
    return canDrop?.call(
          details.data,
          null,
          TolyTreeDropPosition.inside,
        ) ??
        true;
  }

  void _accept(DragTargetDetails<TreeNode<T>> details) {
    onDrop(
      TolyTreeDropResult<T>(
        source: details.data,
        target: null,
        position: TolyTreeDropPosition.inside,
      ),
    );
  }

  Widget _buildTarget(
    BuildContext context,
    List<TreeNode<T>?> candidateData,
    List<dynamic> rejectedData,
  ) {
    return child;
  }
}

/// V2 内部使用的无水波纹树节点行。
final class TolyTreeV2Row<T> extends StatefulWidget {
  const TolyTreeV2Row({
    super.key,
    required this.visible,
    required this.isExpanded,
    required this.isSelected,
    required this.isFocused,
    required this.indent,
    required this.expandIcon,
    required this.collapseIcon,
    required this.nodeBuilder,
    required this.itemBuilder,
    required this.onTap,
    required this.onToggleExpansion,
    required this.onToggleSelection,
    required this.draggable,
    required this.canDrop,
    required this.onDrop,
    required this.dragFeedbackBuilder,
    required this.dropPositionResolver,
  });

  /// 当前可见节点及层级信息。
  final TolyTreeVisibleNode<T> visible;

  /// 当前节点是否展开。
  final bool isExpanded;

  /// 当前节点是否选中。
  final bool isSelected;

  /// 当前节点是否为键盘焦点项。
  final bool isFocused;

  /// 树节点层级缩进。
  final double indent;

  /// 折叠状态图标。
  final Widget? expandIcon;

  /// 展开状态图标。
  final Widget? collapseIcon;

  /// 兼容模式下的内容构建器。
  final TolyTreeNodeBuilder<T> nodeBuilder;

  /// 完整节点行构建器。
  final TolyTreeItemBuilder<T>? itemBuilder;

  /// 标准节点点击操作。
  final VoidCallback onTap;

  /// 标准展开切换操作。
  final VoidCallback onToggleExpansion;

  /// 标准选择切换操作。
  final VoidCallback onToggleSelection;

  /// 当前节点是否允许发起拖拽。
  final bool draggable;

  /// 业务侧放置规则。
  final TolyTreeCanDrop<T>? canDrop;

  /// 受控拖拽完成回调。
  final TolyTreeOnDrop<T>? onDrop;

  /// 自定义拖拽反馈构建器。
  final TolyTreeDragFeedbackBuilder<T>? dragFeedbackBuilder;

  /// 自定义放置位置计算规则。
  final TolyTreeDropPositionResolver<T>? dropPositionResolver;

  @override
  State<TolyTreeV2Row<T>> createState() => _TolyTreeV2RowState<T>();
}

final class _TolyTreeV2RowState<T> extends State<TolyTreeV2Row<T>> {
  /// 指针是否悬停在当前行。
  bool _isHovered = false;

  /// 当前行的有效拖拽放置位置。
  TolyTreeDropPosition? _dropPosition;

  @override
  Widget build(BuildContext context) {
    Widget row = _buildInteractiveRow(_createDetails(isDropTarget: false));
    if (!widget.draggable || widget.onDrop == null) {
      return row;
    }
    row = DragTarget<TreeNode<T>>(
      onMove: _handleDragMove,
      onLeave: _handleDragLeave,
      onWillAcceptWithDetails: _canAcceptDrop,
      onAcceptWithDetails: _acceptDrop,
      builder: _buildDropTarget,
    );
    return Draggable<TreeNode<T>>(
      data: widget.visible.node,
      feedback: _buildDragFeedback(context),
      childWhenDragging: Opacity(opacity: 0.42, child: row),
      child: row,
    );
  }

  Widget _buildInteractiveRow(TolyTreeItemDetails<T> details) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: _handleEnter,
      onExit: _handleExit,
      child: widget.itemBuilder?.call(context, details) ??
          _buildCompatibleRow(details),
    );
  }

  bool _canAcceptDrop(DragTargetDetails<TreeNode<T>> details) {
    final TolyTreeDropPosition position = _resolveDropPosition(details.offset);
    return widget.canDrop?.call(
          details.data,
          widget.visible.node,
          position,
        ) ??
        details.data != widget.visible.node;
  }

  void _handleDragMove(DragTargetDetails<TreeNode<T>> details) {
    final TolyTreeDropPosition position = _resolveDropPosition(details.offset);
    final bool accepted = widget.canDrop?.call(
          details.data,
          widget.visible.node,
          position,
        ) ??
        details.data != widget.visible.node;
    final TolyTreeDropPosition? nextPosition = accepted ? position : null;
    if (_dropPosition != nextPosition) {
      setState(() => _dropPosition = nextPosition);
    }
  }

  void _handleDragLeave(TreeNode<T>? node) {
    if (_dropPosition != null) {
      setState(() => _dropPosition = null);
    }
  }

  void _acceptDrop(DragTargetDetails<TreeNode<T>> details) {
    final TolyTreeDropPosition position =
        _dropPosition ?? _resolveDropPosition(details.offset);
    setState(() => _dropPosition = null);
    widget.onDrop?.call(
      TolyTreeDropResult<T>(
        source: details.data,
        target: widget.visible.node,
        position: position,
      ),
    );
  }

  TolyTreeDropPosition _resolveDropPosition(Offset globalPosition) {
    final RenderBox box = context.findRenderObject()! as RenderBox;
    final Offset localPosition = box.globalToLocal(globalPosition);
    return widget.dropPositionResolver?.call(
          localPosition,
          box.size,
          widget.visible.node,
        ) ??
        _defaultDropPosition(localPosition, box.size);
  }

  TolyTreeDropPosition _defaultDropPosition(
    Offset localPosition,
    Size size,
  ) {
    final double edge = size.height / 3;
    if (localPosition.dy < edge) {
      return TolyTreeDropPosition.above;
    }
    if (localPosition.dy > size.height - edge) {
      return TolyTreeDropPosition.below;
    }
    return TolyTreeDropPosition.inside;
  }

  Widget _buildDropTarget(
    BuildContext context,
    List<TreeNode<T>?> candidateData,
    List<dynamic> rejectedData,
  ) {
    return _buildInteractiveRow(
      _createDetails(isDropTarget: _dropPosition != null),
    );
  }

  TolyTreeItemDetails<T> _createDetails({required bool isDropTarget}) {
    return TolyTreeItemDetails<T>(
      node: widget.visible.node,
      depth: widget.visible.depth,
      isExpanded: widget.isExpanded,
      isSelected: widget.isSelected,
      isFocused: widget.isFocused,
      isHovered: _isHovered,
      isDropTarget: isDropTarget,
      dropPosition: _dropPosition,
      onTap: widget.onTap,
      onToggleExpansion: widget.onToggleExpansion,
      onToggleSelection: widget.onToggleSelection,
    );
  }

  Widget _buildDragFeedback(BuildContext context) {
    final Widget? customFeedback =
        widget.dragFeedbackBuilder?.call(context, widget.visible.node);
    if (customFeedback != null) {
      return customFeedback;
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const <BoxShadow>[
          BoxShadow(color: Color(0x33000000), blurRadius: 8),
        ],
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 120, maxWidth: 320),
        child: widget.nodeBuilder(widget.visible.node),
      ),
    );
  }

  Widget _buildCompatibleRow(TolyTreeItemDetails<T> details) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: details.onTap,
      child: Padding(
        padding: EdgeInsets.only(left: details.depth * widget.indent),
        child: Row(
          children: <Widget>[
            _buildExpandControl(details),
            Expanded(child: widget.nodeBuilder(details.node)),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandControl(TolyTreeItemDetails<T> details) {
    final TreeNode<T> node = details.node;
    if (node.isLoading) {
      return const SizedBox(
        width: 24,
        child: Center(
          child: SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (!node.hasChildren) {
      return const SizedBox(width: 24);
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: details.onToggleExpansion,
      child: SizedBox(
        width: 24,
        child: Center(
          child: details.isExpanded
              ? widget.collapseIcon ??
                  const Icon(Icons.keyboard_arrow_down, size: 16)
              : widget.expandIcon ??
                  const Icon(Icons.keyboard_arrow_right, size: 16),
        ),
      ),
    );
  }

  void _handleEnter(PointerEnterEvent event) {
    setState(() => _isHovered = true);
  }

  void _handleExit(PointerExitEvent event) {
    setState(() => _isHovered = false);
  }
}
