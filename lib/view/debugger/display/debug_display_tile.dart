// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-09
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';

class DebugDisplayTile extends StatelessWidget {
  final String title;
  final String foot;
  final String content;
  final bool centerTitle;

  const DebugDisplayTile({
    super.key,
    required this.title,
    required this.foot,
    required this.content,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget titleWidget = Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
    if (centerTitle) {
      titleWidget = Center(
        child: titleWidget,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: titleWidget,
        ),
        Divider(),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
            child: Text(content,
                style: TextStyle(
                  fontSize: 14,
                )),
          ),
        ),
        Divider(),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
            child: Text(
              foot,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
