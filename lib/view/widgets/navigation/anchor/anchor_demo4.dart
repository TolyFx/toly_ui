import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_anchor/tolyui_anchor.dart';

@DisplayNode(
  title: '横向标签导航',
  desc: '顶部横向标签导航，内容区域竖直滚动。\nTolyAnchor 设置 scrollDirection: Axis.horizontal 实现横向标签列表。\nTolyAnchorScrollable 保持默认垂直滚动，内容按页面分段。\n适用于文档目录、章节导航等场景。',
)
class AnchorDemo4 extends StatefulWidget {
  const AnchorDemo4({super.key});

  @override
  State<AnchorDemo4> createState() => _AnchorDemo4State();
}

class _AnchorDemo4State extends State<AnchorDemo4> {
  final TolyAnchorController _controller = TolyAnchorController();

  final List<TolyAnchorLink> _links = const [
    TolyAnchorLink(title: '概述', href: 'overview'),
    TolyAnchorLink(title: '快速开始', href: 'quick-start'),
    TolyAnchorLink(title: '核心概念', href: 'concepts'),
    TolyAnchorLink(title: 'API 参考', href: 'api'),
    TolyAnchorLink(title: '最佳实践', href: 'best-practices'),
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
      child: Column(
        children: [
          // 顶部横向标签导航
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: TolyAnchor(
              controller: _controller,
              links: _links,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              linkBuilder: _buildTabLink,
            ),
          ),
          // 竖直滚动内容区域
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

  Widget _buildTabLink(BuildContext context, TolyAnchorLink link, bool active) {
    final index = _links.indexOf(link);

    return InkWell(
      onTap: () => _controller.scrollToIndex(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? Theme.of(context).colorScheme.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Center(
          child: Text(
            link.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: active ? FontWeight.w600 : FontWeight.normal,
              color: active ? Theme.of(context).colorScheme.primary : Colors.grey.shade700,
            ),
          ),
        ),
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
      Colors.teal.shade50,
    ];
    final contents = [
      'TolyUI Anchor 是一个强大的锚点导航组件，基于 ScrollablePositionedList 实现。\n\n核心特性：\n• 支持索引级滚动控制\n• 自动高亮当前可见区域\n• 支持自定义导航项样式\n• 内置虚拟滚动，高性能',
      '安装依赖：\n\nflutter pub add tolyui_anchor\n\n基本用法：\n\nfinal controller = TolyAnchorController();\n\nTolyAnchor(controller: controller, links: links)\nTolyAnchorScrollable(controller: controller, itemCount: 5, itemBuilder: ...)',
      'TolyAnchorController\n• scrollToIndex(index) - 滚动到指定索引\n• activeIndex - 当前激活的索引\n• itemScrollController - 底层滚动控制器\n\nTolyAnchorLink\n• title - 显示标题\n• href - 锚点标识',
      'scrollToIndex(index, {duration, curve})\n  滚动到指定索引，支持动画\n\nscrollTo(tag, {duration, curve})\n  通过标签名滚动\n\njumpToIndex(index)\n  无动画跳转到指定索引',
      '1. 使用 ListView.builder 处理大量导航项\n2. 避免在 linkBuilder 中执行耗时操作\n3. 合理设置 scrollOffset 确保激活项可见\n4. 横向导航时设置 scrollDirection: Axis.horizontal',
    ];

    return Container(
      padding: const EdgeInsets.all(32),
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
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors[index],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              contents[index],
              style: const TextStyle(
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
