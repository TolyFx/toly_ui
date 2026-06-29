import 'package:flutter/material.dart';

import '../guide_section_page.dart';

class ModulesTreePage extends StatelessWidget {
  const ModulesTreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GuideSectionPage(
      title: '模块树',
      subtitle: 'TolyUI 采用模块化架构，组件按功能划分为六大分类',
      sections: [
        GuideSection(
          title: 'Basic 基础',
          builder: (_) => const _CategoryBlock(
            color: Color(0xFF4F6EF7),
            description: '最底层的基础元素，为上层的复杂组件提供统一的行为与外观规范。',
            modules: [
              'Action — 动作回调封装',
              'Button — 按钮组件',
              'Icon — 图标组件',
              'Layout — 布局容器',
              'Link — 链接组件',
              'Text — 文本组件',
            ],
          ),
        ),
        GuideSection(
          title: 'Form 表单',
          builder: (_) => const _CategoryBlock(
            color: Color(0xFF10B981),
            description: '覆盖数据录入全场景，从输入框到日期选择器，提供一致的表单交互体验。',
            modules: [
              'Autocomplete — 自动补全',
              'Checkbox — 多选框',
              'DatePicker — 日期选择器',
              'Input — 输入框',
              'Radio — 单选按钮',
              'Select — 选择器',
              'Slider — 滑块',
              'Switch — 开关',
              'Transfer — 穿梭框',
            ],
          ),
        ),
        GuideSection(
          title: 'Data 数据展示',
          builder: (_) => const _CategoryBlock(
            color: Color(0xFFF59E0B),
            description: '以清晰、美观的方式呈现数据，包含卡片、表格、进度条等多种展示形态。',
            modules: [
              'Avatar — 头像',
              'Badge — 徽标',
              'Card — 卡片',
              'Collapse — 折叠面板',
              'Image — 图片',
              'Pagination — 分页',
              'Progress — 进度条',
              'Segmented — 分段控制器',
              'Slideshow — 走马灯',
              'Statistics — 数据统计',
              'Tag — 标签',
            ],
          ),
        ),
        GuideSection(
          title: 'Navigation 导航',
          builder: (_) => const _CategoryBlock(
            color: Color(0xFF8B5CF6),
            description: '帮助用户在应用内自由穿梭，从侧栏菜单到步骤条，覆盖各种导航场景。',
            modules: [
              'Breadcrumb — 面包屑',
              'DropMenu — 下拉菜单',
              'RailMenuBar — 侧栏菜单',
              'RailMenuTree — 树形菜单',
              'Stepper — 步骤条',
              'Tabs — 标签页',
            ],
          ),
        ),
        GuideSection(
          title: 'Feedback 反馈',
          builder: (_) => const _CategoryBlock(
            color: Color(0xFFEF4444),
            description: '及时响应用户操作，通过消息、通知、弹窗等方式传递状态变化。',
            modules: [
              'Loading — 加载中',
              'Message — 消息提示',
              'Notification — 通知',
              'Popover — 气泡弹出框',
              'Shortcuts — 快捷键',
              'Tooltip — 文字提示',
            ],
          ),
        ),
        GuideSection(
          title: 'Advance 高级',
          builder: (_) => const _CategoryBlock(
            color: Color(0xFF14B8A6),
            description: '提供更深层的工具与能力，如颜色解析、主题引擎等底层支撑模块。',
            modules: [
              'Color — 颜色工具',
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryBlock extends StatelessWidget {
  final Color color;
  final String description;
  final List<String> modules;

  const _CategoryBlock({
    required this.color,
    required this.description,
    required this.modules,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${modules.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: modules.map((m) => _ModuleChip(module: m, color: color)).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModuleChip extends StatelessWidget {
  final String module;
  final Color color;

  const _ModuleChip({required this.module, required this.color});

  @override
  Widget build(BuildContext context) {
    final parts = module.split(' — ');
    final name = parts.isNotEmpty ? parts.first : module;
    final desc = parts.length > 1 ? parts.skip(1).join(' — ') : '';

    return Tooltip(
      message: desc.isNotEmpty ? module : name,
      preferBelow: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Text(
          name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: color.withOpacity(0.85),
          ),
        ),
      ),
    );
  }
}
