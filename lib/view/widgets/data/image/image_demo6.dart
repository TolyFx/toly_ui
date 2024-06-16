import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '图片切片区域',
  desc: 'centerSlice 属性设置图片切片区域片，指定 Rect 矩形区域进行宫格缩放：',
)
class CenterSliceImage extends StatelessWidget {
  const CenterSliceImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 80,
      child: Image.asset(
        "assets/images/right_chat.png",
        centerSlice: const Rect.fromLTRB(9, 27, 60, 27 + 1.0),
        fit: BoxFit.fill,
      ),
    );
  }
}
