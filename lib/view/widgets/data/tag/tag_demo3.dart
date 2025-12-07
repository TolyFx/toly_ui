import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/data/data.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '动态添加标签',
  desc: '展示标签的动态增删功能。用户可以通过关闭按钮删除已有标签，也可以点击虚线边框的添加按钮创建新标签。点击添加后会出现输入框，输入内容并回车或失焦即可完成添加。新标签会自动去重和去除空白，确保标签列表的整洁性。这种交互模式常用于个人信息编辑、兴趣标签管理、技能标签设置等需要用户自定义标签内容的场景。',
)
class TagDemo3 extends StatefulWidget {
  const TagDemo3({super.key});

  @override
  State<TagDemo3> createState() => _TagDemo3State();
}

class _TagDemo3State extends State<TagDemo3> {
  List<String> tags = ['上进', '努力', '成功', '创新', '热情'];
  bool _isAdding = false;
  final TextEditingController _tagInputController = TextEditingController();
  final FocusNode _tagInputFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tagInputFocusNode.addListener(() {
      if (!_tagInputFocusNode.hasFocus) {
        // 输入框失去焦点时，提交内容
        _handleSubmitted(_tagInputController.text);
      }
    });
  }

  @override
  void dispose() {
    _tagInputController.dispose();
    _tagInputFocusNode.dispose();
    super.dispose();
  }

  void _handleSubmitted(String value) {
    setState(() {
      final newTag = value.trim();
      if (newTag.isNotEmpty && !tags.contains(newTag)) {
        tags.add(newTag);
      }
      _isAdding = false;
      _tagInputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('你的性格特点：'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...tags.map((tag) {
              return TolyTag(
                theme: TagTheme.tolyui(colorIcon: Colors.blue),
                key: ValueKey(tag),
                closable: true,
                color: Colors.blue,
                onClose: () {
                  setState(() {
                    tags.remove(tag);
                  });
                },
                child: Text(tag),
              );
            }).toList(),
            if (_isAdding)
              SizedBox(
                width: 90,
                height: 24,
                child: TextField(
                  controller: _tagInputController,
                  focusNode: _tagInputFocusNode,
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: _handleSubmitted,
                ),
              )
            else
              TolyTag(
                variant: TagVariant.dashed,
                onTap: () {
                  setState(() {
                    _isAdding = true;
                  });
                  _tagInputFocusNode.requestFocus();
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 14),
                    SizedBox(width: 4),
                    Text('添加标签'),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
