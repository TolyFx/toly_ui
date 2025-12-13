// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-09
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';
import 'package:toly_ui/view/widgets/widget_display_page/sliver_display_node_list.dart';
import 'package:toly_ui/view/widgets/widget_display_page/widget_pitch.dart';

import '../../home_page/cooperation_panel.dart';
import '../../home_page/link_panel.dart';

class WidgetDisplayPage extends StatefulWidget {
  final String name;

  const WidgetDisplayPage({super.key, required this.name});

  @override
  State<WidgetDisplayPage> createState() => _WidgetDisplayPageState();
}

class _WidgetDisplayPageState extends State<WidgetDisplayPage> with AutomaticKeepAliveClientMixin {
  static final Map<String, double> _scrollPositions = {};
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final savedPosition = _scrollPositions[widget.name] ?? 0.0;
    _scrollController = ScrollController(initialScrollOffset: savedPosition);
    _scrollController.addListener(_saveScrollPosition);
  }

  void _saveScrollPosition() {
    if (_scrollController.hasClients) {
      _scrollPositions[widget.name] = _scrollController.offset;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_saveScrollPosition);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: CustomScrollView(
        key: PageStorageKey('widget_display_${widget.name}'),
        controller: _scrollController,
        slivers: [
          SliverDisplayNodeList(name: widget.name),
          SliverList(
              delegate: SliverChildListDelegate([
            if (hasPitch(widget.name)) WidgetPitch(name: widget.name),
            const SizedBox(height: 36),
            const Divider(),
            const CooperationPanel(isDense: true),
            const LinkPanel(isDense: true),
          ]))
        ],
      ),
    );
  }
}
