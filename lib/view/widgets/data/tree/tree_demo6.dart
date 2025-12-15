import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';


@DisplayNode(
  title: '动画曲线树形',
  desc:
      '展示不同动画曲线效果的树形组件对比。四个区域分别展示线性动画、缓入缓出、弹性效果和回弹效果四种不同的动画曲线。每个树形组件都使用相同的数据结构和布局，但应用不同的动画曲线和 600 毫秒的动画时长。点击展开收起节点时可以直观对比各种曲线的视觉效果，线性动画均匀平滑，缓入缓出更加自然，弹性和回弹效果则带有明显的个性化特征。这种对比展示帮助开发者选择最适合项目风格的动画效果。',
)
class TreeDemo6 extends StatelessWidget {
  const TreeDemo6({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildCurveSection('线性动画', Curves.linear)),
            const SizedBox(width: 16),
            Expanded(child: _buildCurveSection('缓入缓出', Curves.easeInOut)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildCurveSection('弹性效果', Curves.elasticOut)),
            const SizedBox(width: 16),
            Expanded(child: _buildCurveSection('回弹效果', Curves.bounceOut)),
          ],
        ),
      ],
    );
  }

  Widget _buildCurveSection(String title, Curve curve) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TolyTree<_FileMeta>(
            nodes: _buildSampleData(title),
            animationDuration: const Duration(milliseconds: 600),
            animationCurve: curve,
            nodeBuilder: (node) => Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: Row(
                children: [
                  Icon(node.data.icon, size: 14, color: node.data.color),
                  const SizedBox(width: 6),
                  Text(node.data.name, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<TreeNode<_FileMeta>> _buildSampleData(String curveType) {
    return [
      TreeNode<_FileMeta>(
        id: '1',
        data: _FileMeta(
          name: '$curveType演示',
          type: 'folder',
          icon: Icons.animation,
          color: Colors.purple,
        ),
        children: [
          TreeNode<_FileMeta>(
            id: '1-1',
            data: const _FileMeta(
              name: '子项目A',
              type: 'folder',
              icon: Icons.folder,
              color: Colors.blue,
            ),
            children: [
              TreeNode<_FileMeta>(
                id: '1-1-1',
                data: const _FileMeta(
                  name: '文件1.dart',
                  type: 'file',
                  icon: Icons.code,
                  color: Colors.green,
                ),
                isLeaf: true,
              ),
              TreeNode<_FileMeta>(
                id: '1-1-2',
                data: const _FileMeta(
                  name: '文件2.dart',
                  type: 'file',
                  icon: Icons.code,
                  color: Colors.green,
                ),
                isLeaf: true,
              ),
            ],
          ),
          TreeNode<_FileMeta>(
            id: '1-2',
            data: const _FileMeta(
              name: '子项目B',
              type: 'folder',
              icon: Icons.folder,
              color: Colors.blue,
            ),
            children: [
              TreeNode<_FileMeta>(
                id: '1-2-1',
                data: const _FileMeta(
                  name: '配置文件',
                  type: 'file',
                  icon: Icons.settings,
                  color: Colors.orange,
                ),
                isLeaf: true,
              ),
            ],
          ),
        ],
      ),
    ];
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
