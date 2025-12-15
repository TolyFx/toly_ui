import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';


@DisplayNode(
  title: '虚拟滚动树形',
  desc:
      '展示大数据量下的虚拟滚动树形组件。本案例包含 60,000 个节点，通过设置固定高度启用虚拟滚动模式。组件只会渲染可见区域内的节点，大幅提升性能和流畅度。支持完整的展开收起交互，在滚动过程中保持节点状态。还支持异步加载功能，点击某些节点时会动态加载新的子节点。这种模式适用于大型数据库浏览、文件系统管理、组织架构展示等需要处理大量层级数据的场景。',
)
class TreeDemo4 extends StatefulWidget {
  const TreeDemo4({super.key});

  @override
  State<TreeDemo4> createState() => _TreeDemo4State();
}

class _TreeDemo4State extends State<TreeDemo4> {
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
                  count: 100),
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
