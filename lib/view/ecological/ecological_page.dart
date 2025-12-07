import 'package:flutter/material.dart';

class EcologicalPage extends StatelessWidget {
  const EcologicalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TolyUI 生态',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '基于 TolyUI 构建的开源生态系统',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 48),
            _buildSection(
              title: '核心包',
              items: [
                _EcoItem(
                  name: 'tolyui',
                  desc: 'TolyUI 核心包，包含所有基础组件',
                  icon: Icons.widgets,
                  color: Colors.blue,
                  version: '0.0.4',
                ),
                _EcoItem(
                  name: 'tolyui_navigation',
                  desc: '导航组件包，提供菜单、面包屑等组件',
                  icon: Icons.navigation,
                  color: Colors.purple,
                  version: '0.2.0',
                ),
                _EcoItem(
                  name: 'tolyui_feedback',
                  desc: '反馈组件包，提供消息、通知等组件',
                  icon: Icons.feedback,
                  color: Colors.orange,
                  version: '0.3.5',
                ),
                _EcoItem(
                  name: 'tolyui_message',
                  desc: '消息提示组件包',
                  icon: Icons.message,
                  color: Colors.green,
                  version: '0.1.0',
                ),
              ],
            ),
            const SizedBox(height: 48),
            _buildSection(
              title: '功能包',
              items: [
                _EcoItem(
                  name: 'tolyui_color',
                  desc: '颜色工具包，提供颜色选择器等工具',
                  icon: Icons.palette,
                  color: Colors.pink,
                  version: '0.0.2',
                ),
                _EcoItem(
                  name: 'tolyui_text',
                  desc: '文本组件包，提供丰富的文本处理功能',
                  icon: Icons.text_fields,
                  color: Colors.teal,
                  version: '0.1.0',
                ),
                _EcoItem(
                  name: 'tolyui_statistic',
                  desc: '统计组件包，用于数据展示',
                  icon: Icons.bar_chart,
                  color: Colors.indigo,
                  version: '0.0.1',
                ),
              ],
            ),
            const SizedBox(height: 48),
            _buildSection(
              title: '工具链',
              items: [
                _EcoItem(
                  name: 'TolyUI CLI',
                  desc: '命令行工具，快速创建项目和组件',
                  icon: Icons.terminal,
                  color: Colors.grey,
                  version: '开发中',
                ),
                _EcoItem(
                  name: 'TolyUI DevTools',
                  desc: '开发者工具，调试和优化组件',
                  icon: Icons.developer_mode,
                  color: Colors.brown,
                  version: '计划中',
                ),
              ],
            ),
            const SizedBox(height: 48),
            _buildSection(
              title: '社区资源',
              items: [
                _EcoItem(
                  name: 'GitHub',
                  desc: '源代码仓库，欢迎 Star 和 PR',
                  icon: Icons.code,
                  color: Colors.black87,
                  version: 'github.com/toly1994328',
                ),
                _EcoItem(
                  name: '在线文档',
                  desc: '完整的组件文档和示例',
                  icon: Icons.book,
                  color: Colors.blue,
                  version: 'toly1994.com/ui',
                ),
                _EcoItem(
                  name: '社区讨论',
                  desc: '加入社区，交流学习',
                  icon: Icons.forum,
                  color: Colors.deepOrange,
                  version: '即将开放',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<_EcoItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: items.map((item) => _buildEcoCard(item)).toList(),
        ),
      ],
    );
  }

  Widget _buildEcoCard(_EcoItem item) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.version,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            item.desc,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _EcoItem {
  final String name;
  final String desc;
  final IconData icon;
  final Color color;
  final String version;

  _EcoItem({
    required this.name,
    required this.desc,
    required this.icon,
    required this.color,
    required this.version,
  });
}
