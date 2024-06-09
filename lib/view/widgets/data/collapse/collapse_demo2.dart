import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toly_ui/incubator/components/data/collapse/switch_panel.dart';
import 'package:toly_ui/view/widgets/display_nodes/display_nodes.dart';
import 'package:tolyui/tolyui.dart';

@DisplayNode(
  title: '灵活可定制化',
  desc:
      '开发者通过 CollapseController 自主控制打开和关闭；标题如果想要感知动画和控制器，展开过程中自定义内容，可以通过 titleBuilder 构建标题，如下第二个案例，只有点击图标时才会展开/关闭。',
)
class CollapseDemo2 extends StatefulWidget {
  const CollapseDemo2({super.key});

  @override
  State<CollapseDemo2> createState() => _CollapseDemo2State();
}

class _CollapseDemo2State extends State<CollapseDemo2> {
  final CollapseController ctrl = CollapseController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(),
        display1(),
        const Divider(),
        display2(),
        const Divider(),
      ],
    );
  }

  Widget display1() {
    const String title = '《春》· 朱自清';
    const String content = """盼望着，盼望着，东风来了，春天的脚步近了。
一切都像刚睡醒的样子，欣欣然张开了眼。山朗润起来了，水涨起来了，太阳的脸红起来了。
小草偷偷地从土里钻出来，嫩嫩的，绿绿的。园子里，田野里，瞧去，一大片一大片满是的。坐着，躺着，打两个滚，踢几脚球，赛几趟跑，捉几回迷藏。风轻悄悄的，草绵软软的。
桃树、杏树、梨树，你不让我，我不让你，都开满了花赶趟儿。红的像火，粉的像霞，白的像雪。花里带着甜味，闭了眼，树上仿佛已经满是桃儿、杏儿、梨儿！花下成千成百的蜜蜂嗡嗡地闹着，大小的蝴蝶飞来飞去。野花遍地是：杂样儿，有名字的，没名字的，散在草丛里，像眼睛，像星星，还眨呀眨的。""";
    return TolyCollapse(
      controller: ctrl,
      sizeCurve: Curves.ease,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(content),
          ),
          Divider(),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                ctrl.close();
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  '收起面板 ↑',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          )
        ],
      ),
      duration: Duration(milliseconds: 400),
    );
  }

  Widget display2() {
    const String title = '《应龙》· 张风捷特烈';
    const String content = """一游小池两岁月，\n洗却凡世几闲尘。\n时逢雷霆风会雨，\n应乘扶摇化入云。""";
    return TolyCollapse(
      titleBuilder: _buildTitle,
      sizeCurve: Curves.ease,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      duration: Duration(milliseconds: 600),
    );
  }

  Widget _buildTitle(BuildContext context, Animation<double> anima, CollapseController ctrl) {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: AnimatedBuilder(
            animation: anima,
            builder: (_, __) => Text(
              '《应龙》· 张风捷特烈',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.lerp(Colors.black, Colors.blue, Curves.ease.transform(anima.value))),
            ),
          ),
        )),
        Spacer(),
        GestureDetector(
            onTap: () async {
              await Clipboard.setData(
                  ClipboardData(text: """一游小池两岁月，\n洗却凡世几闲尘。\n时逢雷霆风会雨，\n应乘扶摇化入云。"""));
              $message.success(message: '代码复制成功!');
            },
            child: const TolyTooltip(
                message: '复制代码',
                gap: 20,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Icon(
                  Icons.copy_rounded,
                  size: 20,
                  color: Color(0xff828282),
                ))),
        const SizedBox(
          width: 16,
        ),
        TolyTooltip(
          message: '查看源码',
          gap: 20,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: GestureDetector(
            onTap: ctrl.toggle,
            child: AnimatedBuilder(
              animation: anima,
              builder: (_, child) {
                Color? color = Color.lerp(
                    const Color(0xff828282), Colors.blue, Curves.ease.transform(anima.value));
                return Transform.rotate(
                  angle: pi / 2 * Curves.ease.transform(anima.value),
                  child: Icon(
                    Icons.code,
                    color: color,
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
