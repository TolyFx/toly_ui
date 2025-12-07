import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/data/data.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '可关闭标签',
  desc: '展示基于数据驱动的动态标签管理。每个标签都可以独立关闭删除，点击关闭按钮后标签从列表中移除并显示提示信息。当有标签被删除时，右侧会出现重置标签，点击可恢复所有已删除的标签。示例包含了不同样式、颜色、图标的标签组合，以及禁用状态的展示，适用于标签管理、筛选条件、关键词编辑等需要动态增删的交互场景。',
)
class TagDemo2 extends StatefulWidget {
  const TagDemo2({super.key});

  @override
  State<TagDemo2> createState() => _TagDemo2State();
}

class _TagDemo2State extends State<TagDemo2> {
  final List<TagData> _initialTags = [
    TagData(
      label: '编程技术',
      variant: TagVariant.outlined,
    ),
    TagData(
      label: '拍摄影像',
      icon: Icons.camera,
      color: Colors.green,
    ),
    TagData(
      label: 'Dart语言',
      icon: Icons.code,
      variant: TagVariant.outlined,
    ),
    TagData(
      label: '禁用状态',
      variant: TagVariant.filled,
      disabled: true,
    ),
  ];

  late List<TagData> tags;

  @override
  void initState() {
    super.initState();
    tags = List.from(_initialTags);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...tags.map((tag) {
          return TolyTag(
            variant: tag.variant,
            closable: true,
            disabled: tag.disabled,
            color: tag.color,
            icon: tag.icon != null
                ? Icon(
                    tag.icon,
                    size: 14,
                    color: tag.color != null ? Colors.black : null,
                  )
                : null,
            onClose: () {
              setState(() {
                tags.remove(tag);
              });
              $message.success(message: '已删除: ${tag.label}');
            },
            child: Text(tag.label),
          );
        }),
        if (tags.length < _initialTags.length)
          GestureDetector(
            onTap: () {
              setState(() {
                tags = List.from(_initialTags);
              });
              $message.success(message: '已重置所有标签');
            },
            child: TolyTag(
              variant: TagVariant.filled,
              color: Colors.blue,
              icon: Icon(Icons.refresh, size: 14,color: Colors.blue),
              child: Text('重置'),
            ),
          ),
      ],
    );
  }
}

class TagData {
  final String label;
  final TagVariant variant;
  final IconData? icon;
  final Color? color;
  final bool disabled;

  TagData({
    required this.label,
    this.variant = TagVariant.filled,
    this.icon,
    this.color,
    this.disabled = false,
  });
}
