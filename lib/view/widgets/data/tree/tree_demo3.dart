import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'toly_tree.dart';

@DisplayNode(
  title: '自定义图标',
  desc: '支持自定义节点图标和展开收起图标的树形组件。可根据节点类型显示不同图标，提供更丰富的视觉表达。',
)
class TreeDemo3 extends StatelessWidget {
  const TreeDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyTree<Map<String, dynamic>>(
      nodes: _buildSampleData(),
      expandIcon: const Icon(Icons.folder, color: Colors.amber),
      collapseIcon: const Icon(Icons.folder_open, color: Colors.amber),
      nodeBuilder: (node) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(
              _getNodeIcon(node.data['type']),
              size: 16,
              color: _getNodeColor(node.data['type']),
            ),
            const SizedBox(width: 8),
            Text(node.data['name']),
          ],
        ),
      ),
    );
  }

  IconData _getNodeIcon(String type) {
    switch (type) {
      case 'folder':
        return Icons.folder;
      case 'file':
        return Icons.insert_drive_file;
      case 'image':
        return Icons.image;
      case 'document':
        return Icons.description;
      default:
        return Icons.help_outline;
    }
  }

  Color _getNodeColor(String type) {
    switch (type) {
      case 'folder':
        return Colors.amber;
      case 'file':
        return Colors.grey;
      case 'image':
        return Colors.green;
      case 'document':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  List<TreeNode<Map<String, dynamic>>> _buildSampleData() {
    return [
      TreeNode(
        id: '1',
        data: {'name': '项目文件夹', 'type': 'folder'},
        children: [
          TreeNode(
            id: '1-1',
            data: {'name': '源代码', 'type': 'folder'},
            children: [
              TreeNode(id: '1-1-1', data: {'name': 'main.dart', 'type': 'file'}),
              TreeNode(id: '1-1-2', data: {'name': 'app.dart', 'type': 'file'}),
            ],
          ),
          TreeNode(
            id: '1-2',
            data: {'name': '资源文件', 'type': 'folder'},
            children: [
              TreeNode(id: '1-2-1', data: {'name': 'logo.png', 'type': 'image'}),
              TreeNode(id: '1-2-2', data: {'name': 'README.md', 'type': 'document'}),
            ],
          ),
        ],
      ),
    ];
  }
}