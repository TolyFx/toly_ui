import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:toly_default/toly_default.dart';
import 'package:tolyui_message/tolyui_message.dart';

@DisplayNode(
  title: '带操作按钮的缺省页',
  desc: '展示带有操作引导的缺省页。通过添加操作按钮，引导用户采取下一步行动，如重新加载、创建内容或跳转到其他页面，提升用户体验的完整性。',
)
class DefaultDemo3 extends StatelessWidget {
  const DefaultDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return TolyDefault(
      image: Icon(Icons.folder_open, size: 80, color: Colors.grey),
      title: '文件夹为空',
      description: '这里还没有任何文件，快来创建第一个文件吧',
      action: ElevatedButton.icon(
        onPressed: () {
          $message.success(message: '开始创建新文件');
        },
        icon: Icon(Icons.add, size: 18),
        label: Text('创建文件'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          iconColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }
}
