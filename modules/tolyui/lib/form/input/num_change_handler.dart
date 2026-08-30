// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-08-03
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';

import 'attributes/attributes.dart';
import 'toly_input.dart';

class NumChangeHandler extends StatefulWidget {
  final NumberInput numberInput;
  final TextEditingController controller;
  final double height;
  final ValueChanged<String>? onChanged;

  const NumChangeHandler({
    super.key,
    required this.numberInput,
    required this.controller,
    required this.height,
    this.onChanged,
  });

  @override
  State<NumChangeHandler> createState() => _NumChangeHandlerState();
}

class _NumChangeHandlerState extends State<NumChangeHandler> {
  int _hoverIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.numberInput.controlLayout == NumberControlLayout.horizontal) {
      return Row(
        children: <Widget>[
          _buildHorizontalButton(
            index: 1,
            icon: Icons.remove,
            onTap: _decrease,
          ),
          _buildHorizontalButton(
            index: 0,
            icon: Icons.add,
            onTap: _increase,
            isLast: true,
          ),
        ],
      );
    }
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _increase();
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
                borderRadius: BorderRadius.only(topRight: Radius.circular(4)),
              ),
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
            _decrease();
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
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Icon(
                Icons.keyboard_arrow_down,
                size: (widget.height - 3) / 2,
                color: _hoverIndex == 1 ? Colors.blue : null,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHorizontalButton({
    required int index,
    required IconData icon,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final bool hovered = _hoverIndex == index;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoverIndex = index),
      onExit: (_) => setState(() => _hoverIndex = -1),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: widget.height,
          height: widget.height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: hovered
                ? colors.onSurface.withValues(alpha: 0.07)
                : Colors.transparent,
            border: Border(
              top: BorderSide(color: colors.outlineVariant),
              right: BorderSide(color: colors.outlineVariant),
              bottom: BorderSide(color: colors.outlineVariant),
            ),
            borderRadius: isLast
                ? const BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  )
                : null,
          ),
          child: Icon(icon, size: 16),
        ),
      ),
    );
  }

  void _increase() {
    _setValue(widget.numberInput.plus(widget.controller.text));
  }

  void _decrease() {
    _setValue(widget.numberInput.minus(widget.controller.text));
  }

  void _setValue(String value) {
    widget.controller.value = widget.controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
    widget.onChanged?.call(value);
  }
}
