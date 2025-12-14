import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:toly_default/toly_default.dart';
import 'package:tolyui_message/tolyui_message.dart';

@DisplayNode(
  title: '主题定制',
  desc: '展示通过 DefaultThemeScope 自定义缺省页主题。可以统一配置图标颜色、文字样式、间距等，同时展示如何自定义缺省页类型，实现灵活的主题定制。',
)
class DefaultDemo6 extends StatelessWidget {
  const DefaultDemo6({super.key});

  @override
  Widget build(BuildContext context) {
    final customTheme = DefaultTheme(
      iconColor: Colors.blue,
      iconSize: 100,
      titleStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade700,
      ),
      descriptionStyle: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade600,
      ),
      spacing: 20,
    );

    final customType = DefaultType(
      key: 'customEmpty',
      icon: Icons.folder_open,
      title: '文件夹为空',
      description: '这里还没有任何内容',
    );

    return DefaultThemeScope(
      theme: customTheme,
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TolyDefault(
          type: customType,
          action: ElevatedButton.icon(
            onPressed: () {
              $message.success(message: '开始创建内容');
            },
            icon: Icon(Icons.add, size: 18),
            label: Text('创建内容'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              iconColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),
      ),
    );
  }
}
