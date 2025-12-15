import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_default/tolyui_default.dart';

@DisplayNode(
  title: '不同场景的缺省页',
  desc: '展示不同业务场景下的缺省页样式。通过不同的图标和文案组合，可以适配搜索无结果、网络异常、无权限等多种场景，让用户快速理解当前状态。',
)
class DefaultDemo2 extends StatelessWidget {
  const DefaultDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 24,
      children: [
        _buildDefaultCard(
          icon: Icons.search_off,
          title: '未找到相关内容',
          description: '请尝试使用其他关键词搜索',
        ),
        _buildDefaultCard(
          icon: Icons.cloud_off_outlined,
          title: '网络连接失败',
          description: '请检查网络设置后重试',
        ),
        _buildDefaultCard(
          icon: Icons.lock_outline,
          title: '暂无访问权限',
          description: '请联系管理员开通权限',
        ),
      ],
    );
  }

  Widget _buildDefaultCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: 220,
      height: 240,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TolyDefault(
        image: Icon(icon, size: 64, color: Colors.grey),
        imageSize: 64,
        title: title,
        description: description,
        spacing: 12,
      ),
    );
  }
}
