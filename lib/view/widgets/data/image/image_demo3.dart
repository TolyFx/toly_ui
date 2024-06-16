import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '图片对齐模式',
  desc: 'alignment 属性设置图片对齐模式，常用 Alignment 类的九个静态常量，但也可定制位置：',
)
class AlignmentImage extends StatelessWidget {
  const AlignmentImage({super.key});

  final List<Alignment> alignment = const [
    Alignment.center,
    Alignment.centerLeft,
    Alignment.centerRight,
    Alignment.topCenter,
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.bottomCenter,
    Alignment.bottomLeft,
    Alignment.bottomRight
  ];

  @override
  Widget build(BuildContext context) {
    const AssetImage image = AssetImage("assets/images/wy_30x20.webp");
    List<Widget> imgLi = alignment
        .map((alignment) => Column(children: [
              Container(
                  margin: const EdgeInsets.all(6),
                  width: 90,
                  height: 60,
                  color: Colors.grey.withAlpha(88),
                  child: Image(image: image, alignment: alignment)),
              Text(alignment.toString().split(".")[1])
            ]))
        .toList();
    return Wrap(children: imgLi);
  }
}
