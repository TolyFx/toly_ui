import 'package:flutter/material.dart';

class PrinciplePage extends StatelessWidget {
  const PrinciplePage({super.key});

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
              '设计原则',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'TolyUI 的设计理念和核心原则',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 48),
            _buildPrinciple(
              icon: Icons.straighten,
              title: '简洁易用',
              color: Colors.blue,
              description:
                  'TolyUI 秉持简洁的设计理念，提供清晰的 API 和直观的使用方式。每个组件都经过精心设计，确保开发者能够快速上手，无需复杂的配置即可实现常用功能。',
              points: [
                '清晰的命名规范，见名知意',
                '简单的属性配置，开箱即用',
                '完善的默认值，减少必填参数',
              ],
            ),
            const SizedBox(height: 32),
            _buildPrinciple(
              icon: Icons.palette,
              title: '灵活定制',
              color: Colors.purple,
              description:
                  '在保持简洁的同时，TolyUI 提供了丰富的定制能力。开发者可以通过主题配置、样式覆盖等方式，轻松打造符合自己品牌特色的界面。',
              points: [
                '支持主题定制，统一视觉风格',
                '灵活的样式覆盖，满足个性化需求',
                '丰富的配置选项，适应多种场景',
              ],
            ),
            const SizedBox(height: 32),
            _buildPrinciple(
              icon: Icons.speed,
              title: '性能优先',
              color: Colors.orange,
              description:
                  'TolyUI 注重组件的性能表现，采用高效的渲染策略和优化算法。在保证功能完善的前提下，最大化减少资源消耗，提供流畅的用户体验。',
              points: [
                '高效的组件渲染，减少重绘',
                '合理的状态管理，避免不必要的更新',
                '懒加载和虚拟化，优化大数据场景',
              ],
            ),
            const SizedBox(height: 32),
            _buildPrinciple(
              icon: Icons.accessibility_new,
              title: '无障碍访问',
              color: Colors.green,
              description:
                  'TolyUI 遵循无障碍设计规范，确保所有用户都能顺畅使用。组件支持键盘导航、屏幕阅读器等辅助功能，让应用更加包容。',
              points: [
                '支持键盘导航，提升操作效率',
                '语义化标签，兼容屏幕阅读器',
                '清晰的视觉反馈，降低使用门槛',
              ],
            ),
            const SizedBox(height: 32),
            _buildPrinciple(
              icon: Icons.devices,
              title: '跨平台兼容',
              color: Colors.teal,
              description:
                  'TolyUI 基于 Flutter 构建，天然具备跨平台特性。组件在 iOS、Android、Web、桌面端等平台上都能保持一致的表现，让开发者一次编写，处处运行。',
              points: [
                '完美支持 iOS、Android、Web 等平台',
                '自适应布局，适配不同屏幕尺寸',
                '平台特性兼容，提供原生体验',
              ],
            ),
            const SizedBox(height: 32),
            _buildPrinciple(
              icon: Icons.auto_awesome,
              title: '渐进增强',
              color: Colors.red,
              description:
                  'TolyUI 采用渐进增强的设计理念，组件功能从简单到复杂分层设计。开发者可以根据需求逐步引入高级功能，避免一开始就面对复杂的配置。',
              points: [
                '基础功能开箱即用，零配置起步',
                '高级特性可选引入，按需使用',
                '清晰的功能分层，降低学习成本',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrinciple({
    required IconData icon,
    required String title,
    required Color color,
    required String description,
    required List<String> points,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          ...points.map((point) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 8, right: 8),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        point,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          height: 1.6,
                        ),
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
