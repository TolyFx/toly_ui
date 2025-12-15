import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';


@DisplayNode(
  title: '异步加载树形',
  desc:
      '展示支持异步加载子节点的树形组件。初始状态下只显示根节点，带有“点击加载”提示的节点可以展开加载子内容。点击这些节点时会显示加载动画，模拟 2 秒的网络请求过程，然后动态渲染新的子节点。不同的节点会返回不同的子内容，有些子节点还可以继续异步加载更深层级的内容。这种模式适用于大型数据集、远程文件系统、API 数据浏览等需要按需加载的场景。',
)
class TreeDemo5 extends StatelessWidget {
  const TreeDemo5({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyTree<_AsyncData>(
      nodes: _buildInitialData(),
      loadData: _loadChildren,
      nodeBuilder: (node) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            Icon(node.data.icon, size: 16, color: node.data.color),
            const SizedBox(width: 8),
            Text(node.data.name),
            if (node.isLeaf == null && node.children.isEmpty)
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text('(点击加载)',
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
          ],
        ),
      ),
    );
  }

  List<TreeNode<_AsyncData>> _buildInitialData() {
    return [
      TreeNode<_AsyncData>(
        id: '1',
        data: const _AsyncData(
          name: '根目录',
          icon: Icons.folder,
          color: Colors.amber,
        ),
      ),
      TreeNode<_AsyncData>(
        id: '2',
        data: const _AsyncData(
          name: '用户文档',
          icon: Icons.folder,
          color: Colors.blue,
        ),
      ),
      TreeNode<_AsyncData>(
        id: '3',
        data: const _AsyncData(
          name: '只读文件',
          icon: Icons.lock,
          color: Colors.grey,
        ),
        isLeaf: true,
      ),
    ];
  }

  Future<List<TreeNode<_AsyncData>>> _loadChildren(
      TreeNode<_AsyncData> node) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(seconds: 2));

    switch (node.id) {
      case '1':
        return [
          TreeNode<_AsyncData>(
            id: '1-1',
            data: const _AsyncData(
              name: '系统文件',
              icon: Icons.folder,
              color: Colors.red,
            ),
          ),
          TreeNode<_AsyncData>(
            id: '1-2',
            data: const _AsyncData(
              name: '应用程序',
              icon: Icons.folder,
              color: Colors.green,
            ),
            children: [
              TreeNode<_AsyncData>(
                id: '1-2-1',
                data: const _AsyncData(
                  name: 'app1.exe',
                  icon: Icons.apps,
                  color: Colors.grey,
                ),
                isLeaf: true,
              ),
            ],
          ),
        ];
      case '2':
        return [
          TreeNode<_AsyncData>(
            id: '2-1',
            data: const _AsyncData(
              name: '我的文档',
              icon: Icons.description,
              color: Colors.blue,
            ),
            isLeaf: true,
          ),
          TreeNode<_AsyncData>(
            id: '2-2',
            data: const _AsyncData(
              name: '下载文件',
              icon: Icons.download,
              color: Colors.purple,
            ),
            isLeaf: true,
          ),
        ];
      case '1-1':
        return [
          TreeNode<_AsyncData>(
            id: '1-1-1',
            data: const _AsyncData(
              name: 'system32',
              icon: Icons.folder,
              color: Colors.red,
            ),
            isLeaf: true,
          ),
          TreeNode<_AsyncData>(
            id: '1-1-2',
            data: const _AsyncData(
              name: 'drivers',
              icon: Icons.folder,
              color: Colors.red,
            ),
            isLeaf: true,
          ),
        ];
      default:
        return [];
    }
  }
}

class _AsyncData {
  final String name;
  final IconData icon;
  final Color color;

  const _AsyncData({
    required this.name,
    required this.icon,
    required this.color,
  });
}
