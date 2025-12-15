import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '自定义数据结构',
  desc:
      '展示如何使用自定义数据类型构建树形组件。通过 FileMeta 类封装文件信息，包含名称、类型、图标、颜色、大小和更新时间等属性。每个节点根据文件类型显示不同的图标和颜色，文件夹显示子项数量，文件显示大小和修改日期。点击节点会在控制台输出详细信息，包括节点类型、层级和子项情况。这种方式提供了类型安全的数据访问和更丰富的展示效果，适用于文件管理、资源浏览等需要详细信息展示的场景。',
)
class TreeDemo3 extends StatelessWidget {
  const TreeDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyTree<FileMeta>(
      showConnectingLines: true,
      nodes: _buildSampleData(),
      expandIcon: const Icon(
        Icons.star,
        color: Colors.blue,
        size: 18,
      ),
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
    return _backendData
        .map((map) =>
            TreeNode<FileMeta>.fromMap(map, dataParser: FileMeta.fromJson))
        .toList();
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

  factory FileMeta.fromJson(dynamic json) {
    return FileMeta(
      name: json['name'] ?? '',
      type: json['type'] ?? 'file',
      icon: _getIconFromType(json['type']),
      color: _getColorFromType(json['type']),
      size: json['size'],
      updateTime: json['updateTime'] != null
          ? DateTime.parse(json['updateTime'])
          : null,
      fileCount: json['fileCount'],
    );
  }

  static IconData _getIconFromType(String? type) {
    switch (type) {
      case 'folder':
        return Icons.folder;
      case 'image':
        return Icons.image;
      case 'document':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  static Color _getColorFromType(String? type) {
    switch (type) {
      case 'folder':
        return Colors.amber;
      case 'image':
        return Colors.green;
      case 'document':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

// 模拟后端返回的数据结构
List<Map<String, dynamic>> get _backendData => [
      {
        'id': '1',
        'data': {
          'name': '项目文件夹',
          'type': 'folder',
          'fileCount': 4,
        },
        'children': [
          {
            'id': '1-1',
            'data': {
              'name': '源代码',
              'type': 'folder',
              'fileCount': 2,
            },
            'children': [
              {
                'id': '1-1-1',
                'data': {
                  'name': 'main.dart',
                  'type': 'file',
                  'size': '2.5KB',
                  'updateTime': '2024-01-15T00:00:00.000Z',
                },
                'isLeaf': true,
              },
              {
                'id': '1-1-2',
                'data': {
                  'name': 'app.dart',
                  'type': 'file',
                  'size': '1.8KB',
                  'updateTime': '2024-01-12T00:00:00.000Z',
                },
                'isLeaf': true,
              },
            ],
          },
          {
            'id': '1-2',
            'data': {
              'name': '资源文件',
              'type': 'folder',
              'fileCount': 2,
            },
            'children': [
              {
                'id': '1-2-1',
                'data': {
                  'name': 'logo.png',
                  'type': 'image',
                  'size': '45KB',
                  'updateTime': '2024-01-10T00:00:00.000Z',
                },
                'isLeaf': true,
              },
              {
                'id': '1-2-2',
                'data': {
                  'name': 'README.md',
                  'type': 'document',
                  'size': '3.2KB',
                  'updateTime': '2024-01-08T00:00:00.000Z',
                },
                'isLeaf': true,
              },
            ],
          },
          {
            'id': '1-3',
            'data': {
              'name': '空文件夹',
              'type': 'folder',
              'fileCount': 0,
            },
            'isLeaf': true,
          },
        ],
      },
    ];
