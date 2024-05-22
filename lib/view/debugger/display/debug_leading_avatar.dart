// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-14
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';
import 'package:tolyui/tolyui.dart';

class DebugLeadingAvatar extends StatelessWidget {
  final MenuWidthType type;
  final Brightness brightness;

  const DebugLeadingAvatar(
      {super.key, this.type=MenuWidthType.large, this.brightness = Brightness.light});

  @override
  Widget build(BuildContext context) {
    CrossAxisAlignment crossAxisAlignment = switch (type) {
      MenuWidthType.small => CrossAxisAlignment.center,
      MenuWidthType.large => CrossAxisAlignment.start,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        const SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Wrap(
            spacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/images/me.webp'),
              ),
              if (type == MenuWidthType.large) _buildLargeCell(),
            ],
          ),
        ),
        // Text(cts.maxWidth.toString()),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }

  Widget _buildLargeCell() {
    Color textColor = switch (brightness) {
      Brightness.dark => const Color(0xffd7e3f4),
      Brightness.light => Colors.black,
    };
    Color linkColor = switch (brightness) {
      Brightness.dark => const Color(0xffd7e3f4),
      Brightness.light => Colors.grey,
    };
    Color? hoverColor = switch (brightness) {
      Brightness.dark => const Color(0xffd7e3f4),
      Brightness.light => null,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '张风捷特烈',
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        TolyLink(
          href: '/sponsor',
          text: '联系作者',
          hoverColor: hoverColor,
          onTap: (v) {},
          style: TextStyle(color: linkColor, fontSize: 12),
        )
      ],
    );
  }
}

