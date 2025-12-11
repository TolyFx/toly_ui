import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';
import 'toly_tree.dart';

/// 树形选择器组件
class TolyTreeSelector<T> extends StatefulWidget {
  final List<TreeNode<T>> nodes;
  final Function(List<TreeNode<T>>)? onSelectionChanged;
  final double indent;
  final Widget? expandIcon;
  final Widget? collapseIcon;
  final Duration animationDuration;

  const TolyTreeSelector({
    super.key,
    required this.nodes,
    this.onSelectionChanged,
    this.indent = 24.0,
    this.expandIcon,
    this.collapseIcon,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  State<TolyTreeSelector<T>> createState() => _TolyTreeSelectorState<T>();
}

class _TolyTreeSelectorState<T> extends State<TolyTreeSelector<T>> {
  @override
  Widget build(BuildContext context) {
    return TolyTree<T>(
      nodes: widget.nodes,
      nodeBuilder: _buildTreeNode,
      onTap: _handleNodeTap,
      indent: widget.indent,
      expandIcon: widget.expandIcon,
      collapseIcon: widget.collapseIcon,
      animationDuration: widget.animationDuration,
    );
  }

  Widget _buildTreeNode(TreeNode<T> node) {
    final checkboxState = node.selectState;
    return Row(
      children: [
        TolyCheckBox(
          value: checkboxState == true,
          indeterminate: checkboxState == null,
          onChanged: node.selectable
              ? (value) => _handleCheckboxChange(node, value)
              : null,
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(node.data.toString())),
      ],
    );
  }

  void _handleCheckboxChange(TreeNode<T> node, bool? value) {
    if (!node.selectable) return;

    setState(() {
      if (node.children.isEmpty) {
        // 叶子节点直接切换选中状态
        node.isSelected = value ?? false;
      } else {
        // 父节点：全选或全不选
        final shouldSelect = value ?? node.selectState != true;
        _setNodeAndChildrenSelected(node, shouldSelect);
      }
    });

    // 通知选择变化
    widget.onSelectionChanged?.call(_getSelectedNodes());
  }

  void _handleNodeTap(TreeNode<T> node) {
    // 只有叶子节点才处理选中逻辑，父节点只处理展开/收起
    if (node.children.isEmpty && node.selectable) {
      _handleCheckboxChange(node, !node.isSelected);
    }
  }

  void _setNodeAndChildrenSelected(TreeNode<T> node, bool selected) {
    if (node.selectable) {
      node.isSelected = selected;
    }
    for (var child in node.children) {
      _setNodeAndChildrenSelected(child, selected);
    }
  }

  List<TreeNode<T>> _getSelectedNodes() {
    List<TreeNode<T>> selected = [];
    void collectSelected(List<TreeNode<T>> nodes) {
      for (var node in nodes) {
        if (node.isSelected) selected.add(node);
        collectSelected(node.children);
      }
    }

    collectSelected(widget.nodes);
    return selected;
  }
}
