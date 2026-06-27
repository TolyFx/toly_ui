import 'package:flutter/material.dart';
import 'package:tolyui_anchor/tolyui_anchor.dart';

void main() {
  runApp(const AnchorV2TestApp());
}

class AnchorV2TestApp extends StatelessWidget {
  const AnchorV2TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TolyUI Anchor V2 测试',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const AnchorV2TestPage(),
    );
  }
}

class AnchorV2TestPage extends StatefulWidget {
  const AnchorV2TestPage({super.key});

  @override
  State<AnchorV2TestPage> createState() => _AnchorV2TestPageState();
}

class _AnchorV2TestPageState extends State<AnchorV2TestPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('TolyUI Anchor V2 - 基于 scrollable_positioned_list'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          ListenableBuilder(
            listenable: _controller,
            builder: (context, child) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '当前: ${_controller.activeIndex + 1}/${_links.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧导航
          Container(
            width: 160,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(
                right: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: TolyAnchor(
              controller: _controller,
              links: _links,
            ),
          ),
          // 右侧内容
          Expanded(
            child: TolyAnchorScrollable(
              controller: _controller,
              itemCount: _links.length,
              itemBuilder: (context, index) {
                return _buildSection(index);
              },
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
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(16),
      height: 200,
      decoration: BoxDecoration(
        color: colors[index % colors.length],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '#${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                link.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '这是 ${link.title} 部分的内容。'
            '基于 scrollable_positioned_list 实现，支持精确跳转。'
            '点击左侧导航或手动滚动，观察高亮变化。',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
