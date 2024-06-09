// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-09
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/widget_display_page/sliver_display_node_list.dart';

import '../../home_page/cooperation_panel.dart';
import '../../home_page/link_panel.dart';

class WidgetDisplayPage extends StatelessWidget {
  final String name;

  const WidgetDisplayPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverDisplayNodeList(name: name),
          SliverList(
              delegate: SliverChildListDelegate([
            const CooperationPanel(
              padding: EdgeInsets.symmetric(vertical: 46),
            ),
            const Divider(),
            const LinkPanel(),
          ]))
        ],
      ),
    );
  }
}
