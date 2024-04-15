import 'package:flutter/material.dart';

class HomeFooter extends StatelessWidget {
  const HomeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const SizedBox(height: 36,),

        Divider(),
        Container(
          // height: 56,
          padding: EdgeInsets.symmetric(vertical: 20,horizontal: 24),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  Text('Copyright © 2024 张风捷特烈'),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      height: 14,
                      child: VerticalDivider()),
                  Text('Made by  Fx & TolyUI'),
                ],
              ),
              const SizedBox(height: 4,),
              Wrap(
                alignment: WrapAlignment.center,

                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('皖ICP备18001618号-2',style: TextStyle(color: Colors.blue),),

                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      height: 14,
                      child: VerticalDivider()),
                  Text(' 皖公网安备 34010202600392号',style: TextStyle(color: Colors.blue),),


                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
