import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:toly_default/toly_default.dart';

@DisplayNode(
  title: '预设类型',
  desc: '展示内置的缺省页类型。通过 type 属性快速使用预设的图标、标题和描述，包括空数据、搜索无结果、网络错误、无权限、404 和服务器错误六种常见场景。',
)
class DefaultDemo5 extends StatelessWidget {
  const DefaultDemo5({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        _buildCard(DefaultType.empty),
        _buildCard(DefaultType.noResult),
        _buildCard(DefaultType.networkError),
        _buildCard(DefaultType.noPermission),
        _buildCard(DefaultType.notFound),
        _buildCard(DefaultType.serverError),
      ],
    );
  }

  Widget _buildCard(DefaultType type) {
    return Container(
      width: 200,
      height: 240,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TolyDefault(
        type: type,
        imageSize: 64,
        spacing: 12,
      ),
    );
  }
}
