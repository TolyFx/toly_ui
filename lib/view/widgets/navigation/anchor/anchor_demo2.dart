import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_anchor/tolyui_anchor.dart';

@DisplayNode(
  title: '自定义样式',
  desc: '通过 linkBuilder 自定义锚点导航项的样式，可以完全控制激活态和普通态的显示效果。',
)
class AnchorDemo2 extends StatefulWidget {
  const AnchorDemo2({super.key});

  @override
  State<AnchorDemo2> createState() => _AnchorDemo2State();
}

class _AnchorDemo2State extends State<AnchorDemo2> {
  final TolyAnchorController _controller = TolyAnchorController();

  final List<TolyAnchorLink> _links = const [
    TolyAnchorLink(title: '基础组件', href: 'basic'),
    TolyAnchorLink(title: '表单组件', href: 'form'),
    TolyAnchorLink(title: '导航组件', href: 'navigation'),
    TolyAnchorLink(title: '数据展示', href: 'data'),
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
          // 左侧自定义样式锚点导航
          Container(
            width: 180,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TolyAnchor(
              controller: _controller,
              links: _links,
              linkBuilder: _buildCustomLink,
            ),
          ),
          const SizedBox(width: 16),
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

  Widget _buildCustomLink(BuildContext context, TolyAnchorLink link, bool active) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: active ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: active ? Theme.of(context).colorScheme.primary : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            active ? Icons.bookmark : Icons.bookmark_border,
            size: 18,
            color: active ? Theme.of(context).colorScheme.primary : Colors.grey.shade600,
          ),
          const SizedBox(width: 8),
          Text(
            link.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              color: active ? Theme.of(context).colorScheme.primary : Colors.grey.shade700,
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
    ];
    final descriptions = [
      'Button, Icon, Text, Link 等',
      'Input, Select, Checkbox, Radio 等',
      'Tabs, Breadcrumb, Anchor 等',
      'Tree, Table, Tag, Card 等',
    ];

    return Container(
      width: double.infinity,
      height: 180,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: colors[index],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            link.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            descriptions[index],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
