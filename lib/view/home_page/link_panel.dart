import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LinkPanel extends StatelessWidget {
  const LinkPanel({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle style=  TextStyle(fontSize: 20,color: Color(0xff5d5d5f),fontWeight: FontWeight.bold);
    // TextStyle style=  TextStyle(fontSize: 20,color: Colors.white);
    TextStyle contentStyle=  TextStyle(fontSize: 14,color: Colors.grey,fontFamily: '黑体');
    return DefaultTextStyle(
      style: contentStyle,
      child: ColoredBox(
        color: Colors.transparent,
        child: SizedBox(
          width: double.maxFinite,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48,vertical: 48),
              child: Wrap(
                spacing: 64,
                alignment: WrapAlignment.center,
                // crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 24,
                children: [
                  Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Text('链接',style:style,),
                      const SizedBox(height: 2,),
                      Text('Github'),
                      Text('pub'),
                      Text('更新日志'),
                      Text('常见问题'),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Text('讨论区',style:style,),
                      const SizedBox(height: 2,),
                      Text('建议反馈'),
                      Text('QQ 群聊'),
                      Text('参与贡献'),

                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Text('友情链接',style:style,),
                      const SizedBox(height: 2,),

                      Text('掘金社区'),

                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    direction: Axis.vertical,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    children: [
                      Text('联系我',style:style,),
                      const SizedBox(height: 2,),
                      Text('邮箱'),
                      Text('微信'),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
