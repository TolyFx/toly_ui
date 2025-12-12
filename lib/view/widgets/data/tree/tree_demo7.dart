import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';
import 'toly_tree.dart';
import 'toly_draggable_tree.dart';

@DisplayNode(
  title: '拖拽排序树形',
  desc: '展示支持拖拽排序的树形组件。文件可以拖入文件夹，文件夹可以拖入其他文件夹，支持同级排序和跨级移动。'
      '拖拽过程中会显示蓝色的放置提示线，上方线表示插入到目标上方，下方线表示插入到目标下方，边框表示放入目标内部。'
      '拖拽完成后会在右侧显示操作日志，记录每次移动的详细信息。'
      '这种交互模式常用于文件管理器、项目结构编辑、菜单配置等需要灵活调整层级结构的场景。',
)
class TreeDemo7 extends StatefulWidget {
  const TreeDemo7({super.key});

  @override
  State<TreeDemo7> createState() => _TreeDemo7State();
}

class _TreeDemo7State extends State<TreeDemo7> {
  late List<TreeNode<FileItem>> nodes;
  List<String> operationLogs = [];

  @override
  void initState() {
    super.initState();
    nodes = _buildFileTree();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 350,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TolyDraggableTree<FileItem>(
              nodes: nodes,
              nodeBuilder: (node) => _buildFileNode(node),
              canDrop: _canDrop,
              onNodeMoved: _handleNodeMoved,
              dragFeedbackBuilder: (node) => ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: 150,
                  maxWidth: 250,
                  minHeight: 32,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildFileNode(node),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileNode(TreeNode<FileItem> node) {
    final file = node.data;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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

  bool _canDrop(TreeNode<FileItem> dragNode, TreeNode<FileItem>? targetNode,
      DropPosition position) {
    if (targetNode == null) return true;

    // 文件只能放入文件夹内部
    if (!dragNode.data.isFolder &&
        position == DropPosition.inside &&
        !targetNode.data.isFolder) {
      return false;
    }

    // 不能拖拽到自己或子节点
    if (dragNode == targetNode || _isDescendant(dragNode, targetNode)) {
      return false;
    }

    return true;
  }

  bool _isDescendant(TreeNode<FileItem> ancestor, TreeNode<FileItem> node) {
    for (final child in ancestor.children) {
      if (child == node || _isDescendant(child, node)) {
        return true;
      }
    }
    return false;
  }

  void _handleNodeMoved(DragResult<FileItem> result) {
    setState(() {
      // 从原位置移除
      _removeNodeFromTree(result.dragNode);

      // 添加到新位置
      _insertNodeToTree(result.dragNode, result.targetNode, result.position);

      // 记录操作日志
      _addOperationLog(result);
    });

    $message.success(message: '移动成功: ${result.dragNode.data.name}');
  }

  void _removeNodeFromTree(TreeNode<FileItem> node) {
    for (final rootNode in nodes) {
      if (_removeNodeRecursive(rootNode, node)) {
        return;
      }
    }
    nodes.remove(node);
  }

  bool _removeNodeRecursive(
      TreeNode<FileItem> parent, TreeNode<FileItem> nodeToRemove) {
    if (parent.children.remove(nodeToRemove)) {
      return true;
    }
    for (final child in parent.children) {
      if (_removeNodeRecursive(child, nodeToRemove)) {
        return true;
      }
    }
    return false;
  }

  void _insertNodeToTree(TreeNode<FileItem> node, TreeNode<FileItem>? target,
      DropPosition position) {
    if (target == null) {
      nodes.add(node);
      return;
    }

    switch (position) {
      case DropPosition.inside:
        target.children.add(node);
        target.isExpanded = true;
        break;
      case DropPosition.above:
        _insertNodeRelative(node, target, true);
        break;
      case DropPosition.below:
        _insertNodeRelative(node, target, false);
        break;
    }
  }

  void _insertNodeRelative(
      TreeNode<FileItem> node, TreeNode<FileItem> target, bool above) {
    // 查找目标节点的父节点和位置
    for (final rootNode in nodes) {
      final result = _findNodeParentAndIndex(rootNode, target);
      if (result != null) {
        final (parent, index) = result;
        if (parent != null) {
          parent.children.insert(above ? index : index + 1, node);
        } else {
          final rootIndex = nodes.indexOf(target);
          nodes.insert(above ? rootIndex : rootIndex + 1, node);
        }
        return;
      }
    }
  }

  (TreeNode<FileItem>?, int)? _findNodeParentAndIndex(
      TreeNode<FileItem> root, TreeNode<FileItem> target) {
    for (int i = 0; i < root.children.length; i++) {
      if (root.children[i] == target) {
        return (root, i);
      }
      final result = _findNodeParentAndIndex(root.children[i], target);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  void _addOperationLog(DragResult<FileItem> result) {
    final time = DateTime.now().toString().substring(11, 19);
    final dragName = result.dragNode.data.name;
    final targetName = result.targetNode?.data.name ?? '根目录';

    String action;
    switch (result.position) {
      case DropPosition.above:
        action = '移动到 $targetName 上方';
        break;
      case DropPosition.below:
        action = '移动到 $targetName 下方';
        break;
      case DropPosition.inside:
        action = '移动到 $targetName 内部';
        break;
    }

    operationLogs.insert(0, '[$time] $dragName $action');
    if (operationLogs.length > 50) {
      operationLogs.removeLast();
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
