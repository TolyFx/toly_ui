import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_anchor/tolyui_anchor.dart';

@DisplayNode(
  title: '设置面板样式',
  desc: '类似飞书桌面端的设置面板，左侧分组导航，右侧对应设置内容区域。',
)
class AnchorDemo2 extends StatefulWidget {
  const AnchorDemo2({super.key});

  @override
  State<AnchorDemo2> createState() => _AnchorDemo2State();
}

class _AnchorDemo2State extends State<AnchorDemo2> {
  final TolyAnchorController _controller = TolyAnchorController();

  final List<_SettingGroup> _groups = const [
    _SettingGroup(
      title: '通用',
      icon: Icons.settings_outlined,
      items: [
        _SettingItem(
          title: '外观',
          description: '自定义应用的主题颜色、字体大小、界面密度等视觉选项。支持浅色/深色模式切换，可跟随系统设置自动调整。',
          color: Color(0xFFE3F2FD),
        ),
        _SettingItem(
          title: '通知',
          description: '管理桌面通知、消息提醒声音和震动反馈。可设置免打扰时段。',
          color: Color(0xFFFFF3E0),
        ),
        _SettingItem(
          title: '语言',
          description: '选择界面显示语言，支持简体中文、English、繁體中文等多种语言。',
          color: Color(0xFFE8F5E9),
        ),
      ],
    ),
    _SettingGroup(
      title: '账号',
      icon: Icons.person_outline,
      items: [
        _SettingItem(
          title: '个人信息',
          description: '编辑你的头像、昵称、职位、部门等个人资料信息。这些信息将展示在团队通讯录中。',
          color: Color(0xFFF3E5F5),
        ),
        _SettingItem(
          title: '安全设置',
          description: '设置登录密码、绑定手机号、开启两步验证。建议定期更换密码以保护账号安全。',
          color: Color(0xFFECEFF1),
        ),
        _SettingItem(
          title: '隐私',
          description: '控制谁可以看到你的在线状态、已读回执、最后活跃时间。',
          color: Color(0xFFE0F7FA),
        ),
      ],
    ),
    _SettingGroup(
      title: '聊天',
      icon: Icons.chat_bubble_outline,
      items: [
        _SettingItem(
          title: '消息通知',
          description: '设置新消息的提醒方式，包括桌面通知、声音提示、任务栏闪烁等。可以为不同的会话设置不同的通知优先级。',
          color: Color(0xFFFFEBEE),
        ),
        _SettingItem(
          title: '聊天设置',
          description: '消息字体大小、气泡样式、Enter 键发送行为设置。',
          color: Color(0xFFF1F8E9),
        ),
      ],
    ),
    _SettingGroup(
      title: '快捷键',
      icon: Icons.keyboard_outlined,
      items: [
        _SettingItem(
          title: '全局快捷键',
          description: '设置全局快捷键，即使应用在后台也能快速响应。例如：快速创建任务、截屏、打开搜索等。',
          color: Color(0xFFFBE9E7),
        ),
        _SettingItem(
          title: '聊天快捷键',
          description: '聊天窗口内的快捷操作设置。',
          color: Color(0xFFEDE7F6),
        ),
      ],
    ),
    _SettingGroup(
      title: '关于',
      icon: Icons.info_outline,
      items: [
        _SettingItem(
          title: '版本信息',
          description: '当前版本 v5.20.3，已是最新版本。',
          color: Color(0xFFE1F5FE),
        ),
        _SettingItem(
          title: '更新日志',
          description: '查看历史版本的更新内容和功能改进记录。了解每次更新带来的新特性和问题修复。',
          color: Color(0xFFF9FBE7),
        ),
        _SettingItem(
          title: '开源许可',
          description: '本项目使用了以下开源组件：Flutter SDK、scrollable_positioned_list、provider 等。',
          color: Color(0xFFFCE4EC),
        ),
      ],
    ),
  ];

  late final List<TolyAnchorLink> _links;

  @override
  void initState() {
    super.initState();
    _links = _groups.map((g) => TolyAnchorLink(title: g.title, href: g.title)).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧分组导航
          SizedBox(
            width: 200,
            child: TolyAnchor(
              controller: _controller,
              links: _links,
              linkBuilder: _buildGroupLink,
            ),
          ),
          const VerticalDivider(),
          // 右侧设置内容区域
          Expanded(
            child: TolyAnchorScrollable(
              controller: _controller,
              itemCount: _groups.length,
              itemBuilder: (context, index) => _buildGroupSection(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupLink(BuildContext context, TolyAnchorLink link, bool active) {
    final group = _groups.firstWhere((g) => g.title == link.title);
    final index = _groups.indexOf(group);

    return InkWell(
      onTap: () => _controller.scrollToIndex(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: active ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.08) : null,
          border: Border(
            left: BorderSide(
              color: active ? Theme.of(context).colorScheme.primary : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              group.icon,
              size: 20,
              color: active ? Theme.of(context).colorScheme.primary : Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Text(
              group.title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                color: active ? Theme.of(context).colorScheme.primary : Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupSection(int index) {
    final group = _groups[index];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 分组标题
          Row(
            children: [
              Icon(group.icon, size: 24, color: Colors.grey.shade700),
              const SizedBox(width: 12),
              Text(
                group.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // 设置项列表
          ...group.items.map((item) => _buildSettingItem(item)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSettingItem(_SettingItem item) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingGroup {
  final String title;
  final IconData icon;
  final List<_SettingItem> items;

  const _SettingGroup({
    required this.title,
    required this.icon,
    required this.items,
  });
}

class _SettingItem {
  final String title;
  final String description;
  final Color color;

  const _SettingItem({
    required this.title,
    required this.description,
    required this.color,
  });
}
