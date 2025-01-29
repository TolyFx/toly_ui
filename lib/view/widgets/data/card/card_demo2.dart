import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';
import 'package:toly_ui/view/debugger/display/debug_display_tile.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';

@DisplayNode(
  title: '图片背景',
  desc: '可以指定 image 属性，设置 DecorationImage 呈现背景图片:',
)
class CardDemo2 extends StatelessWidget {
  const CardDemo2({super.key});

  @override
  Widget build(BuildContext context) {
    String message = '中国 21 世纪伟大的编程者、诗人、文学家、思想家。学无止境的开拓者、践行者。代表作有《捷特诗集》、《代码之海》等。';
    String lx = '原名周樟寿，后改名周树人，著名文学家、思想家、革命家、教育家、民主战士，新文化运动的重要参与者，中国现代文学的奠基人之一。';
    return Wrap(
      spacing: 12,
      children: [
        SizedBox(
          width: 150,
          child: TolyCard(
              image: const DecorationImage(
                opacity: 0.2,
                fit: BoxFit.cover,
                image: AssetImage('assets/images/me.webp'),
              ),
              child: DebugDisplayTile(
                title: '张风捷特烈',
                centerTitle: true,
                content: message,
                foot: '人物卡片',
              )),
        ),
        SizedBox(
          width: 150,
          child: TolyCard(
              image: const DecorationImage(
                opacity: 0.2,
                fit: BoxFit.cover,
                image: AssetImage('assets/images/lx.webp'),
              ),
              child: DebugDisplayTile(
                title: '鲁迅',
                centerTitle: true,
                content: lx,
                foot: '人物卡片',
              )),
        ),
      ],
    );
  }
}
