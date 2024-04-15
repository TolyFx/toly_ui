import 'package:flutter/material.dart';

import '../../app/res/toly_icon.dart';

class CooperationPanel extends StatelessWidget {
  const CooperationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(
      padding: EdgeInsets.only(bottom: 46.0,top: 72),
      child: Column(
        children: [
          Text(
            '合作与赞助',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xff606266)),),
          const SizedBox(height: 48,),
          Wrap(
            runSpacing: 24,
            spacing: 24,
            children: [
              SizedBox(
                width: 240,
                child: Row(
                  children: [
                    Image.asset('assets/images/logo.png',width: 42,),
                    const SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Fx 架构",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        Text("Flutter 全平台开发框架",style: TextStyle(color: Color(0xff606266)),),
                      ],
                    ),
                  ],
                ),
              ),

              // SizedBox(
              //   width: 240,
              //   child: Row(
              //     children: [
              //       Image.asset('assets/images/fc.webp',width: 42,),
              //       const SizedBox(width: 20,),
              //       Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text("FlutterCandies",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              //           Text("Flutter 糖果包",style: TextStyle(color: Color(0xff606266)),),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(
                width: 240,
                child: Row(
                  children: [
                    Image.asset('assets/images/plcki.jpg',width: 42,),
                    const SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("PLCKI",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                        Text("编程语言通用知识接口",style: TextStyle(color: Color(0xff606266)),),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 48,),
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  enableFeedback: false,
                  side: BorderSide(color: Theme.of(context).primaryColor),
                  // backgroundColor: Theme.of(context).primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  // shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  // foregroundColor: Colors.white,
                  splashFactory: NoSplash.splashFactory,
                  surfaceTintColor: Colors.transparent
              ),
              onPressed: () {},
              child: Text('成为赞助商!'))

        ],
      ),
    ));
  }
}
