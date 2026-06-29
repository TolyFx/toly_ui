import 'package:flutter/material.dart';

import '../guide_section_page.dart';

class PrinciplePage extends StatelessWidget {
  const PrinciplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GuideSectionPage(
      title: '设计原则',
      subtitle: '贯穿 TolyUI 设计始终的核心价值观',
      sections: [
        GuideSection(
          title: '简洁易用',
          builder: (_) => const _PrincipleCard(
            index: 1,
            color: Color(0xFF4F6EF7),
            description: '清晰直观的 API 命名，合理的默认配置，让开发者用最少的代码达成目标。',
            points: [
              '命名见名知意，降低查阅文档的频率',
              '核心属性提供合理默认值，减少必填参数',
              '常见场景一行代码即可覆盖，复杂场景按需深入',
            ],
          ),
        ),
        GuideSection(
          title: '灵活定制',
          builder: (_) => const _PrincipleCard(
            index: 2,
            color: Color(0xFF8B5CF6),
            description: '提供完善的主题系统与样式覆盖机制，在一致性与个性化之间取得平衡。',
            points: [
              '全局主题配置，一键切换亮色 / 暗色模式',
              '支持组件级样式覆盖，适配品牌视觉规范',
              '开放底层构建块，不限制自定义组合方式',
            ],
          ),
        ),
        GuideSection(
          title: '性能优先',
          builder: (_) => const _PrincipleCard(
            index: 3,
            color: Color(0xFFF59E0B),
            description: '在每个组件设计阶段就考虑性能影响，确保大量使用时依然流畅顺滑。',
            points: [
              '细致的 rebuild 控制，避免无效重绘',
              '长列表场景内建懒加载与虚拟化支持',
              '合理的 const 构造与缓存策略',
            ],
          ),
        ),
        GuideSection(
          title: '模块化',
          builder: (_) => const _PrincipleCard(
            index: 4,
            color: Color(0xFF10B981),
            description: '各组件独立分包，按需引入，保持依赖树清爽，构建体积可控。',
            points: [
              '组件粒度的独立 package，按需添加',
              '核心模块零外部依赖，减少版本冲突',
              '清晰的模块边界，便于团队分工与维护',
            ],
          ),
        ),
        GuideSection(
          title: '跨平台一致',
          builder: (_) => const _PrincipleCard(
            index: 5,
            color: Color(0xFF14B8A6),
            description: '基于 Flutter 的跨平台能力，确保同一套组件在多个平台上表现统一。',
            points: [
              'iOS、Android、Web、桌面端全平台适配',
              '自适应布局，兼顾不同屏幕尺寸',
              '尊重各平台交互习惯的同时保持品牌一致性',
            ],
          ),
        ),
        GuideSection(
          title: '渐进增强',
          builder: (_) => const _PrincipleCard(
            index: 6,
            color: Color(0xFFEF4444),
            description: '基础功能上手即用，高级能力按需开启，学习曲线平滑，不强制一次性掌握全部。',
            points: [
              '零配置即可使用，随着需求深入再探索高级选项',
              '分层设计，每层之间互不干扰',
              '渐进式的风格迁移路径，兼容旧版行为',
            ],
          ),
        ),
      ],
    );
  }
}

class _PrincipleCard extends StatelessWidget {
  final int index;
  final Color color;
  final String description;
  final List<String> points;

  const _PrincipleCard({
    required this.index,
    required this.color,
    required this.description,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$index',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...points.asMap().entries.map((entry) => Padding(
                padding: EdgeInsets.only(bottom: entry.key < points.length - 1 ? 10 : 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 7),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
