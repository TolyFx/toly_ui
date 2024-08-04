// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-08-05
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';

import 'num_change_handler.dart';

sealed class InputType {}

class NumberInput extends InputType {
  final num step;
  final num min;
  final num? max;
  final num? errorDefault;

  NumberInput({
    this.step = 1,
    this.min = 0,
    this.max,
    this.errorDefault = 0,
  });

  String plus(String value) {
    num count = num.tryParse(value) ?? errorDefault ?? 0;
    return (count + step).clamp(min, max ?? 99999999).toString();
  }

  String minus(String value) {
    num count = num.tryParse(value) ?? errorDefault ?? 0;
    return (count - step).clamp(min, max ?? 99999999).toString();
  }
}

class TolyInput extends StatelessWidget {
  final Widget? leading;
  final Widget? tailing;
  final String? hintText;
  final VoidCallback? onClickTailing;
  final TextEditingController controller;
  final InputType? type;
  final String? unit;

  const TolyInput({
    super.key,
    this.leading,
    this.hintText,
    required this.controller,
    this.tailing,
    this.onClickTailing,
    this.type,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    double height = 32;
    Color unFocusedColor = const Color(0xffd9d9d9);
    Widget child = _buildTextFile(height);

    if (type is NumberInput) {
      child = Row(
        children: [
          Expanded(child: child),
          NumChangeHandler(
            numberInput: type as NumberInput,
            controller: controller,
            height: height,
          )
        ],
      );
    }

    if (leading == null && tailing == null) return child;

    List<Widget> children = [Expanded(child: child)];
    if (leading != null) {
      children.insert(
          0,
          Container(
            height: 32,
            // width: 70,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: const Color(0xfff5f7fa),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
                border: Border(
                  top: BorderSide(color: unFocusedColor),
                  left: BorderSide(color: unFocusedColor),
                  bottom: BorderSide(color: unFocusedColor),
                  // right: BorderSide(),
                )),

            child: Center(child: leading!),
          ));
    }
    if (tailing != null) {
      children.add(GestureDetector(
        onTap: onClickTailing,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            height: 32,
            // width: 70,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: const Color(0xfff5f7fa),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
                border: Border(
                  top: BorderSide(color: unFocusedColor),
                  right: BorderSide(color: unFocusedColor),
                  bottom: BorderSide(color: unFocusedColor),
                  // right: BorderSide(),
                )),

            child: Center(child: tailing),
          ),
        ),
      ));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  OutlineInputBorder? focusedBorder(bool hasLeading, bool hasTailing, bool focused) {
    Color unFocusedColor = const Color(0xffd9d9d9);

    Color focusedColor = focused ? Colors.blue : unFocusedColor;
    double borderWidth = 1;

    if (hasTailing && hasLeading) {
      return OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: focusedColor, width: borderWidth));
    }

    if (hasLeading) {
      return OutlineInputBorder(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(4),
            bottomRight: Radius.circular(4),
          ),
          borderSide: BorderSide(color: focusedColor, width: borderWidth));
    }
    if (hasTailing) {
      return OutlineInputBorder(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            bottomLeft: Radius.circular(4),
          ),
          borderSide: BorderSide(color: focusedColor, width: borderWidth));
    }
    return OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
        borderSide: BorderSide(color: focusedColor, width: borderWidth));
  }

  Widget _buildTextFile(double height) {
    TextStyle style = const TextStyle(fontSize: 14, height: 1);
    Color focusedColor = Colors.blue;
    double borderWidth = 1;
    bool hasLeading = leading != null;
    bool hasTailing = tailing != null || type is NumberInput;
    Color unFocusedColor = const Color(0xffd9d9d9);

    return TextField(
      cursorHeight: style.fontSize,
      cursorWidth: 1,
      controller: controller,
      style: style,
      decoration: InputDecoration(
        // isDense: true,
        hintText: hintText,
        suffix: unit != null ? Text(unit!) : null,
        hintStyle: style.copyWith(color: unFocusedColor),
        constraints: BoxConstraints.tight(Size(0, height)),
        // contentPadding: EdgeInsets.only(top: 8),
        contentPadding: const EdgeInsets.only(top: 0, right: 12, left: 12),
        focusedBorder: focusedBorder(hasLeading, hasTailing, true),
        enabledBorder: focusedBorder(hasLeading, hasTailing, false),
        hoverColor: focusedColor,
        border: focusedBorder(hasLeading, hasTailing, false),
      ),
    );
  }
}