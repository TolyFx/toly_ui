import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'toly_tree.dart';

@DisplayNode(
  title: '动画树形',
  desc: '带有平滑展开收起动画的树形组件。节点展开时有渐入效果，图标旋转动画，提供流畅的用户体验。同时展示点击事件监听和节点类型判断。',
)
class TreeDemo4 extends StatelessWidget {
  const TreeDemo4({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyTree<_FileMeta>(
      nodes: _buildSampleData(),
      animationDuration: const Duration(milliseconds: 300),
      onTap: (node) => print(
          '点击节点: ${node.data.name} - ${node.level == 0 ? '根节点' : '子节点(等级: ${node.level})'} - ${node.data.type == 'folder' ? ('文件夹' + (node.hasChildren ? '(有子项)' : '(空)')) : '文件'}'),
      nodeBuilder: (node) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(
              node.data.icon,
              size: 16,
              color: node.data.color,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                children: [
                  Text(
                    node.data.name,
                    style: TextStyle(
                      fontWeight: node.hasChildren
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                  if (node.data.fileCount != null)
                    Text(
                      ' (${node.data.fileCount})',
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

  List<TreeNode<_FileMeta>> _buildSampleData() {
    return _treeData.map(TreeNode<_FileMeta>.fromMap).toList();
  }
}

class _FileMeta {
  final String name;
  final String type;
  final IconData icon;
  final Color color;
  final int? fileCount;

  const _FileMeta({
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
    this.fileCount,
  });
}

List<Map<String, dynamic>> get _treeData => [
      {
        'id': '1',
        'data': const _FileMeta(
          name: '项目文件夹',
          type: 'folder',
          icon: Icons.folder,
          color: Colors.amber,
          fileCount: 4,
        ),
        'children': [
          {
            'id': '1-1',
            'data': const _FileMeta(
              name: '源代码',
              type: 'folder',
              icon: Icons.folder,
              color: Colors.amber,
              fileCount: 2,
            ),
            'children': [
              {
                'id': '1-1-1',
                'data': _FileMeta(
                  name: 'main.dart',
                  type: 'file',
                  icon: Icons.insert_drive_file,
                  color: Colors.grey,
                ),
              },
              {
                'id': '1-1-2',
                'data': _FileMeta(
                  name: 'app.dart',
                  type: 'file',
                  icon: Icons.insert_drive_file,
                  color: Colors.grey,
                ),
              },
            ],
          },
          {
            'id': '1-2',
            'data': const _FileMeta(
              name: '资源文件',
              type: 'folder',
              icon: Icons.folder,
              color: Colors.amber,
              fileCount: 2,
            ),
            'children': [
              {
                'id': '1-2-1',
                'data': _FileMeta(
                  name: 'logo.png',
                  type: 'image',
                  icon: Icons.image,
                  color: Colors.green,
                ),
              },
              {
                'id': '1-2-2',
                'data': _FileMeta(
                  name: 'README.md',
                  type: 'document',
                  icon: Icons.description,
                  color: Colors.blue,
                ),
              },
            ],
          },
          {
            'id': '1-3',
            'data': const _FileMeta(
              name: '空文件夹',
              type: 'folder',
              icon: Icons.folder_outlined,
              color: Colors.amber,
              fileCount: 0,
            ),
          },
        ],
      },
    ];
