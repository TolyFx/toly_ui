import 'dart:ui';

import 'package:flutter/material.dart';

class TextDemo3 extends StatelessWidget {
  const TextDemo3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('介绍',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
        ),
        RichText(
          text: const TextSpan(
            text: '',
            style: TextStyle(color: Color(0xff606266)),
            children: <InlineSpan>[
              TextSpan(
                  text: ' TolyUI ',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              TextSpan(text: '是'),
              TextSpan(
                text: '张风捷特烈',
                style: TextStyle(color: Colors.blue, fontSize: 14),
              ),
              TextSpan(text: '打造的 Flutter('),
              WidgetSpan(
                  child: FlutterLogo(size: 14),
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.ideographic),
              TextSpan(text: ')全平台响应式应用开发 UI 框架'),
              TextSpan(
                  text: '全平台响应式',
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 14,
                      decoration: TextDecoration.underline)),
              TextSpan(text: '应用开发 UI 框架'),
              TextSpan(text: '具备'),
              TextSpan(
                text: '全平台',
                style: TextStyle(
                    color: Colors.purple,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              TextSpan(text: '、'),
              TextSpan(
                  text: '组件化',
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              TextSpan(text: '、'),
              TextSpan(
                  text: '源码开放',
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              TextSpan(text: '、'),
              TextSpan(
                  text: '响应式',
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              TextSpan(text: '四大特点。'),
              TextSpan(
                text: '提供大量 Flutter 框架内部之外的常用组件，帮助开发者迅速构建具有响应式的全平台应用软件。',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
