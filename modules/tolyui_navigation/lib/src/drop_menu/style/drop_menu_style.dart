// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-22
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';

class DropMenuCellStyle {
  final Color backgroundColor;
  final Color disableColor;
  final Color foregroundColor;
  final Color hoverForegroundColor;
  final Color hoverBackgroundColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const DropMenuCellStyle({
    required this.backgroundColor,
    required this.disableColor,
    required this.foregroundColor,
    required this.hoverForegroundColor,
    required this.hoverBackgroundColor,
    this.padding,
    this.borderRadius,
  });

  factory DropMenuCellStyle.light() => const DropMenuCellStyle(
    foregroundColor: Color(0xff1f1f1f),
    backgroundColor: Colors.transparent,
    disableColor: Color(0xffbfbfbf),
    hoverBackgroundColor: Color(0xffe6f7ff),
    hoverForegroundColor: Color(0xff1f1f1f),
  );

  factory DropMenuCellStyle.dark() => const DropMenuCellStyle(
    foregroundColor: Color(0xffcfd3dc),
    backgroundColor: Colors.transparent,
    hoverBackgroundColor: Color(0xff18222c),
    disableColor: Color(0xffbfbfbf),
    hoverForegroundColor: Color(0xffe6f7ff),
  );
}
