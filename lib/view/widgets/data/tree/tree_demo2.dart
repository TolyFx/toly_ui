import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '可选择树形',
  desc:
      '展示支持三态选择的树形组件。点击复选框可以选中或取消选中节点，父节点的选中状态会自动影响所有子节点。当子节点部分选中时，父节点会显示为半选中状态。右侧实时显示已选中的节点数量和标签列表。组件还支持设置某些节点为不可选中状态，这些节点会以灰色显示且无法被选中。这种交互模式常用于权限管理、分类选择、数据筛选等需要多选操作的场景。',
)
class TreeDemo2 extends StatefulWidget {
  const TreeDemo2({super.key});

  @override
  State<TreeDemo2> createState() => _TreeDemo2State();
}

class _TreeDemo2State extends State<TreeDemo2> {
  List<TreeNode<String>> _nodes = [];
  List<TreeNode<String>> _selectedNodes = [];

  @override
  void initState() {
    super.initState();
    _nodes = _treeData.map(TreeNode<String>.fromMap).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          children: [
            SizedBox(
              width: 300,
              child: TolyTreeSelector<String>(
                nodes: _nodes,
                onSelectionChanged: (selectedNodes) {
                  setState(() {
                    _selectedNodes = selectedNodes;
                  });
                },
              ),
            ),
            SizedBox(
              width: 300,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      '已选择: ${_selectedNodes.length}',
                    ),
                  ),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _selectedNodes
                        .map((n) => TolyTag(
                              color: Colors.blue,
                              child: Text(n.data),
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

List<Map<String, dynamic>> get _treeData => [
      {
        'id': '1',
        'data': '系统管理',
        'children': [
          {
            'id': '1-1',
            'data': '用户管理',
            'children': [
              {'id': '1-1-1', 'data': '用户列表', 'isLeaf': true},
              {'id': '1-1-2', 'data': '用户添加', 'isLeaf': true},
              {'id': '1-1-3', 'data': '用户编辑', 'isLeaf': true},
              {'id': '1-1-4', 'data': '用户删除', 'isLeaf': true},
            ],
          },
          {
            'id': '1-2',
            'data': '角色管理',
            'children': [
              {'id': '1-2-1', 'data': '角色列表', 'isLeaf': true},
              {'id': '1-2-2', 'data': '角色添加', 'isLeaf': true},
              {'id': '1-2-3', 'data': '角色编辑', 'isLeaf': true},
              {'id': '1-2-4', 'data': '权限分配', 'isLeaf': true},
            ],
          },
          {
            'id': '1-3',
            'data': '权限管理',
            'children': [
              {'id': '1-3-1', 'data': '权限列表', 'isLeaf': true},
              {'id': '1-3-2', 'data': '权限配置', 'isLeaf': true},
            ],
          },
        ],
      },
      {
        'id': '2',
        'data': '内容管理',
        'children': [
          {
            'id': '2-1',
            'data': '文章管理',
            'children': [
              {'id': '2-1-1', 'data': '文章列表', 'isLeaf': true},
              {'id': '2-1-2', 'data': '文章发布', 'isLeaf': true},
              {'id': '2-1-3', 'data': '文章审核', 'isLeaf': true},
              {'id': '2-1-4', 'data': '文章编辑', 'isLeaf': true},
            ],
          },
          {
            'id': '2-2',
            'data': '分类管理',
            'children': [
              {'id': '2-2-1', 'data': '分类列表', 'isLeaf': true},
              {'id': '2-2-2', 'data': '分类添加', 'isLeaf': true},
            ],
          },
          {
            'id': '2-3',
            'data': '标签管理',
            'children': [
              {'id': '2-3-1', 'data': '标签列表', 'isLeaf': true},
              {'id': '2-3-2', 'data': '标签添加', 'isLeaf': true},
            ],
          },
        ],
      },
      {
        'id': '3',
        'data': '统计分析',
        'children': [
          {
            'id': '3-1',
            'data': '用户统计',
            'selectable': false,
            'children': [
              {'id': '3-1-1', 'data': '活跃用户', 'isLeaf': true},
              {'id': '3-1-2', 'data': '新增用户', 'isLeaf': true},
            ],
          },
          {
            'id': '3-2',
            'data': '内容统计',
            'children': [
              {'id': '3-2-1', 'data': '文章统计', 'isLeaf': true},
              {'id': '3-2-2', 'data': '访问统计', 'isLeaf': true},
            ],
          },
        ],
      },
      {
        'id': '4',
        'data': '高级功能',
        'children': [
          {
            'id': '4-1',
            'data': '数据管理',
            'children': [
              {
                'id': '4-1-1',
                'data': '数据导入',
                'selectable': false,
                'isLeaf': true
              },
              {'id': '4-1-2', 'data': '数据导出', 'isLeaf': true},
              {'id': '4-1-3', 'data': '数据清理', 'isLeaf': true},
            ],
          },
          {
            'id': '4-2',
            'data': '系统维护',
            'children': [
              {
                'id': '4-2-1',
                'data': '系统备份',
                'selectable': false,
                'isLeaf': true
              },
              {'id': '4-2-2', 'data': '系统还原', 'isLeaf': true},
              {'id': '4-2-3', 'data': '日志查看', 'isLeaf': true},
            ],
          },
        ],
      },
    ];
