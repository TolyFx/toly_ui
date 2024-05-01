import 'package:flutter/material.dart';
import 'package:toly_ui/app/logic/actions/navigation.dart';
import 'package:toly_ui/components/node_display.dart';
import 'package:toly_ui/view/widgets/widget_display_map.dart';
import 'package:tolyui/tolyui.dart';

import 'display_nodes.dart';

class IconDisplayPage extends StatelessWidget {
  const IconDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> keys = displayNodes.keys.toList();
    dynamic data = displayNodes.values.toList();
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (_, index) {
          if(index ==displayNodes.length){
            return Padding$(
              padding: (re)=>switch (re) {
                Rx.xs => const EdgeInsets.symmetric(horizontal: 18.0),
                Rx.sm => const EdgeInsets.symmetric(horizontal: 24.0),
                Rx.md => const EdgeInsets.symmetric(horizontal: 32.0),
                Rx.lg => const EdgeInsets.symmetric(horizontal: 48.0),
                Rx.xl => const EdgeInsets.symmetric(horizontal: 164.0),
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24,),
                  Text('如何使用 Iconfont 的图标?',style: TextStyle(fontSize: 24),),
                  const SizedBox(height: 12,),

                  Text('使用 toly 命令行工具生成代码，便于在 Flutter 项目中使用 iconfont 图标。 '),
                  const SizedBox(height: 8,),

                  TolyLink(text: '文章介绍: Flutter 图标字体代码生成器',style: TextStyle(
                    color: Colors.blue
            ), href: 'https://juejin.cn/post/7323408577709293602', onTap: jumpUrl,),
                  TolyLink(text: '视频介绍: Flutter 图标字体代码生成器',style: TextStyle(
                    color: Colors.blue
            ), href: 'https://www.bilibili.com/video/BV1Pa4y127V6/', onTap: jumpUrl,),
                ],
              ),
            );
          }
          return NodeDisplay(
            display: widgetDisplayMap(keys[index]),
            node: Node.fromMap(data[index]),
          );
        },
        itemCount: displayNodes.length+1,
      ),
    );
  }


}
