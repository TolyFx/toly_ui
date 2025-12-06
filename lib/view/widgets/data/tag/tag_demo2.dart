import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/data/data.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '可关闭标签',
  desc: '带有关闭按钮的标签，支持动态删除和图标装饰。适用于标签管理、筛选条件、关键词编辑等交互场景，提供直观的删除操作。',
)
class TagDemo2 extends StatefulWidget {
  const TagDemo2({super.key});

  @override
  State<TagDemo2> createState() => _TagDemo2State();
}

class _TagDemo2State extends State<TagDemo2> {

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Tag(
          variant: TagVariant.outlined,
          closable: true,
          onClose: () => print('标签已关闭'),
          child: const Text('编程技术'),
        ),
        Tag(
          closable: true,
          icon: const Icon(
            Icons.camera,
            size: 14,
            color: Colors.black,
          ),
          color: Colors.green,
          child: const Text(
            '拍摄影像',
          ),
        ),
        Tag(
          variant: TagVariant.filled,
          disabled: true,
          closable: true,
          child: const Text('禁用状态'),
        ),
      ],
    );
  }
}
