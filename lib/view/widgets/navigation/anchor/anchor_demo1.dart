import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_anchor/tolyui_anchor.dart';

@DisplayNode(
  title: '基础用法',
  desc: 'TolyAnchor 用于锚点导航，基于 scrollable_positioned_list 实现，支持精确跳转到指定索引。',
)
class AnchorDemo1 extends StatefulWidget {
  const AnchorDemo1({super.key});

  @override
  State<AnchorDemo1> createState() => _AnchorDemo1State();
}

class _AnchorDemo1State extends State<AnchorDemo1> {
  final TolyAnchorController _controller = TolyAnchorController();

  final List<TolyAnchorLink> _links = const [
    TolyAnchorLink(title: '概览', href: 'overview'),
    TolyAnchorLink(title: '特性', href: 'features'),
    TolyAnchorLink(title: '安装', href: 'installation'),
    TolyAnchorLink(title: '快速开始', href: 'quick-start'),
    TolyAnchorLink(title: 'API', href: 'api'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧锚点导航
          Container(
            width: 160,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: TolyAnchor(
              controller: _controller,
              links: _links,
            ),
          ),
          // 右侧内容区域
          Expanded(
            child: TolyAnchorScrollable(
              controller: _controller,
              itemCount: _links.length,
              itemBuilder: (context, index) => _buildSection(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(int index) {
    final link = _links[index];
    final colors = [
      Colors.blue.shade50,
      Colors.green.shade50,
      Colors.orange.shade50,
      Colors.purple.shade50,
      Colors.red.shade50,
    ];

    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors[index],
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            link.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '这是 ${link.title} 部分的内容。点击左侧导航可快速跳转到对应区域。',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
