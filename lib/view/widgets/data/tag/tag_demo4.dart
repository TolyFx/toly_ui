import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';


@DisplayNode(
  title: '可选择标签',
  desc: '支持单选和多选的标签组，适用于筛选器、分类选择、标签管理等场景。支持状态管理和回调处理，提供直观的选择反馈。',
)
class TagDemo4 extends StatefulWidget {
  const TagDemo4({super.key});

  @override
  State<TagDemo4> createState() => _TagDemo3State();
}

class _TagDemo3State extends State<TagDemo4> {
  String? selectedCategory;
  List<String> selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('单选模式：'),
        const SizedBox(height: 8),
        CheckableTagGroup<String>(
          options: const [
            CheckableTagOption(value: 'frontend', label: Text('前端')),
            CheckableTagOption(value: 'backend', label: Text('后端')),
            CheckableTagOption(value: 'mobile', label: Text('移动端')),
            CheckableTagOption(value: 'ai', label: Text('人工智能')),
          ],
          value: selectedCategory,
          onChange: (value) => setState(() => selectedCategory = value),
        ),
        const SizedBox(height: 8),
        Text('已选择：${selectedCategory ?? "无"}'),
        const SizedBox(height: 24),
        const Text('多选模式：'),
        const SizedBox(height: 8),
        CheckableTagGroup<String>(
          multiple: true,
          options: const [
            CheckableTagOption(value: 'flutter', label: Text('Flutter')),
            CheckableTagOption(value: 'react', label: Text('React')),
            CheckableTagOption(value: 'vue', label: Text('Vue')),
            CheckableTagOption(value: 'angular', label: Text('Angular')),
            CheckableTagOption(value: 'nodejs', label: Text('Node.js')),
          ],
          values: selectedTags,
          onChangeMultiple: (values) => setState(() => selectedTags = values),
        ),
        const SizedBox(height: 8),
        Text('已选择：${selectedTags.isEmpty ? "无" : selectedTags.join(", ")}'),
      ],
    );
  }
}
