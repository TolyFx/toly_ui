// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-15
// Contact Me:  1981462002@qq.com
import 'package:flutter/material.dart';

class TolyInputArea extends StatefulWidget {
  final RangeValues widthRange;
  final RangeValues heightRange;
  final Size size;
  final ResizeType resizeType;
  final String hitText;
  final Color? fillColor;
  final TextStyle? style;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final InputBorder? border;
  final TextEditingController? controller;

  const TolyInputArea({
    super.key,
    this.widthRange = const RangeValues(60, 400),
    this.heightRange = const RangeValues(24, 400),
    this.hitText = 'Please Input',
    this.resizeType = ResizeType.size,
    this.size = const Size(160, 80),
    this.focusedBorder,
    this.enabledBorder,
    this.fillColor,
    this.controller,
    this.border,
    this.style,
  });

  @override
  State<TolyInputArea> createState() => _TolyInputAreaState();
}

class _TolyInputAreaState extends State<TolyInputArea> {
  late double _width = widget.size.width;
  late double _height = widget.size.height;
  final FocusNode _focusNode = FocusNode();
  bool _hovered = false;

  (InputBorder, InputBorder, InputBorder)? defaultInputBorder;

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initDefaultInputBorder();
    _focusNode.addListener(_onFocusChange);
  }

  void _initDefaultInputBorder() {
    double width = 1;
    Color focusedColor = Colors.blue;
    Color unFocusedColor = const Color(0xffd9d9d9);
    OutlineInputBorder focusedBorder = OutlineInputBorder(
        borderSide: BorderSide(
      color: focusedColor,
      width: width,
    ));
    OutlineInputBorder border = OutlineInputBorder(
        borderSide: BorderSide(
      color: unFocusedColor,
      width: width,
    ));
    defaultInputBorder = (
      border,
      focusedBorder,
      border,
    );
  }

  InputBorder? get border {
    if (_hovered) {
      return widget.border ?? defaultInputBorder?.$2;
    }
    return widget.border ?? defaultInputBorder?.$1;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style = widget.style?.copyWith(height: 1) ?? const TextStyle(fontSize: 14, height: 1);
    Color focusedColor = Colors.blue;
    Color unFocusedColor = const Color(0xffd9d9d9);
    return Stack(
      children: [
        SizedBox(
            width: _width,
            height: _height,
            child: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _hovered = true;
                });
              },
              onExit: (_) {
                if (_focusNode.hasFocus) {
                  return;
                }
                setState(() {
                  _hovered = false;
                });
              },
              child: ColoredBox(
                color: widget.fillColor ?? Colors.transparent,
                child: TextField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  cursorHeight: style.fontSize,
                  cursorWidth: 1,
                  style: style,
                  expands: true,
                  maxLines: null,
                  maxLength: null,
                  decoration: InputDecoration(
                    hintText: widget.hitText,
                    hintStyle: style.copyWith(color: unFocusedColor),
                    border: border,
                    focusedBorder: widget.focusedBorder ?? defaultInputBorder?.$2,
                    enabledBorder: border,
                    isCollapsed: true,
                    contentPadding: const EdgeInsets.only(left: 10, top: 12, bottom: 10, right: 6),
                  ),
                ),
              ),
            )),
        Positioned(
          bottom: 0,
          right: 0,
          child: MouseRegion(
            cursor: widget.resizeType.cursor,
            child: GestureDetector(
                onPanUpdate: _onPanUpdate,
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: ResizePainter(),
                    size: const Size(14, 14),
                  ),
                )),
          ),
        ),
      ],
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      if (widget.resizeType.shouldChangeWidth) {
        double newWidth = _width + details.delta.dx;
        _width = newWidth.clamp(widget.widthRange.start, widget.widthRange.end);
      }
      if (widget.resizeType.shouldChangeHeight) {
        double newHeight = _height + details.delta.dy;
        _height = newHeight.clamp(widget.heightRange.start, widget.heightRange.end);
      }
    });
  }

  void _onFocusChange() {
    setState(() {
      _hovered = false;
    });
  }
}

class ResizePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.butt;
    canvas.drawLine(Offset(size.width - 1, size.height * 0.3),
        Offset(size.width * 0.3, size.height - 1), paint);
    canvas.drawLine(Offset(size.width - 1, size.height * 0.6),
        Offset(size.width * 0.6, size.height - 1), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

enum ResizeType {
  width(SystemMouseCursors.resizeLeft),
  height(SystemMouseCursors.resizeDown),
  size(SystemMouseCursors.resizeDownRight),
  ;

  final MouseCursor cursor;

  const ResizeType(this.cursor);

  bool get shouldChangeWidth => this == ResizeType.width || this == ResizeType.size;

  bool get shouldChangeHeight => this == ResizeType.height || this == ResizeType.size;
}
