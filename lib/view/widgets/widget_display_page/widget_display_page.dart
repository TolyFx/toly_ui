// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-09
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';
import 'package:toly_ui/components/node_display.dart';
import 'package:toly_ui/view/widgets/display_nodes/gen/node.g.dart';
import 'package:toly_ui/view/widgets/display_nodes/gen/widget_display_map.g.dart';
import 'package:toly_ui/view/widgets/widget_display_page/widget_display_anchor.dart';
import 'package:toly_ui/view/widgets/widget_display_page/widget_pitch.dart';
import 'package:tolyui_anchor/tolyui_anchor.dart';

import '../../home_page/cooperation_panel.dart';
import '../../home_page/link_panel.dart';

class WidgetDisplayPage extends StatefulWidget {
  final String name;

  const WidgetDisplayPage({super.key, required this.name});

  @override
  State<WidgetDisplayPage> createState() => _WidgetDisplayPageState();
}

class _WidgetDisplayPageState extends State<WidgetDisplayPage>
    with AutomaticKeepAliveClientMixin {
  final TolyAnchorController _controller = TolyAnchorController();

  // --- 数据 ---
  late final Map<String, dynamic> _displayNodes;
  late final List<String> _nodeKeys;
  late final List<TolyAnchorLink> _links;
  late final List<AnchorEntry> _entries; // 传给自定义侧栏

  // 底部区域索引（item 0 是占位符，actual content 从 index 1 开始）
  static const int _placeholderCount = 1; // "案例用法" 占位
  int get _demoStart => _placeholderCount;
  int get _extraStart => _demoStart + _nodeKeys.length;
  bool get _hasPitch => hasPitch(widget.name);
  int get _pitchIdx => _extraStart;
  int get _coopIdx => _extraStart + (_hasPitch ? 1 : 0);
  int get _linkIdx => _extraStart + (_hasPitch ? 1 : 0) + 1;
  int get _totalItems => _extraStart + (_hasPitch ? 1 : 0) + 2;

  @override
  void initState() {
    super.initState();

    _displayNodes = queryDisplayNodes(widget.name);
    _nodeKeys = _displayNodes.keys.toList();

    // _links 和 _entries 一一对应
    _links = [const TolyAnchorLink(title: '案例用法', href: 'cases')];
    _entries = [const AnchorEntry(title: '案例用法')];

    for (int i = 0; i < _nodeKeys.length; i++) {
      final title =
          ((_displayNodes[_nodeKeys[i]] as Map<String, dynamic>)['title'] ?? '')
              .toString();
      _links.add(TolyAnchorLink(title: title, href: _nodeKeys[i]));
      _entries.add(AnchorEntry(title: title, depth: 1));
    }

    // 底部固定区域（平级）
    _links.addAll([
      const TolyAnchorLink(title: '合作与赞助', href: 'cooperation'),
      const TolyAnchorLink(title: '参与贡献', href: 'link'),
    ]);
    _entries.addAll([
      const AnchorEntry(title: '合作与赞助'),
      const AnchorEntry(title: '参与贡献'),
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TolyAnchorScrollable(
              controller: _controller,
              itemCount: _totalItems,
              itemBuilder: _buildItem,
            ),
          ),
          WidgetDisplayAnchor(
            controller: _controller,
            links: _links,
            entries: _entries,
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    // index 0 = "案例用法" 占位符，紧接着就是第一个 demo
    if (index < _demoStart) return const SizedBox.shrink();

    final ri = index - _demoStart; // real index within content
    if (ri < _nodeKeys.length) {
      final key = _nodeKeys[ri];
      return NodeDisplay(
        key: PageStorageKey('node_${widget.name}_$key'),
        display: widgetDisplayMap(key),
        node: Node.fromMap(
          _displayNodes[key] as Map<String, dynamic>,
        ),
      );
    } else if (_hasPitch && index == _pitchIdx) {
      return WidgetPitch(name: widget.name);
    } else if (index == _coopIdx) {
      return const CooperationPanel(isDense: true);
    } else if (index == _linkIdx) {
      return const LinkPanel(isDense: true);
    }
    return const SizedBox.shrink();
  }
}
