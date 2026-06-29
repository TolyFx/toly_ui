import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../guide_section_page.dart';

class StartUsePage extends StatelessWidget {
  const StartUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GuideSectionPage(
      title: '开始使用',
      subtitle: '快速将 TolyUI 集成到你的 Flutter 项目中',
      sections: [
        GuideSection(
          title: '安装',
          builder: (_) => const _InstallSection(),
        ),
        GuideSection(
          title: '引入',
          builder: (_) => const _ImportSection(),
        ),
        GuideSection(
          title: '示例',
          builder: (_) => const _ExampleSection(),
        ),
        GuideSection(
          title: '特性',
          builder: (_) => const _FeaturesSection(),
        ),
        GuideSection(
          title: '项目地址',
          builder: (_) => const _LinksSection(),
        ),
      ],
    );
  }
}

// ─── 安装 ──────────────────────────────────────────────

class _InstallSection extends StatelessWidget {
  const _InstallSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHint(text: '在 pubspec.yaml 中添加依赖：'),
        const SizedBox(height: 12),
        const _CodeBlock(code: 'dependencies:\n  toly_ui: ^latest_version'),
        const SizedBox(height: 20),
        _SectionHint(text: '然后执行以下命令安装：'),
        const SizedBox(height: 12),
        const _CodeBlock(code: 'flutter pub get'),
      ],
    );
  }
}

// ─── 引入 ──────────────────────────────────────────────

class _ImportSection extends StatelessWidget {
  const _ImportSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHint(text: '在使用组件的 Dart 文件中导入：'),
        const SizedBox(height: 12),
        const _CodeBlock(code: "import 'package:toly_ui/toly_ui.dart';"),
      ],
    );
  }
}

// ─── 示例 ──────────────────────────────────────────────

class _ExampleSection extends StatelessWidget {
  const _ExampleSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHint(text: '以 TolyButton 为例，几行代码即可使用：'),
        const SizedBox(height: 12),
        const _CodeBlock(
          code: 'TolyButton(\n'
              '  onPressed: () {},\n'
              '  child: const Text(\'点击按钮\'),\n'
              ')',
        ),
      ],
    );
  }
}

// ─── 特性 ──────────────────────────────────────────────

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  static final _items = [
    _Feat(Icons.widgets, [Color(0xFF667EEA), Color(0xFF764BA2)], '丰富组件',
        '涵盖基础、表单、数据、导航、反馈五大类，满足各种业务场景'),
    _Feat(Icons.palette, [Color(0xFFF093FB), Color(0xFFF5576C)], '主题定制',
        '灵活的全局主题配置，支持深色模式与品牌色一键切换'),
    _Feat(Icons.bolt, [Color(0xFF4FACFE), Color(0xFF00F2FE)], '开箱即用',
        '简洁的 API 设计，合理的默认值，大幅降低上手成本'),
    _Feat(Icons.devices, [Color(0xFF43E97B), Color(0xFF38F9D7)], '全平台覆盖',
        '基于 Flutter 构建，一套代码同时支持 iOS、Android、Web 和桌面端'),
    _Feat(Icons.architecture, [Color(0xFFFA709A), Color(0xFFFEE140)], '模块化架构',
        '各组件独立分包，按需引入，避免冗余依赖'),
    _Feat(Icons.support, [Color(0xFFA18CD1), Color(0xFFFBC2EB)], '持续维护',
        '活跃的社区支持与定期更新，紧跟 Flutter 最新版本'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = (constraints.maxWidth / 240).floor().clamp(2, 6);
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _items.map((item) {
            final cardWidth =
                (constraints.maxWidth - (crossAxisCount - 1) * 12) /
                    crossAxisCount;
            return SizedBox(
              width: cardWidth,
              child: _FeatureCard(
                icon: item.icon,
                gradient: item.gradient,
                title: item.title,
                desc: item.desc,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final List<Color> gradient;
  final String title;
  final String desc;

  const _FeatureCard({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.desc,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered ? const Color(0xFFDDDDDD) : const Color(0xFFEEEEEE),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_hovered ? 0.08 : 0.04),
              blurRadius: _hovered ? 16 : 12,
              offset: Offset(0, _hovered ? 4.0 : 2.0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: widget.gradient),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.icon, size: 22, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.desc,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF888888),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── 项目地址 ──────────────────────────────────────────

class _LinksSection extends StatelessWidget {
  const _LinksSection();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: const [
        _LinkCard(
          icon: Icons.public,
          color: Color(0xFF667EEA),
          label: '在线展示',
          url: 'http://toly1994.com/ui',
        ),
        _LinkCard(
          icon: Icons.code,
          color: Color(0xFF333333),
          label: 'GitHub 仓库',
          url: 'https://github.com/TolyFx/toly_ui',
        ),
        _LinkCard(
          icon: Icons.library_books,
          color: Color(0xFF0284C7),
          label: 'Pub.dev',
          url: 'https://pub.dev/packages/tolyui',
        ),
      ],
    );
  }
}

class _LinkCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String url;

  const _LinkCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _launchUrl(url),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFEEEEEE)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                url,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── 共用组件 ──────────────────────────────────────────

class _SectionHint extends StatelessWidget {
  final String text;
  const _SectionHint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: Color(0xFF555555), height: 1.6),
        ),
      ],
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String code;
  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          SelectableText(
            code,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              color: Color(0xFFD4D4D4),
              height: 1.7,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _CopyBtn(code: code),
          ),
        ],
      ),
    );
  }
}

class _CopyBtn extends StatelessWidget {
  final String code;
  const _CopyBtn({required this.code});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          Clipboard.setData(ClipboardData(text: code));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('已复制到剪贴板'),
              duration: Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              width: 180,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.copy, size: 14, color: Colors.white54),
              SizedBox(width: 4),
              Text('复制', style: TextStyle(fontSize: 12, color: Colors.white54)),
            ],
          ),
        ),
      ),
    );
  }
}

void _launchUrl(String urlString) async {
  final Uri url = Uri.parse(urlString);
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    debugPrint('Could not launch $urlString');
  }
}

class _Feat {
  final IconData icon;
  final List<Color> gradient;
  final String title;
  final String desc;
  const _Feat(this.icon, this.gradient, this.title, this.desc);
}
