// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-12
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';

class ChangeWidthArea extends StatefulWidget {
  final double width;
  final Widget child;
  final RangeValues range;

  const ChangeWidthArea({
    super.key,
    required this.width,
    required this.child,
    required this.range,
  });

  @override
  State<ChangeWidthArea> createState() => _ChangeWidthAreaState();
}

class _ChangeWidthAreaState extends State<ChangeWidthArea> {
  late double _width = widget.width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          widget.child,
          DragChangeWidth(
            onDragChanged: handleWidthChange,
          )
        ],
      ),
    );
  }

  void handleWidthChange(double dx) {
    double width = (_width + dx).clamp(widget.range.start, widget.range.end);
    if (width != _width) {
      _width = width;
      setState(() {});
    }
  }
}

class DragChangeWidth extends StatelessWidget {
  final double width;
  final ValueChanged<double> onDragChanged;

  const DragChangeWidth({
    super.key,
    required this.onDragChanged,
    this.width = 6,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        child: Container(
          width: 6,
          alignment: Alignment.centerRight,
          child: const VerticalDivider(),
        ),
      ),
    );
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    onDragChanged(details.delta.dx);
  }
}
