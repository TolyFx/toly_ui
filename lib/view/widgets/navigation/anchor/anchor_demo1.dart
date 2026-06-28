import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_anchor/tolyui_anchor.dart';

@DisplayNode(
  title: '基础用法',
  desc: 'TolyAnchor 用于锚点导航，基于 ScrollablePositionedList 实现索引级滚动控制。\n左侧 TolyAnchor 显示导航列表，右侧 TolyAnchorScrollable 显示对应内容区域。\n点击左侧导航项时，右侧内容会平滑滚动到对应位置；滚动右侧内容时，左侧导航会自动高亮当前可见区域对应的项。\nTolyAnchor 内部使用 ListView.builder，支持大量导航项的性能优化。',
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
          SizedBox(
            width: 150,
            child: TolyAnchor(
              controller: _controller,
              links: _links,
            ),
          ),
          VerticalDivider(),
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

    return Container(
      padding: const EdgeInsets.all(24),
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
            '这是 ${link.title} 部分的内容。点击左侧导航可快速跳转到对应区域。'*(index+1)*4,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
