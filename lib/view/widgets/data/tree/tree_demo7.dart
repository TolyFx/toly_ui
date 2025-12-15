import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';


@DisplayNode(
  title: '拖拽排序树形',
  desc:
      '展示支持拖拽排序的树形组件。文件可以拖入文件夹，文件夹可以拖入其他文件夹，支持同级排序和跨级移动。拖拽过程中会显示蓝色的放置提示线，上方线表示插入到目标上方，下方线表示插入到目标下方，边框表示放入目标内部。拖拽完成后会在右侧显示操作日志，记录每次移动的详细信息。这种交互模式常用于文件管理器、项目结构编辑、菜单配置等需要灵活调整层级结构的场景。',
)
class TreeDemo7 extends StatefulWidget {
  const TreeDemo7({super.key});

  @override
  State<TreeDemo7> createState() => _TreeDemo7State();
}

class _TreeDemo7State extends State<TreeDemo7> {
  late List<TreeNode<FileItem>> nodes;

  @override
  void initState() {
    super.initState();
    nodes = _buildFileTree();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: TolyDraggableTree<FileItem>(
        nodes: nodes,
        nodeBuilder: (node) => _buildFileNode(node),
        onNodeMoved: onMove,
      ),
    );
  }

  void onMove(DragResult<FileItem> result) {
    $message.success(message: '移动成功: ${result.dragNode.data.name}');
  }

  Widget _buildFileNode(TreeNode<FileItem> node) {
    final file = node.data;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          Icon(
            file.isFolder ? Icons.folder : _getFileIcon(file.name),
            size: 16,
            color: file.isFolder ? Colors.amber : Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(file.name)),
          if (!file.isFolder)
            Text(
              file.size ?? '',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'dart':
      case 'js':
      case 'ts':
        return Icons.code;
      case 'png':
      case 'jpg':
      case 'jpeg':
        return Icons.image;
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'txt':
      case 'md':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }

  List<TreeNode<FileItem>> _buildFileTree() {
    return [
      TreeNode<FileItem>(
        id: '1',
        data: const FileItem(name: '项目根目录', isFolder: true),
        isExpanded: true,
        children: [
          TreeNode<FileItem>(
            id: '1-1',
            data: const FileItem(name: 'lib', isFolder: true),
            isExpanded: true,
            children: [
              TreeNode<FileItem>(
                id: '1-1-1',
                data: const FileItem(
                    name: 'main.dart', isFolder: false, size: '2.5KB'),
                isLeaf: true,
              ),
              TreeNode<FileItem>(
                id: '1-1-2',
                data: const FileItem(
                    name: 'app.dart', isFolder: false, size: '1.8KB'),
                isLeaf: true,
              ),
              TreeNode<FileItem>(
                id: '1-1-3',
                data: const FileItem(name: 'widgets', isFolder: true),
                children: [
                  TreeNode<FileItem>(
                    id: '1-1-3-1',
                    data: const FileItem(
                        name: 'button.dart', isFolder: false, size: '3.2KB'),
                    isLeaf: true,
                  ),
                  TreeNode<FileItem>(
                    id: '1-1-3-2',
                    data: const FileItem(
                        name: 'input.dart', isFolder: false, size: '2.1KB'),
                    isLeaf: true,
                  ),
                ],
              ),
            ],
          ),
          TreeNode<FileItem>(
            id: '1-2',
            data: const FileItem(name: 'assets', isFolder: true),
            children: [
              TreeNode<FileItem>(
                id: '1-2-1',
                data: const FileItem(name: 'images', isFolder: true),
                children: [
                  TreeNode<FileItem>(
                    id: '1-2-1-1',
                    data: const FileItem(
                        name: 'logo.png', isFolder: false, size: '45KB'),
                    isLeaf: true,
                  ),
                  TreeNode<FileItem>(
                    id: '1-2-1-2',
                    data: const FileItem(
                        name: 'icon.png', isFolder: false, size: '12KB'),
                    isLeaf: true,
                  ),
                ],
              ),
              TreeNode<FileItem>(
                id: '1-2-2',
                data: const FileItem(name: 'fonts', isFolder: true),
                isLeaf: true,
              ),
            ],
          ),
          TreeNode<FileItem>(
            id: '1-3',
            data: const FileItem(
                name: 'README.md', isFolder: false, size: '3.2KB'),
            isLeaf: true,
          ),
          TreeNode<FileItem>(
            id: '1-4',
            data: const FileItem(
                name: 'pubspec.yaml', isFolder: false, size: '1.5KB'),
            isLeaf: true,
          ),
        ],
      ),
    ];
  }
}

class FileItem {
  final String name;
  final bool isFolder;
  final String? size;

  const FileItem({
    required this.name,
    required this.isFolder,
    this.size,
  });
}
