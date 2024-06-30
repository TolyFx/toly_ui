// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-30
// Contact Me:  1981462002@qq.com

part of 'toly_select.dart';

class _SelectTarget extends StatefulWidget {
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? labelPadding;
  final bool focused;
  final bool shrinkWidth;
  final String label;
  final double fontSize;
  final double iconSize;
  final Color disableColor;
  final Animation<double> animation;

  const _SelectTarget({
    super.key,
    this.constraints,
    this.padding,
    this.labelPadding,
    this.shrinkWidth = false,
    required this.focused,
    required this.label,
    required this.fontSize,
    required this.disableColor,
    required this.animation,
    required this.iconSize,
  });

  @override
  State<_SelectTarget> createState() => _SelectTargetState();
}

class _SelectTargetState extends State<_SelectTarget> {
  Color get borderColor {
    if (widget.focused) {
      return Colors.blue;
    }
    return widget.disableColor;
  }

  @override
  Widget build(BuildContext context) {
    Widget text = Text(
      widget.label,
      style: TextStyle(height: 1, fontSize: widget.fontSize),
    );
    if (widget.labelPadding != null) {
      text = Padding(padding: widget.labelPadding!, child: text);
    }

    Widget child = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        text,
        AnimatedBuilder(
          animation: widget.animation,
          builder: (_, child) => Transform.rotate(
            angle: widget.animation.value,
            child: child,
          ),
          child: Icon(
            Icons.keyboard_arrow_down,
            size: widget.iconSize,
          ),
        ),
      ],
    );
    if (widget.shrinkWidth) {
      child = IntrinsicWidth(
        child: child,
      );
    }

    return Container(
      constraints: widget.constraints,
      padding: widget.padding,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: borderColor,
          )),
      child: child,
    );
  }
}
