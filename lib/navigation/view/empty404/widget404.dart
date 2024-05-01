import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Widget404 extends StatelessWidget {
  const Widget404({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset('assets/images/programming.svg',width: 300),

            Text("正在设计研发中",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
            const SizedBox(height: 4,),
            Wrap(
              spacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(width: 40,height: 1,color: Colors.grey,),
                Text("敬请期待",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.grey)),
                Container(width: 40,height: 1,color: Colors.grey,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
