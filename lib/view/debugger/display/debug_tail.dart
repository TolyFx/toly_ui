// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-14
// Contact Me:  1981462002@qq.com

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

class DebugTail extends StatelessWidget {
  final MenuWidthType type;
  final bool dark;

  const DebugTail({super.key, required this.type,  this.dark=false});

  @override
  Widget build(BuildContext context) {
    bool isLarge = type == MenuWidthType.large;
    Color color = (context.isDark||dark)?Colors.white:const Color(0xff868686);
    return  Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: isLarge?CrossAxisAlignment.start:CrossAxisAlignment.center,
      children: [
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 8.0),
          child: Wrap(
            spacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.vertical,
            children: [
              Icon(Icons.help_outline,color: color,size: 20,),
              Text('帮助',style: TextStyle(fontSize: 12,color:color),),
            ],
          ),
        )
      ],
    );
  }
}
