// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-19
// Contact Me:  1981462002@qq.com
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tolyui/mixin/hover_action_mixin.dart';

class TolyPagination extends StatefulWidget {
  final double total;
  final int initIndex;
  final int capacity;
  final double pageSize;
  const TolyPagination({
    super.key,
    required this.total,
    this.pageSize = 10,
    this.capacity = 7,
    this.initIndex = 1,
  });

  @override
  State<TolyPagination> createState() => _TolyPaginationState();
}

class _TolyPaginationState extends State<TolyPagination> {
  int _activeIndex = 1;
  late int _maxPage;

  @override
  void initState() {
    _maxPage = (widget.total / widget.pageSize).ceil();
    _activeIndex = widget.initIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TolyPagination oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.total != widget.total || oldWidget.pageSize != widget.pageSize) {
      _maxPage = widget.total ~/ widget.pageSize;
    }
    if (widget.initIndex != oldWidget.initIndex) {
      _activeIndex = widget.initIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: buildItems(),
    );
  }

  List<Widget> buildItems() {
    List<PaginationMeta> metas = [
      ActionPagination(ActionType.prev, enable: _activeIndex != 1),
    ];

    metas.addAll(calcItem());

    metas.add(ActionPagination(ActionType.next, enable: _activeIndex != _maxPage));

    return metas
        .map((e) => _PaginationItem(
              meta: e,
              activeIndex: _activeIndex,
              onSelect: _onSelect,
            ))
        .toList();
  }

  List<PaginationMeta> calcItem() {
    List<PaginationMeta> metas = [];
    if (_maxPage < widget.capacity) {
      for (int i = 1; i <= _maxPage; i++) {
        metas.add(TextPagination(i));
      }
      return metas;
    } //else if (_activeIndex > _maxPage - 4)
    if (_activeIndex <= widget.capacity ~/ 2) {
      for (int i = 1; i < widget.capacity; i++) {
        metas.add(TextPagination(i));
      }
    } else if (_activeIndex >= _maxPage - widget.capacity ~/ 2) {
      metas.add(TextPagination(1));
      metas.add(ActionPagination(ActionType.prevPage));
      for (int i = _maxPage - widget.capacity + 2; i <= _maxPage; i++) {
        metas.add(TextPagination(i));
      }
    } else {
      metas.add(TextPagination(1));
      metas.add(ActionPagination(ActionType.prevPage));
      int span = widget.capacity ~/ 2 - 1;
      int maxLimit = min(_activeIndex + span, _maxPage);
      for (int i = _activeIndex - span; i <= maxLimit; i++) {
        metas.add(TextPagination(i));
      }
    }
    if (_activeIndex <= _maxPage - (widget.capacity ~/ 2 + 1)) {
      metas.add(ActionPagination(ActionType.nextPage));
      metas.add(TextPagination(_maxPage));
    }
    return metas;
  }

  Widget decorationWrap({required Widget child}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(color: Color(0xfff0f2f5), borderRadius: BorderRadius.circular(4)),
      child: child,
    );
  }

  void _onSelect(PaginationMeta meta) {
    if (meta is TextPagination) {
      setState(() {
        _activeIndex = meta.value;
      });
    }
    if (meta is ActionPagination) {
      switch (meta.type) {
        case ActionType.prev:
          setState(() {
            _activeIndex--;
          });
          break;

        case ActionType.nextPage:
          setState(() {
            int newIndex = _activeIndex + widget.capacity;
            _activeIndex = min(newIndex, _maxPage);
          });
          break;
        case ActionType.prevPage:
          setState(() {
            int newIndex = _activeIndex - widget.capacity;
            _activeIndex = max(newIndex, 0);
          });
          break;
        case ActionType.next:
          setState(() {
            _activeIndex++;
          });
      }
    }
  }
}

sealed class PaginationMeta {
  final bool enable;

  PaginationMeta({required this.enable});
}

class TextPagination extends PaginationMeta {
  final int value;

  double get hPadding {
    if (value < 10) return 10;
    if (value < 100) return 8;
    if (value < 1000) return 6;
    return 4;
  }

  TextPagination(this.value, {super.enable = true});
}

enum ActionType {
  prev(Icons.keyboard_arrow_left),
  nextPage(Icons.last_page),
  prevPage(Icons.first_page),
  next(Icons.keyboard_arrow_right_rounded),
  ;

  final IconData icon;
  const ActionType(this.icon);
}

class ActionPagination extends PaginationMeta {
  final ActionType type;

  ActionPagination(this.type, {super.enable = true});
}

class _PaginationItem extends StatefulWidget {
  final PaginationMeta meta;
  final ValueChanged<PaginationMeta> onSelect;
  final int activeIndex;

  const _PaginationItem({
    super.key,
    required this.meta,
    required this.onSelect,
    required this.activeIndex,
  });

  @override
  State<_PaginationItem> createState() => _PaginationItemState();
}

class _PaginationItemState extends State<_PaginationItem> with HoverActionMix {
  bool get active {
    PaginationMeta meta = widget.meta;
    return (meta is TextPagination) && meta.value == widget.activeIndex;
  }

  Color? get color {
    if (!widget.meta.enable) return Color(0xffb5b8be);

    if (active) return Colors.white;
    if (hovered) return Colors.blue;

    return null;
  }

  Color? get background {
    if (!widget.meta.enable) return Color(0xfff5f7fa);
    if (active) return Colors.blue;
    return Color(0xfff0f2f5);
  }

  @override
  Widget build(BuildContext context) {
    PaginationMeta meta = widget.meta;
    Widget child = switch (meta) {
      TextPagination() => Text(
          '${meta.value}',
          style: TextStyle(color: color, fontWeight: active ? FontWeight.bold : FontWeight.normal),
        ),
      ActionPagination() => ActionPaginationIcon(
          color: color,
          hovered: hovered,
          meta: meta,
          onTap: widget.onSelect,
        ),
    };

    EdgeInsetsGeometry padding = switch (meta) {
      TextPagination() => EdgeInsets.symmetric(horizontal: meta.hPadding, vertical: 4),
      ActionPagination() => EdgeInsets.symmetric(horizontal: 4, vertical: 4),
    };

    return wrap(
      cursor: !meta.enable ? SystemMouseCursors.forbidden : null,
      GestureDetector(
        onTap: !meta.enable ? null : () => widget.onSelect(meta),
        child: Container(
          padding: padding,
          // alignment: Alignment.center,
          // height: 64,
          decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(4)),
          child: child,
        ),
      ),
    );
  }
}

class ActionPaginationIcon extends StatelessWidget {
  final bool hovered;
  final ActionPagination meta;
  final Color? color;
  final ValueChanged<ActionPagination> onTap;

  const ActionPaginationIcon({
    super.key,
    required this.hovered,
    required this.meta,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (meta.type == ActionType.nextPage || meta.type == ActionType.prevPage) {
      return Icon(
        !hovered ? Icons.more_horiz_outlined : meta.type.icon,
        size: 20,
        color: color,
      );
    }
    return Icon(
      meta.type.icon,
      size: 20,
      color: color,
    );
  }
}
