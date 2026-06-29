import 'package:flutter/material.dart';

import '../guide_section_page.dart';

class UpdateLogPage extends StatelessWidget {
  const UpdateLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GuideSectionPage(
      title: '更新日志',
      subtitle: '每个版本的变更细节，方便评估升级影响',
      sections: [
        GuideSection(title: 'v0.0.4 (当前)', builder: (context) => const _V0004()),
        GuideSection(title: 'v0.0.3', builder: (context) => const _V0003()),
        GuideSection(title: 'v0.0.2', builder: (context) => const _V0002()),
        GuideSection(title: 'v0.0.1', builder: (context) => const _V0001()),
      ],
    );
  }
}

// ─── 通用版本卡片 ──────────────────────────────────────

class _VersionCard extends StatelessWidget {
  final String version;
  final String date;
  final String summary;
  final List<_LogItem> items;

  const _VersionCard({
    required this.version,
    required this.date,
    required this.summary,
    required this.items,
  });

  int get _featureCount => items.where((i) => i.type == LogType.feature).length;
  int get _updateCount => items.where((i) => i.type == LogType.update).length;
  int get _fixCount => items.where((i) => i.type == LogType.fix).length;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 头部
          _Header(
            version: version,
            date: date,
            summary: summary,
            primary: primary,
            features: _featureCount,
            updates: _updateCount,
            fixes: _fixCount,
          ),
          // 条目列表
          if (items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items.map((item) => _LogItemRow(item: item)).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── 卡片头部 ──────────────────────────────────────────

class _Header extends StatelessWidget {
  final String version;
  final String date;
  final String summary;
  final Color primary;
  final int features;
  final int updates;
  final int fixes;

  const _Header({
    required this.version,
    required this.date,
    required this.summary,
    required this.primary,
    required this.features,
    required this.updates,
    required this.fixes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.04), const Color(0xFFF8FAFC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: const Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 第一行：版本号 + 日期 + 统计
          Row(
            children: [
              // 版本标签
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  version,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // 日期
              Icon(Icons.calendar_today, size: 13, color: Colors.grey[400]),
              const SizedBox(width: 5),
              Text(
                date,
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
              ),
              const Spacer(),
              // 统计徽章
              if (features > 0) _StatBadge(icon: Icons.auto_awesome, label: '$features', color: const Color(0xFF10B981)),
              if (updates > 0) const SizedBox(width: 6),
              if (updates > 0) _StatBadge(icon: Icons.sync, label: '$updates', color: const Color(0xFF4F6EF7)),
              if (fixes > 0) const SizedBox(width: 6),
              if (fixes > 0) _StatBadge(icon: Icons.bug_report, label: '$fixes', color: const Color(0xFFF59E0B)),
            ],
          ),
          const SizedBox(height: 12),
          // 摘要
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(Icons.lightbulb_outline, size: 15, color: primary.withOpacity(0.6)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  summary,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _StatBadge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color, fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }
}

// ─── 变更条目行 ─────────────────────────────────────────

class _LogItemRow extends StatelessWidget {
  final _LogItem item;
  const _LogItemRow({required this.item});

  static const _typeMeta = {
    LogType.feature: _TypeMeta(icon: Icons.add_circle, color: Color(0xFF10B981), bg: Color(0xFFECFDF5), label: '新增'),
    LogType.update: _TypeMeta(icon: Icons.upgrade, color: Color(0xFF4F6EF7), bg: Color(0xFFEEF2FF), label: '升级'),
    LogType.fix: _TypeMeta(icon: Icons.build, color: Color(0xFFF59E0B), bg: Color(0xFFFFFBEB), label: '修复'),
  };

  @override
  Widget build(BuildContext context) {
    final meta = _typeMeta[item.type]!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 类型图标
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: meta.bg,
              borderRadius: BorderRadius.circular(6),
            ),
            alignment: Alignment.center,
            child: Icon(meta.icon, size: 14, color: meta.color),
          ),
          const SizedBox(width: 10),
          // 内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // 类型标签
                    Text(
                      meta.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: meta.color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 内容文本
                    Expanded(
                      child: Text(
                        item.content,
                        style: const TextStyle(fontSize: 13, color: Color(0xFF444444), height: 1.5),
                      ),
                    ),
                  ],
                ),
                if (item.version != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      item.version!,
                      style: TextStyle(fontSize: 11, color: Colors.grey[400], fontFamily: 'monospace'),
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

// ─── 数据模型 ──────────────────────────────────────────

enum LogType { feature, update, fix }

class _TypeMeta {
  final IconData icon;
  final Color color;
  final Color bg;
  final String label;
  const _TypeMeta({required this.icon, required this.color, required this.bg, required this.label});
}

class _LogItem {
  final LogType type;
  final String content;
  final String? version;
  const _LogItem(this.type, this.content, {this.version});
}

// ═══════════════════════════════════════════════════════
//  版本数据
// ═══════════════════════════════════════════════════════

class _V0004 extends _VersionCard {
  const _V0004()
      : super(
          version: 'v0.0.4',
          date: '2024-01 ～ 至今',
          summary: '大量子包集中上线；导航与反馈模块大幅升级；Flutter SDK 升级至 3.27。当前仍在活跃开发中。',
          items: const [
            _LogItem(LogType.feature, '新增 tolyui_anchor 锚点导航组件'),
            _LogItem(LogType.update, 'tolyui_feedback 升级至 0.3.6'),
            _LogItem(LogType.update, 'tolyui_navigation 升级至 0.2.1'),
            _LogItem(LogType.feature, '新增 tolyui_statistic 统计组件', version: '0.0.4+12'),
            _LogItem(LogType.feature, '新增 tolyui_text 高亮文本组件', version: '0.0.4+11'),
            _LogItem(LogType.update, 'tolyui_navigation 升级至 0.2.0', version: '0.0.4+9'),
            _LogItem(LogType.fix, '修复 TolyUiApp.router 路由问题', version: '0.0.4+8'),
            _LogItem(LogType.update, 'tolyui_color 升级至 0.0.2', version: '0.0.4+7'),
            _LogItem(LogType.feature, '新增数据展示组件集（carousel / tree / table / timeline / watermark）', version: '0.0.4+1'),
            _LogItem(LogType.update, 'Flutter SDK 3.24.x → 3.27.3'),
          ],
        );
}

class _V0003 extends _VersionCard {
  const _V0003()
      : super(
          version: 'v0.0.3',
          date: '2023-12',
          summary: '反馈组件持续迭代，新增 TolyAutocomplete 自动补全组件。',
          items: const [
            _LogItem(LogType.update, 'tolyui_feedback 升级至 0.3.5+1', version: '0.0.3+5'),
            _LogItem(LogType.update, 'tolyui_feedback 升级至 0.3.5', version: '0.0.3+4'),
            _LogItem(LogType.feature, '新增 TolyAutocomplete 自动补全组件', version: '0.0.3+1'),
          ],
        );
}

class _V0002 extends _VersionCard {
  const _V0002()
      : super(
          version: 'v0.0.2',
          date: '2023-11',
          summary: 'feedback / message 两个反馈包正式上线；折叠面板加入数据展示阵营。',
          items: const [
            _LogItem(LogType.feature, '新增 tolyui_feedback 反馈组件包（Popover / Tooltip）'),
            _LogItem(LogType.feature, '新增 tolyui_message 全局消息组件包'),
            _LogItem(LogType.feature, '新增 TolyCollapse 折叠面板组件', version: '0.0.2+20'),
            _LogItem(LogType.update, 'tolyui_navigation 升级至 0.0.8+10', version: '0.0.2+21'),
          ],
        );
}

class _V0001 extends _VersionCard {
  const _V0001()
      : super(
          version: 'v0.0.1',
          date: '2023-10',
          summary: 'TolyUI 的第一个正式版本，从 0 到 1 的第一步。确立了 monorepo 多包架构。',
          items: const [
            _LogItem(LogType.feature, '首个版本发布，建立 modules/ 多包 monorepo 架构'),
            _LogItem(LogType.feature, 'TolyLink 链接组件上线'),
            _LogItem(LogType.feature, '按钮、输入框、选择器等基础表单组件'),
          ],
        );
}
