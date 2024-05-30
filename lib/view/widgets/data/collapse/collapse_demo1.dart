import 'package:flutter/material.dart';

import 'package:toly_ui/incubator/components/data/collapse/switch_panel.dart';

class CollapseDemo1 extends StatelessWidget {
  const CollapseDemo1({super.key});

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
        display3(),
        const Divider(),
      ],
    );
  }

  Widget display1(){
    const String title = '《春》· 朱自清';
    const String content = """盼望着，盼望着，东风来了，春天的脚步近了。
一切都像刚睡醒的样子，欣欣然张开了眼。山朗润起来了，水涨起来了，太阳的脸红起来了。
小草偷偷地从土里钻出来，嫩嫩的，绿绿的。园子里，田野里，瞧去，一大片一大片满是的。坐着，躺着，打两个滚，踢几脚球，赛几趟跑，捉几回迷藏。风轻悄悄的，草绵软软的。
桃树、杏树、梨树，你不让我，我不让你，都开满了花赶趟儿。红的像火，粉的像霞，白的像雪。花里带着甜味，闭了眼，树上仿佛已经满是桃儿、杏儿、梨儿！花下成千成百的蜜蜂嗡嗡地闹着，大小的蝴蝶飞来飞去。野花遍地是：杂样儿，有名字的，没名字的，散在草丛里，像眼睛，像星星，还眨呀眨的。""";
    return const TolyCollapse(
      sizeCurve: Curves.ease,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content:Text(content),
      duration: Duration(milliseconds: 400),
    );
  }

  Widget display2(){
    const String title = '《应龙》· 张风捷特烈';
    const String content = """一游小池两岁月，\n洗却凡世几闲尘。\n时逢雷霆风会雨，\n应乘扶摇化入云。""";
    return const TolyCollapse(
      sizeCurve: Curves.ease,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      duration: Duration(milliseconds: 300),
    );
  }

  Widget display3(){
    const String title = '《朝花夕拾》· 鲁迅';
    const String content = """《朝花夕拾》原名《旧事重提》，是现代文学家鲁迅的散文集，收录鲁迅于1926年创作的10篇回忆性散文， 1928年由北京未名社出版，现编入《鲁迅全集》第2卷。
此文集作为“回忆的记事”，多侧面地反映了作者鲁迅青少年时期的生活，形象地反映了他的性格和志趣的形成经过。前七篇反映他童年时代在绍兴的家庭和私塾中的生活情景，后三篇叙述他从家乡到南京，又到日本留学，然后回国教书的经历；揭露了半殖民地半封建社会种种丑恶的不合理现象，同时反映了有抱负的青年知识分子在旧中国茫茫黑夜中，不畏艰险，寻找光明的困难历程，以及抒发了作者对往日亲友、师长的怀念之情。
文集以记事为主，饱含着浓烈的抒情气息，往往又夹以议论，做到了抒情、叙事和议论融为一体，优美和谐，朴实感人。作品富有诗情画意，又不时穿插着幽默和讽喻；形象生动，格调明朗，有强烈的感染力 。
    """;
    return const TolyCollapse(
      sizeCurve: Curves.ease,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      duration: Duration(milliseconds: 600),
    );
  }
}
