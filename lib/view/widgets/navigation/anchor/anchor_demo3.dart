import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_anchor/tolyui_anchor.dart';

@DisplayNode(
  title: '大量数据测试',
  desc: '测试 TolyAnchor 在极端数据量（300 项）场景下的性能表现。'
      'TolyAnchor 内置 ListView.builder 实现虚拟滚动，仅渲染可视区域的导航项，内存占用稳定。'
      'TolyAnchorScrollable 基于 ScrollablePositionedList，同样支持高效的按需构建。'
      '滚动过程中，左侧导航会自动跟随高亮并滚动确保激活项可见，交互流畅无卡顿。'
      '可用于验证长列表场景下的滚动监听、高亮切换、导航跟随等功能稳定性。',
)
class AnchorDemo3 extends StatefulWidget {
  const AnchorDemo3({super.key});

  @override
  State<AnchorDemo3> createState() => _AnchorDemo3State();
}

class _AnchorDemo3State extends State<AnchorDemo3> {
  final TolyAnchorController _controller = TolyAnchorController();
  final ScrollController _navScrollController = ScrollController(keepScrollOffset: false);

  late final List<TolyAnchorLink> _links;
  late final List<_NavItem> _items;

  @override
  void initState() {
    super.initState();
    _generateItems();
  }

  void _generateItems() {
    // 生成 300 个测试项
    _items = List.generate(300, (index) {
      final colors = [
        Colors.blue,
        Colors.green,
        Colors.orange,
        Colors.purple,
        Colors.red,
        Colors.teal,
        Colors.indigo,
        Colors.pink,
      ];
      
      return _NavItem(
        tag: 'item_$index',
        title: '章节 ${index + 1}',
        subtitle: '这是第 ${index + 1} 个测试章节的内容描述'*((index+1)%10),
        color: colors[index % colors.length].shade50,
        icon: Icons.article,
      );
    });

    _links = _items.map((item) => TolyAnchorLink(
      title: item.title,
      href: item.tag,
    )).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    _navScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧紧凑导航
          Container(
            width: 140,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                right: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Column(
              children: [
                // 统计信息
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.list, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '共 ${_items.length} 项',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // 导航列表
                Expanded(
                  child: TolyAnchor(
                    controller: _controller,
                    links: _links,
                    linkBuilder: _buildCompactLink,
                    scrollController: _navScrollController,
                  ),
                ),
              ],
            ),
          ),
          // 右侧内容
          Expanded(
            child: TolyAnchorScrollable(
              controller: _controller,
              itemCount: _links.length,
              itemBuilder: (context, index) => _buildItem(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactLink(BuildContext context, TolyAnchorLink link, bool active) {
    final index = _links.indexOf(link);
    
    return InkWell(
      onTap: () => _controller.scrollToIndex(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : null,
          border: Border(
            left: BorderSide(
              color: active ? Theme.of(context).colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: active ? Theme.of(context).colorScheme.primary : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                link.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                  color: active ? Theme.of(context).colorScheme.primary : Colors.grey.shade700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    final item = _items[index];
    
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12,left: 24,right: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(item.icon, size: 32, color: Colors.grey.shade600),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final String tag;
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  _NavItem({
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });
}
