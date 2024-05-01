import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';


import '../widgets/basic/button/button_demo1.dart';
import '../widgets/basic/button/button_demo2.dart';
import '../widgets/basic/button/palette.dart';

class CooperationPanel extends StatelessWidget {
  const CooperationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    Palette foreground = const Palette(normal: Color(0xff606266), hover: Color(0xff096dd9), pressed: Color(0xff096dd9));
    Palette border = const Palette(normal: Color(0xffd9d9d9), hover: Color(0x44409eff), pressed: Color(0xff096dd9));
    Palette bg = const Palette(normal: Color(0xff1890ff), hover: Color(0xffecf5ff), pressed: Color(0xffecf5ff));
    return Center(child: Padding(
      padding: const EdgeInsets.only(bottom: 46.0,top: 72),
      child: Column(
        children: [
          const Text(
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
                    const Column(
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
                    const Column(
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


          ElevatedButton(
              style: OutlineButtonPalette(
                borderRadius: BorderRadius.circular(20),
                foregroundPalette: foreground,
                borderPalette: border,
                backgroundPalette: bg,
              ).style,
              // FillButtonPalette(
              //   borderRadius: BorderRadius.circular(20),
              //   palette: const Palette(
              //     normal: Color(0xff1890ff),
              //     hover: Color(0xffecf5ff),
              //     foregroundPalette: Color(0xff606266),
              //     pressed: Color(0xff096dd9),
              //   ),
              // ).style

              onPressed: () {},
              child: const Text('成为赞助商!'))

        ],
      ),
    ));
  }
}
