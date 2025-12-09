import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';


@DisplayNode(
  title: '可选择标签',
  desc: '展示 TolyTagGroup 组件的单选和多选功能。单选模式下，点击标签会取消其他标签的选中状态，只保留当前选中项；多选模式下，可以同时选中多个标签。每个模式都实时显示当前选中的内容，提供直观的视觉反馈。示例中单选用于技术方向选择（前端、后端、移动端、人工智能），多选用于技术栈选择（Flutter、React、Vue 等）。这种交互模式广泛应用于筛选器、分类选择、问卷调查、偏好设置等需要用户选择的场景。',
)
class TagDemo4 extends StatefulWidget {
  const TagDemo4({super.key});

  @override
  State<TagDemo4> createState() => _TagDemo4State();
}

class _TagDemo4State extends State<TagDemo4> {
  String? selectedCategory;
  List<String> selectedTags = [];

  @override
  Widget build(BuildContext context) {
    const TextStyle style = TextStyle(fontSize: 14,fontWeight: FontWeight.bold);
    const TextStyle greyStyle = TextStyle(fontSize: 12,color: Colors.grey);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            const Text('单选模式：',style: style),
            const SizedBox(height: 8),
            Text('已选择：${selectedCategory ?? "无"}',style: greyStyle),
          ],
        ),
        const SizedBox(height: 8),
        TolyTagGroup<String>(
          options: const [
            TagOption(value: 'frontend', label: Text('前端')),
            TagOption(value: 'backend', label: Text('后端')),
            TagOption(value: 'mobile', label: Text('移动端')),
            TagOption(value: 'ai', label: Text('人工智能')),
          ],
          value: selectedCategory,
          onChange: (value) => setState(() => selectedCategory = value),
        ),

        const SizedBox(height: 24),
        Wrap(
          children: [
            const Text('多选模式：',style: style),
            const SizedBox(height: 8),
            Text('已选择：${selectedTags.isEmpty ? "无" : selectedTags.join(", ")}',style: greyStyle),

          ],
        ),

        const SizedBox(height: 8),
        TolyTagGroup<String>(
          multiple: true,
          options: const [
            TagOption(value: 'flutter', label: Text('Flutter')),
            TagOption(value: 'react', label: Text('React')),
            TagOption(value: 'vue', label: Text('Vue')),
            TagOption(value: 'angular', label: Text('Angular')),
            TagOption(value: 'nodejs', label: Text('Node.js')),
          ],
          values: selectedTags,
          onChangeMultiple: (values) => setState(() => selectedTags = values),
        ),
      ],
    );
  }
}
