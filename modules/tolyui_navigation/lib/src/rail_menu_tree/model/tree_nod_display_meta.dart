// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-12
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';

import '../../model/model.dart';


class TreeNodeDisplayMeta {
  final bool selected;
  final bool hovered;
  final Brightness brightness;
  final MenuWidthType widthType;
  final double? anima;

  bool get isDark => brightness == Brightness.dark;
  double get rate => anima??1;
  bool get playing => (anima??0)>0;

  TreeNodeDisplayMeta({
    required this.selected,
    required this.hovered,
    required this.brightness,
    required this.anima,
    required this.widthType,
  });
}

