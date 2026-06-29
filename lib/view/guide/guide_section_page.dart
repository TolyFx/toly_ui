// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-29
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';
import 'package:tolyui_anchor/tolyui_anchor.dart';

/// 指南页面中的单个 section 数据
class GuideSection {
  final String title;
  final WidgetBuilder builder;

  const GuideSection({required this.title, required this.builder});
}

/// 带 TolyAnchor 侧栏导航的通用指南页面
///
/// 内部自动管理 TolyAnchorController，左侧内容用 TolyAnchorScrollable 渲染，
/// 右侧用 TolyAnchor 显示目录导航。
class GuideSectionPage extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final List<GuideSection> sections;

  const GuideSectionPage({
    super.key,
    this.title,
    this.subtitle,
    required this.sections,
  });

  @override
  State<GuideSectionPage> createState() => _GuideSectionPageState();
}

class _GuideSectionPageState extends State<GuideSectionPage> {
  final TolyAnchorController _controller = TolyAnchorController();
  late final List<TolyAnchorLink> _links;

  @override
  void initState() {
    super.initState();
    _links = widget.sections
        .map((s) => TolyAnchorLink(title: s.title, href: s.title))
        .toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sections.isEmpty) {
      return const SizedBox.shrink();
    }

    // header 固定在上方不参与滚动，sections 从 index 0 开始
    // 这样 TolyAnchor 的 link[index] 与 section[index] 一一对应，无需偏移
    return Material(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(
                  child: TolyAnchorScrollable(
                    controller: _controller,
                    itemCount: widget.sections.length,
                    itemBuilder: _buildItem,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
            child: SizedBox(
              width: 200,
              child: TolyAnchor(
                controller: _controller,
                links: _links,
                linkBuilder: _buildLink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 48, 48, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title!,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  widget.subtitle!,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 36),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final isLast = index == widget.sections.length - 1;
    return Padding(
      padding: EdgeInsets.fromLTRB(48, 16, 48, isLast ? 64 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // section 间分割线（非首项）
          if (index > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey[200],
              ),
            ),
          widget.sections[index].builder(context),
        ],
      ),
    );
  }

  Widget _buildLink(BuildContext context, TolyAnchorLink link, bool active) {
    final index = _links.indexOf(link);
    final primary = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      // sections 从 index 0 开始，link 与 section 一一对应，无需偏移
      onTap: () => _controller.scrollToIndex(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 32,
        margin: const EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: active ? primary.withOpacity(0.06) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border(
            left: BorderSide(
              color: active ? primary : const Color(0xFFE8E8E8),
              width: 2,
            ),
          ),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 14),
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
