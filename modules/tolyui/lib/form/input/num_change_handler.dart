// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-08-03
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';

import 'toly_input.dart';

class NumChangeHandler extends StatefulWidget {
  final NumberInput numberInput;
  final TextEditingController controller;
  final double height;

  const NumChangeHandler({
    super.key,
    required this.numberInput,
    required this.controller,
    required this.height,
  });

  @override
  State<NumChangeHandler> createState() => _NumChangeHandlerState();
}

class _NumChangeHandlerState extends State<NumChangeHandler> {
  int _hoverIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            widget.controller.text = widget.numberInput.plus(widget.controller.text);
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) {
              setState(() {
                _hoverIndex = 0;
              });
            },
            onExit: (_) {
              setState(() {
                _hoverIndex = -1;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xffd9d9d9)),
                    right: BorderSide(color: Color(0xffd9d9d9)),
                    bottom: BorderSide(color: Color(0xffd9d9d9)),
                  ),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(4))),
              child: Icon(
                Icons.keyboard_arrow_up,
                size: (widget.height - 3) / 2,
                color: _hoverIndex == 0 ? Colors.blue : null,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            widget.controller.text = widget.numberInput.minus(widget.controller.text);
          },
          child: MouseRegion(
            onEnter: (_) {
              setState(() {
                _hoverIndex = 1;
              });
            },
            onExit: (_) {
              setState(() {
                _hoverIndex = -1;
              });
            },
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffd9d9d9)),
                    right: BorderSide(color: Color(0xffd9d9d9)),
                  ),
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(4))),
              child: Icon(
                Icons.keyboard_arrow_down,
                size: (widget.height - 3) / 2,
                color: _hoverIndex == 1 ? Colors.blue : null,
              ),
            ),
          ),
        )
      ],
    );
  }
}
