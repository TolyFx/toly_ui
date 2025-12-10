import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';
import 'toly_tree.dart';

@DisplayNode(
  title: '可选择树形',
  desc: '支持三态选择的树形组件，父级节点点击全选/取消全选，子级未全部勾选时显示第三态。适用于权限配置、分类选择等场景。',
)
class TreeDemo2 extends StatefulWidget {
  const TreeDemo2({super.key});

  @override
  State<TreeDemo2> createState() => _TreeDemo2State();
}

class _TreeDemo2State extends State<TreeDemo2> {
  final List<TreeNode<String>> _nodes = [];

  @override
  void initState() {
    super.initState();
    _nodes.addAll(_buildSampleData());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('已选择: ${_getSelectedNodes().map((n) => n.data).join(", ")}'),
        const SizedBox(height: 16),
        TolyTree<String>(
          nodes: _nodes,
          nodeBuilder: (node) => Row(
            children: [
              TolyCheckBox(
                value: _getCheckboxState(node) == true,
                indeterminate: _getCheckboxState(node) == null,
                onChanged: (value) => _handleCheckboxChange(node, value),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(node.data)),
            ],
          ),
          onTap: (node) => _handleNodeTap(node),
        ),
      ],
    );
  }

  bool? _getCheckboxState(TreeNode<String> node) {
    if (node.children.isEmpty) {
      return node.isSelected;
    }

    int selectedCount = 0;
    int totalCount = 0;
    bool hasIndeterminate = false;

    for (var child in node.children) {
      final childState = _getCheckboxState(child);
      totalCount++;

      if (childState == true) {
        selectedCount++;
      } else if (childState == null) {
        hasIndeterminate = true;
      }
    }

    if (selectedCount == totalCount) {
      return true; // 全选
    } else if (selectedCount == 0 && !hasIndeterminate) {
      return false; // 全不选
    } else {
      return null; // 第三态（有至少一个选中）
    }
  }

  void _handleCheckboxChange(TreeNode<String> node, bool? value) {
    setState(() {
      if (node.children.isEmpty) {
        // 叶子节点直接切换选中状态
        node.isSelected = value ?? false;
      } else {
        // 父节点：全选或全不选
        final shouldSelect = value ?? _getCheckboxState(node) != true;
        _setNodeAndChildrenSelected(node, shouldSelect);
      }
    });
  }

  void _handleNodeTap(TreeNode<String> node) {
    if (node.children.isNotEmpty) {
      // 父节点点击切换全选/取消全选
      final currentState = _getCheckboxState(node);
      _handleCheckboxChange(node, currentState != true);
    } else {
      // 叶子节点点击切换选中状态
      _handleCheckboxChange(node, !node.isSelected);
    }
  }

  void _setNodeAndChildrenSelected(TreeNode<String> node, bool selected) {
    node.isSelected = selected;
    for (var child in node.children) {
      _setNodeAndChildrenSelected(child, selected);
    }
  }

  List<TreeNode<String>> _getSelectedNodes() {
    List<TreeNode<String>> selected = [];
    void collectSelected(List<TreeNode<String>> nodes) {
      for (var node in nodes) {
        if (node.isSelected) selected.add(node);
        collectSelected(node.children);
      }
    }

    collectSelected(_nodes);
    return selected;
  }

  List<TreeNode<String>> _buildSampleData() {
    return [
      TreeNode(
        id: '1',
        data: '系统管理',
        children: [
          TreeNode(
            id: '1-1',
            data: '用户管理',
            children: [
              TreeNode(id: '1-1-1', data: '用户列表'),
              TreeNode(id: '1-1-2', data: '用户添加'),
              TreeNode(id: '1-1-3', data: '用户编辑'),
            ],
          ),
          TreeNode(
            id: '1-2',
            data: '角色管理',
            children: [
              TreeNode(id: '1-2-1', data: '角色列表'),
              TreeNode(id: '1-2-2', data: '角色添加'),
            ],
          ),
          TreeNode(id: '1-3', data: '权限管理'),
        ],
      ),
      TreeNode(
        id: '2',
        data: '内容管理',
        children: [
          TreeNode(
            id: '2-1',
            data: '文章管理',
            children: [
              TreeNode(id: '2-1-1', data: '文章列表'),
              TreeNode(id: '2-1-2', data: '文章发布'),
              TreeNode(id: '2-1-3', data: '文章审核'),
            ],
          ),
          TreeNode(id: '2-2', data: '分类管理'),
          TreeNode(id: '2-3', data: '标签管理'),
        ],
      ),
      TreeNode(
        id: '3',
        data: '统计分析',
        children: [
          TreeNode(id: '3-1', data: '用户统计'),
          TreeNode(id: '3-2', data: '内容统计'),
        ],
      ),
    ];
  }
}
