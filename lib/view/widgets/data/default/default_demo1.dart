import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui_default/tolyui_default.dart';
import 'package:tolyui/res/tolyui_icon.dart';

@DisplayNode(
  title: '基础缺省页',
  desc: '展示缺省页的基础用法。通过图标、标题和描述的组合，向用户清晰传达当前的空状态信息。适用于数据为空、搜索无结果等常见场景。',
)
class DefaultDemo1 extends StatelessWidget {
  const DefaultDemo1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const TolyDefault(
        image: Icon(TolyuiIcon.empty_data, size: 80, color: Colors.grey),
        title: '暂无数据',
        description: '当前列表为空，请添加新的内容',
      ),
    );
  }
}
