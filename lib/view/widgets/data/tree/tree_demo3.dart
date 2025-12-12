import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'toly_tree.dart';

@DisplayNode(
  title: '自定义数据结构',
  desc:
      '展示如何使用自定义数据结构构建树形组件。通过FileMeta类封装文件信息，包含图标、大小、更新时间等属性，提供更丰富的数据展示和类型安全的数据访问。',
)
class TreeDemo3 extends StatelessWidget {
  const TreeDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyTree<FileMeta>(
      showConnectingLines: true,
      nodes: _buildSampleData(),
      expandIcon: const Icon(Icons.star, color: Colors.blue),
      collapseIcon: const Icon(Icons.folder_open, color: Colors.amber),
      onTap: (node) => print(
          '点击节点: ${node.data.name} - ${node.level == 0 ? '根节点' : '子节点(等级: ${node.level})'} - ${node.data.type == 'folder' ? ('文件夹' + (node.hasChildren ? '(有子项)' : '(空)')) : '文件'}'),
      nodeBuilder: (node) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Icon(
              node.data.icon,
              size: 16,
              color: node.data.color,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(node.data.name),
                      if (node.data.fileCount != null)
                        Text(
                          ' (${node.data.fileCount})',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                  if (node.data.size != null || node.data.updateTime != null)
                    Text(
                      '${node.data.size ?? ''} ${node.data.updateTime != null ? _formatTime(node.data.updateTime!) : ''}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.year}-${time.month.toString().padLeft(2, '0')}-${time.day.toString().padLeft(2, '0')}';
  }

  List<TreeNode<FileMeta>> _buildSampleData() {
    return _treeData.map(TreeNode<FileMeta>.fromMap).toList();
  }
}

class FileMeta {
  final String name;
  final String type;
  final IconData icon;
  final Color color;
  final String? size;
  final DateTime? updateTime;
  final int? fileCount;

  const FileMeta({
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    this.size,
    this.updateTime,
    this.fileCount,
  });
}

List<Map<String, dynamic>> get _treeData => [
      {
        'id': '1',
        'data': const FileMeta(
          name: '项目文件夹',
          type: 'folder',
          icon: Icons.folder,
          color: Colors.amber,
          fileCount: 4,
        ),
        'children': [
          {
            'id': '1-1',
            'data': const FileMeta(
              name: '源代码',
              type: 'folder',
              icon: Icons.folder,
              color: Colors.amber,
              fileCount: 2,
            ),
            'children': [
              {
                'id': '1-1-1',
                'data': FileMeta(
                  name: 'main.dart',
                  type: 'file',
                  icon: Icons.insert_drive_file,
                  color: Colors.grey,
                  size: '2.5KB',
                  updateTime: DateTime(2024, 1, 15),
                ),
                'isLeaf': true,
              },
              {
                'id': '1-1-2',
                'data': FileMeta(
                  name: 'app.dart',
                  type: 'file',
                  icon: Icons.insert_drive_file,
                  color: Colors.grey,
                  size: '1.8KB',
                  updateTime: DateTime(2024, 1, 12),
                ),
                'isLeaf': true,
              },
            ],
          },
          {
            'id': '1-2',
            'data': const FileMeta(
              name: '资源文件',
              type: 'folder',
              icon: Icons.folder,
              color: Colors.amber,
              fileCount: 2,
            ),
            'children': [
              {
                'id': '1-2-1',
                'data': FileMeta(
                  name: 'logo.png',
                  type: 'image',
                  icon: Icons.image,
                  color: Colors.green,
                  size: '45KB',
                  updateTime: DateTime(2024, 1, 10),
                ),
                'isLeaf': true,
              },
              {
                'id': '1-2-2',
                'data': FileMeta(
                  name: 'README.md',
                  type: 'document',
                  icon: Icons.description,
                  color: Colors.blue,
                  size: '3.2KB',
                  updateTime: DateTime(2024, 1, 8),
                ),
                'isLeaf': true,
              },
            ],
          },
          {
            'id': '1-3',
            'data': const FileMeta(
              name: '空文件夹',
              type: 'folder',
              icon: Icons.folder_outlined,
              color: Colors.amber,
              fileCount: 0,
            ),
            'isLeaf': true,
          },
        ],
      },
    ];
