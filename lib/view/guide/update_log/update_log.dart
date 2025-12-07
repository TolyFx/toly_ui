import 'package:flutter/material.dart';

class UpdateLogPage extends StatelessWidget {
  const UpdateLogPage({super.key});

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
              '更新日志',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'TolyUI 的版本更新记录',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 48),
            _buildVersion(
              version: '0.0.4',
              date: '2024-01',
              items: [
                _VersionItem(
                  type: VersionItemType.feature,
                  content: '新增 tolyui_statistic 统计组件',
                  version: '0.0.4+12',
                ),
                _VersionItem(
                  type: VersionItemType.feature,
                  content: '新增 tolyui_text 文本组件',
                  version: '0.0.4+11',
                ),
                _VersionItem(
                  type: VersionItemType.update,
                  content: 'tolyui_navigation 升级至 0.2.0',
                  version: '0.0.4+9',
                ),
                _VersionItem(
                  type: VersionItemType.fix,
                  content: '修复 TolyUiApp.router 问题',
                  version: '0.0.4+8',
                ),
                _VersionItem(
                  type: VersionItemType.update,
                  content: 'tolyui_color 升级至 0.0.2',
                  version: '0.0.4+7',
                ),
                _VersionItem(
                  type: VersionItemType.update,
                  content: 'tolyui_navigation 升级至 0.1.0+4',
                  version: '0.0.4+7',
                ),
                _VersionItem(
                  type: VersionItemType.update,
                  content: 'tolyui_navigation 升级至 0.1.0+3',
                  version: '0.0.4+5',
                ),
                _VersionItem(
                  type: VersionItemType.feature,
                  content: '新增数据展示组件',
                  version: '0.0.4+1',
                ),
                _VersionItem(
                  type: VersionItemType.update,
                  content: '支持 Flutter SDK 3.24.x -> 3.27.3',
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildVersion(
              version: '0.0.3',
              date: '2023-12',
              items: [
                _VersionItem(
                  type: VersionItemType.update,
                  content: 'tolyui_feedback 升级至 0.3.5+1',
                  version: '0.0.3+5',
                ),
                _VersionItem(
                  type: VersionItemType.update,
                  content: 'tolyui_feedback 升级至 0.3.5',
                  version: '0.0.3+4',
                ),
                _VersionItem(
                  type: VersionItemType.feature,
                  content: '新增 TolyAutocomplete 自动补全组件',
                  version: '0.0.3+1',
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildVersion(
              version: '0.0.2',
              date: '2023-11',
              items: [
                _VersionItem(
                  type: VersionItemType.feature,
                  content: '新增 tolyui_feedback 反馈组件包',
                ),
                _VersionItem(
                  type: VersionItemType.feature,
                  content: '新增 tolyui_message 消息组件包',
                ),
                _VersionItem(
                  type: VersionItemType.feature,
                  content: '新增 TolyCollapse 折叠面板组件',
                  version: '0.0.2+20',
                ),
                _VersionItem(
                  type: VersionItemType.update,
                  content: 'tolyui_navigation 升级至 0.0.8+10',
                  version: '0.0.2+21',
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildVersion(
              version: '0.0.1',
              date: '2023-10',
              items: [
                _VersionItem(
                  type: VersionItemType.feature,
                  content: '新增 TolyLink 链接组件',
                ),
                _VersionItem(
                  type: VersionItemType.feature,
                  content: '首个版本发布',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersion({
    required String version,
    required String date,
    required List<_VersionItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue[700],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                version,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              date,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((item) => _buildVersionItem(item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildVersionItem(_VersionItem item) {
    Color color;
    IconData icon;
    String label;

    switch (item.type) {
      case VersionItemType.feature:
        color = Colors.green;
        icon = Icons.add_circle;
        label = '新增';
        break;
      case VersionItemType.update:
        color = Colors.blue;
        icon = Icons.upgrade;
        label = '更新';
        break;
      case VersionItemType.fix:
        color = Colors.orange;
        icon = Icons.build;
        label = '修复';
        break;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    height: 1.5,
                  ),
                ),
                if (item.version != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      item.version!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
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

enum VersionItemType {
  feature,
  update,
  fix,
}

class _VersionItem {
  final VersionItemType type;
  final String content;
  final String? version;

  _VersionItem({
    required this.type,
    required this.content,
    this.version,
  });
}
