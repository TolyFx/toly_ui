import 'package:flutter/material.dart';
import 'package:toly_ui/app/logic/actions/navigation.dart';
import 'package:tolyui/tolyui.dart';

class ContactMe extends StatelessWidget {
  const ContactMe({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 240,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    CircleAvatar(radius: 18,backgroundImage: AssetImage('assets/images/me.webp') ,),
                    Text('张风捷特烈',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              const SizedBox(height: 6,),
              Text('联系我',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              const SizedBox(height: 6,),
              Text('邮箱: 1981462002@qq.com'),
              Text('微信: zdl1994328'),
              Text('QQ: 1981462002'),

              const SizedBox(height: 24,),
              Text('博客与视频',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              const SizedBox(height: 6,),
              TolyLink(href: kJuejinUrl, text: '掘金社区·张风捷特烈', onTap: jumpUrl,lineType: LineType.always,),
              TolyLink(href: kBlibliUrl, text: '哔哩哔哩·张风捷特烈', onTap: jumpUrl,lineType: LineType.always,),
            ],
          ),
        ));
  }
}
