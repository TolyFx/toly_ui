// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-10
// Contact Me:  1981462002@qq.com
import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/basic/icon/icon_pitch_use.dart';
import 'package:tolyui/tolyui.dart';

bool hasPitch(String name) => ['icon'].contains(name);

class WidgetPitch extends StatelessWidget {
  final String name;

  const WidgetPitch({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox();
    if (name == 'icon') {
      child = const IconPitchUse();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 36),
        const Divider(),
        Padding$(
            padding: (re) => switch (re) {
                  Rx.xs => const EdgeInsets.symmetric(horizontal: 18.0),
                  Rx.sm => const EdgeInsets.symmetric(horizontal: 24.0),
                  Rx.md => const EdgeInsets.symmetric(horizontal: 32.0),
                  Rx.lg => const EdgeInsets.symmetric(horizontal: 48.0),
                  Rx.xl => const EdgeInsets.symmetric(horizontal: 64.0),
                },
            child: child),
      ],
    );
  }
}
