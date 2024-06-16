import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '图片颜色及混合模式',
  desc: 'colorBlendMode 属性设置图片混合模式，一共 29 种，下面是与颜色叠合的效果：',
)
class BlendModeImage extends StatelessWidget {
  const BlendModeImage({super.key});

  @override
  Widget build(BuildContext context) {
    const AssetImage image = AssetImage("assets/images/icon_head.webp");
    Color color = Colors.blue.withAlpha(88);
    return Wrap(
      children: BlendMode.values
          .toList()
          .map((mode) => Column(children: [
                Container(
                    margin: const EdgeInsets.all(5),
                    width: 60,
                    height: 60,
                    color: Colors.red,
                    child: Image(image: image, color: color, colorBlendMode: mode)),
                Text(mode.toString().split(".")[1])
              ]))
          .toList(),
    );
  }
}
