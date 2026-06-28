import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_anchor/tolyui_anchor.dart';

@DisplayNode(
  title: '横向滚动',
  desc: 'TolyAnchor 和 TolyAnchorScrollable 支持横向滚动模式。\n通过 scrollDirection: Axis.horizontal 设置滚动方向。\n适用于标签页切换、时间线导航等横向布局场景。\n左侧导航变为水平列表，右侧内容区域也变为横向滚动。',
)
class AnchorDemo4 extends StatefulWidget {
  const AnchorDemo4({super.key});

  @override
  State<AnchorDemo4> createState() => _AnchorDemo4State();
}

class _AnchorDemo4State extends State<AnchorDemo4> {
  final TolyAnchorController _controller = TolyAnchorController();

  final List<TolyAnchorLink> _links = const [
    TolyAnchorLink(title: '首页', href: 'home'),
    TolyAnchorLink(title: '产品', href: 'product'),
    TolyAnchorLink(title: '案例', href: 'case'),
    TolyAnchorLink(title: '关于', href: 'about'),
    TolyAnchorLink(title: '联系', href: 'contact'),
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
          // 顶部横向导航
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
          // 横向内容区域
          Expanded(
            child: TolyAnchorScrollable(
              controller: _controller,
              itemCount: _links.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => _buildPage(index),
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

  Widget _buildPage(int index) {
    final link = _links[index];
    final colors = [
      Colors.blue.shade50,
      Colors.green.shade50,
      Colors.orange.shade50,
      Colors.purple.shade50,
      Colors.teal.shade50,
    ];

    return Container(
      width: 400,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colors[index],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            [Icons.home, Icons.inventory_2, Icons.work, Icons.info, Icons.mail][index],
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          Text(
            link.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '这是 ${link.title} 页面的内容。\n可以左右滑动切换页面，或点击顶部标签跳转。',
            textAlign: TextAlign.center,
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
