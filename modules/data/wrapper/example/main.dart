/// create by 张风捷特烈 on 2020/9/18
/// contact me by email 1981462002@qq.com
/// 说明:

import 'package:flutter/material.dart';

import '../lib/wrapper.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(),
          body: buildCenter(),
        ));
  }

  Center buildCenter() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildColorTypeWrapper(),
          SizedBox(
            height: 10,
          ),
          buildSpineWrapper(),
          SizedBox(
            height: 10,
          ),
          buildShadowWrapper(),
          SizedBox(
            height: 10,
          ),
          buildLineWrapper(),
          SizedBox(
            height: 10,
          ),
          buildOtherWrapper(),
        ],
      ),
    );
  }

  Widget buildColorTypeWrapper() => Wrap(
    spacing: 10,
    children: [
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper(
            formEnd: false,
            color: Color(0xff95EC69),
            spineType: SpineType.left,
            child: Text("张风捷特烈 " * 5),
          )),
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper(
            formEnd: false,
            color: Color(0xff97C0EC),
            spineType: SpineType.right,
            child: Text("张风捷特烈 " * 5),
          )),
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper(
            formEnd: false,
            color: Color(0xffEC6E5F),
            spineType: SpineType.top,
            child: Text("张风捷特烈 " * 5),
          )),
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper(
            formEnd: false,
            color: Color(0xffB6EC48),
            spineType: SpineType.bottom,
            child: Text("张风捷特烈 " * 5),
          )),
    ],
  );

  buildSpineWrapper() => Wrap(
    spacing: 10,
    children: [
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper(
            color: Color(0xff95EC69),
            spineType: SpineType.bottom,
            child: Text("张风捷特烈 " * 5),
          )),
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper(
            color: Color(0xff95EC69),
            spineType: SpineType.bottom,
            offset: 60,
            child: Text("张风捷特烈 " * 5),
          )),
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper(
            color: Color(0xff95EC69),
            spineType: SpineType.bottom,
            spineHeight: 20,
            angle: 45,
            child: Text("张风捷特烈 " * 5),
          )),
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper(
            formEnd: true,
            color: Color(0xff95EC69),
            spineType: SpineType.bottom,
            child: Text("张风捷特烈 " * 5),
          )),
    ],
  );

  buildShadowWrapper() => Wrap(
    spacing: 10,
    children: [
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper(
            color: Color(0xff95EC69),
            spineType: SpineType.bottom,
            elevation: 1,
            shadowColor: Colors.blueAccent.withAlpha(99),
            child: Text("张风捷特烈 " * 5),
          )),
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper(
            color: Colors.white,
            spineType: SpineType.right,
            elevation: 1,
            shadowColor: Colors.grey.withAlpha(88),
            child: Text("张风捷特烈 " * 5),
          )),
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper(
            color: Color(0xff95EC69),
            spineType: SpineType.bottom,
            elevation: 2,
            shadowColor: Colors.red.withAlpha(77),
            child: Text("张风捷特烈 " * 5),
          )),
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper(
            color: Colors.white,
            spineType: SpineType.bottom,
            elevation: 2,
            shadowColor: Colors.orangeAccent,
            child: Text("张风捷特烈 " * 5),
          )),
    ],
  );

  buildLineWrapper() => Wrap(
    spacing: 10,
    children: [
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper(
            color: Colors.red,
            spineType: SpineType.bottom,
            strokeWidth: 1,
            child: Text("张风捷特烈 " * 5),
          )),
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper(
            color: Colors.blue,
            spineType: SpineType.right,
            strokeWidth: 2,
            child: Text("张风捷特烈 " * 5),
          )),
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper(
            color: Colors.green,
            spineType: SpineType.bottom,
            strokeWidth: 3,
            child: Text("张风捷特烈 " * 5),
          )),
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper(
            formEnd: true,
            padding: EdgeInsets.all(10),
            color: Colors.yellow,
            offset: 60,
            strokeWidth: 2,
            spineType: SpineType.bottom,
            child: Text("张风捷特烈 " * 5),
          )),
    ],
  );

  buildOtherWrapper() => Wrap(
    spacing: 10,
    children: [
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper.just(
            padding: EdgeInsets.all(2),
            color: Color(0xff5A9DFF),
            child: Text(
              "Lv3",
              style: TextStyle(color: Colors.white),
            ),
          )),
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper.just(
            padding: EdgeInsets.all(2),
            color: Color(0xffFFA001),
            child: Text(
              "Lv5",
              style: TextStyle(color: Colors.white),
            ),
          )),
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper.just(
            color: Colors.orangeAccent,
            strokeWidth: 1,
            child: Text("这是一个边线框"),
          )),
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper.just(
            color: Color(0xff95EC69),
            child: Text("张风捷特烈 " * 5),
          )),
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper.just(
            padding: EdgeInsets.all(2),
            color: Color(0xff5A9DFF),
            strokeWidth: 2,
            // radius: 29,
            child: Image.asset(
              "assets/images/icon_head.png",
              height: 60,
            ),
          )),
      Container(
          constraints: BoxConstraints(maxWidth: 200),
          child: Wrapper.just(
            padding: EdgeInsets.all(2),
            color: Color(0xff5A9DFF),
            strokeWidth: 2,
            radius: 31,
            child: Image.asset(
              "assets/images/icon_head.png",
              height: 60,
            ),
          )),
    ],
  );
}
