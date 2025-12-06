import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';


@DisplayNode(
  title: '状态标签',
  desc: '带有图标和状态指示的标签，通过颜色和图标传达不同的状态信息。适用于任务状态、审核结果、系统通知等需要明确状态表达的场景。',
)
class TagDemo5 extends StatelessWidget {
  const TagDemo5({super.key});

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        Tag(
          icon: Icon(Icons.check_circle, size: 12, color: Colors.green),
          color: Colors.green,
          child: Text('成功'),
        ),
        Tag(
          icon: Icon(Icons.error, size: 12, color: Colors.red),
          color: Colors.red,
          child: Text('错误'),
        ),
        Tag(
          icon: Icon(Icons.warning, size: 12, color: Colors.orange),
          color: Colors.orange,
          child: Text('警告'),
        ),
        Tag(
          icon: Icon(Icons.info, size: 12, color: Colors.blue),
          color: Colors.blue,
          child: Text('信息'),
        ),
        Tag(
          icon: Icon(Icons.schedule, size: 12, color: Colors.grey),
          color: Colors.grey,
          child: Text('等待中'),
        ),
        Tag(
          icon: CupertinoActivityIndicator(
            color: Colors.purple,
            radius: 6,
          ),
          color: Colors.purple,
          child: Text('处理中'),
        ),
      ],
    );
  }
}
