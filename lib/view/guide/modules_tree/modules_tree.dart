import 'package:flutter/material.dart';

class ModulesTreePage extends StatelessWidget {
  const ModulesTreePage({super.key});

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
              '模块树',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'TolyUI 的模块化组织结构',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 48),
            _buildModuleSection(
              title: 'Basic 基础组件',
              icon: Icons.widgets,
              color: Colors.blue,
              modules: [
                '• Action - 动作组件',
                '• Button - 按钮',
                '• Icon - 图标',
                '• Layout - 布局',
                '• Link - 链接',
                '• Text - 文本',
              ],
            ),
            const SizedBox(height: 32),
            _buildModuleSection(
              title: 'Form 表单组件',
              icon: Icons.edit_note,
              color: Colors.green,
              modules: [
                '• Autocomplete - 自动补全',
                '• Checkbox - 多选框',
                '• DatePicker - 日期选择器',
                '• Input - 输入框',
                '• Radio - 单选按钮',
                '• Select - 选择器',
                '• Slider - 滑块',
                '• Switch - 开关',
                '• Transfer - 穿梭框',
              ],
            ),
            const SizedBox(height: 32),
            _buildModuleSection(
              title: 'Data 数据展示',
              icon: Icons.table_chart,
              color: Colors.orange,
              modules: [
                '• Avatar - 头像',
                '• Badge - 标记',
                '• Card - 卡片',
                '• Collapse - 折叠面板',
                '• Image - 图片',
                '• Pagination - 分页',
                '• Progress - 进度条',
                '• Segmented - 分段控制器',
                '• Slideshow - 走马灯',
                '• Statistics - 数据统计',
                '• Tag - 标签',
              ],
            ),
            const SizedBox(height: 32),
            _buildModuleSection(
              title: 'Navigation 导航',
              icon: Icons.navigation,
              color: Colors.purple,
              modules: [
                '• Breadcrumb - 面包屑',
                '• DropMenu - 下拉菜单',
                '• RailMenuBar - 侧栏菜单',
                '• RailMenuTree - 树形菜单',
                '• Stepper - 步骤条',
                '• Tabs - 标签页',
              ],
            ),
            const SizedBox(height: 32),
            _buildModuleSection(
              title: 'Feedback 反馈组件',
              icon: Icons.feedback,
              color: Colors.red,
              modules: [
                '• Loading - 加载',
                '• Message - 消息提示',
                '• Notification - 通知',
                '• Popover - 弹出框',
                '• Shortcuts - 快捷键',
                '• Tooltip - 文字提示',
              ],
            ),
            const SizedBox(height: 32),
            _buildModuleSection(
              title: 'Advance 高级组件',
              icon: Icons.extension,
              color: Colors.teal,
              modules: [
                '• Color - 颜色工具',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> modules,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...modules.map((module) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  module,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
