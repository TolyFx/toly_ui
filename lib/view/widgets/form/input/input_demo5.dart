import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '多行输入区域',
  desc: 'TolyInputArea 简单封装了 TextField，使其可以拖拽改变输入框大小，通过 ResizeType 指定尺寸改变的类型：',
)
class InputDemo5 extends StatefulWidget {
  const InputDemo5({super.key});

  @override
  State<InputDemo5> createState() => _InputDemo5State();
}

class _InputDemo5State extends State<InputDemo5> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Wrap(
        spacing: 20,
        children: [
          TolyInputArea(
            hitText: '输入框可拉伸宽高',
          ),
          TolyInputArea(
            hitText: '输入框只可拉伸高度',
            resizeType: ResizeType.height,
          ),
          TolyInputArea(
            hitText: '输入框只可拉伸宽度',
            resizeType: ResizeType.width,
            fillColor: Colors.deepOrangeAccent.withOpacity(0.1),
          ),
        ],
      ),
    );
  }
}
