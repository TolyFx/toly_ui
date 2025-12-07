import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class StartUsePage extends StatelessWidget {
  const StartUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '开始使用',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            _buildSection(
              title: '相关链接',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.public, size: 20, color: Color(0xFF666666)),
                      const SizedBox(width: 8),
                      const Text('在线展示：'),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => _launchUrl('http://toly1994.com/ui'),
                        child: Text(
                          'http://toly1994.com/ui',
                          style: TextStyle(
                            color: Colors.blue[700],
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.code, size: 20, color: Color(0xFF666666)),
                      const SizedBox(width: 8),
                      const Text('GitHub：'),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => _launchUrl('https://github.com/TolyFx/toly_ui'),
                        child: Text(
                          'https://github.com/TolyFx/toly_ui',
                          style: TextStyle(
                            color: Colors.blue[700],
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.library_books, size: 20, color: Color(0xFF666666)),
                      const SizedBox(width: 8),
                      const Text('Pub.dev：'),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => _launchUrl('https://pub.dev/packages/tolyui'),
                        child: Text(
                          'https://pub.dev/packages/tolyui',
                          style: TextStyle(
                            color: Colors.blue[700],
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            _buildSection(
              title: '安装',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('在 pubspec.yaml 文件中添加依赖：'),
                  const SizedBox(height: 16),
                  _buildCodeBlock(
                    'dependencies:\n  toly_ui: ^latest_version',
                  ),
                  const SizedBox(height: 16),
                  const Text('然后运行：'),
                  const SizedBox(height: 16),
                  _buildCodeBlock('flutter pub get'),
                ],
              ),
            ),
            const SizedBox(height: 48),
            _buildSection(
              title: '引入',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('在需要使用的文件中导入：'),
                  const SizedBox(height: 16),
                  _buildCodeBlock("import 'package:toly_ui/toly_ui.dart';"),
                ],
              ),
            ),
            const SizedBox(height: 48),
            _buildSection(
              title: '快速开始',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('使用 TolyUI 组件非常简单，以 Button 为例：'),
                  const SizedBox(height: 16),
                  _buildCodeBlock(
                    'TolyButton(\n'
                    '  onPressed: () {},\n'
                    '  child: Text(\'点击按钮\'),\n'
                    ')',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            _buildSection(
              title: '特性',
              content: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildFeatureCard(
                    icon: Icons.widgets,
                    title: '丰富组件',
                    desc: '提供基础、表单、数据、导航、反馈等多种组件',
                  ),
                  _buildFeatureCard(
                    icon: Icons.palette,
                    title: '主题定制',
                    desc: '支持灵活的主题配置和样式定制',
                  ),
                  _buildFeatureCard(
                    icon: Icons.code,
                    title: '开箱即用',
                    desc: '简洁的 API 设计，快速上手',
                  ),
                  _buildFeatureCard(
                    icon: Icons.phone_android,
                    title: '跨平台',
                    desc: '完美支持 iOS、Android、Web 等平台',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget content}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 20),
          content,
        ],
      ),
    );
  }

  Widget _buildCodeBlock(String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SelectableText(
              code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: Color(0xFFD4D4D4),
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                Clipboard.setData(ClipboardData(text: code));
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.copy, size: 18, color: Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $urlString');
    }
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String desc,
  }) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[700]!, Colors.blue[500]!],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
