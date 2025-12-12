import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'toly_tree.dart';

@DisplayNode(
  title: '虚拟滚动树形',
  desc:
      '展示虚拟滚动模式的树形组件。通过指定高度启用虚拟滚动，只渲染可见区域的节点，适合处理大量数据。支持异步加载和完整的交互功能，在固定高度容器内流畅滚动浏览。',
)
class TreeDemo6 extends StatefulWidget {
  const TreeDemo6({super.key});

  @override
  State<TreeDemo6> createState() => _TreeDemo6State();
}

class _TreeDemo6State extends State<TreeDemo6> {
  late List<TreeNode<_VirtualData>> data = _buildLargeDataSet();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('60,000个节点'),
          ),
          TolyTree<_VirtualData>(
            height: 300,
            nodes: data,
            loadData: _loadChildren,
            nodeBuilder: (node) => Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                children: [
                  Icon(node.data.icon, size: 16, color: node.data.color),
                  const SizedBox(width: 8),
                  Text(node.data.name),
                  if (node.data.count != null)
                    Text(' (${node.data.count})',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TreeNode<_VirtualData>> _buildLargeDataSet() {
    return List.generate(
        100,
        (i) => TreeNode<_VirtualData>(
              id: 'root-$i',
              data: _VirtualData(
                name: '根节点 ${i + 1}',
                icon: Icons.folder,
                color: Colors.blue,
                count: 100,
              ),
              children: List.generate(
                  20,
                  (j) => TreeNode<_VirtualData>(
                        id: 'root-$i-child-$j',
                        data: _VirtualData(
                          name: '子节点 ${j + 1}',
                          icon: Icons.folder_outlined,
                          color: Colors.orange,
                        ),
                        children: List.generate(
                            30,
                            (k) => TreeNode<_VirtualData>(
                                  id: 'root-$i-child-$j-leaf-$k',
                                  data: _VirtualData(
                                    name: '叶子节点 ${k + 1}',
                                    icon: Icons.insert_drive_file,
                                    color: Colors.grey,
                                  ),
                                  isLeaf: true,
                                )),
                      )),
            ));
  }

  Future<List<TreeNode<_VirtualData>>> _loadChildren(
      TreeNode<_VirtualData> node) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return List.generate(
        5,
        (i) => TreeNode<_VirtualData>(
              id: '${node.id}-async-$i',
              data: _VirtualData(
                name: '异步加载 ${i + 1}',
                icon: Icons.cloud_download,
                color: Colors.green,
              ),
              isLeaf: true,
            ));
  }
}

class _VirtualData {
  final String name;
  final IconData icon;
  final Color color;
  final int? count;

  const _VirtualData({
    required this.name,
    required this.icon,
    required this.color,
    this.count,
  });
}
