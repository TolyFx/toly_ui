// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-29
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';
import 'package:tolyui_anchor/tolyui_anchor.dart';

/// 锚点条目（用于自定义渲染的数据）
class AnchorEntry {
  final String title;
  /// 缩进层级：0 = 顶级，1 = 一级子项
  final int depth;

  const AnchorEntry({
    required this.title,
    this.depth = 0,
  });
}

/// 右侧锚点导航组件
///
/// 内部使用 TolyAnchor + linkBuilder 实现层级渲染。
/// controller 由父级 WidgetDisplayPage 持有，自动同步 activeIndex。
class WidgetDisplayAnchor extends StatelessWidget {
  final TolyAnchorController controller;
  final List<TolyAnchorLink> links;
  final List<AnchorEntry> entries;

  const WidgetDisplayAnchor({
    super.key,
    required this.controller,
    required this.links,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    if (links.isEmpty) return const SizedBox.shrink();
    return Container(
      width: 200,
      padding: const EdgeInsets.symmetric(vertical: 24,horizontal: 12),
      child: TolyAnchor(
        controller: controller,
        links: links,
        linkBuilder: _buildLink,
      ),
    );
  }

  Widget _buildLink(BuildContext context, TolyAnchorLink link, bool active) {
    final index = links.indexOf(link);
    final entry = index < entries.length ? entries[index] : null;
    final depth = entry?.depth ?? 0;

    final primary = Theme.of(context).colorScheme.primary;
    final leftPad = 14.0 + depth * 16.0;

    return GestureDetector(
      onTap: () => controller.scrollToIndex(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: depth > 0 ? 28 : 32,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: active ? primary : const Color(0xFFE8E8E8),
              width: 2,
            ),
          ),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: leftPad),
        child: Text(
          link.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            color: active ? primary : const Color(0xFF666666),
            fontWeight: active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
