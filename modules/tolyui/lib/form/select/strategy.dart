// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-06-30
// Contact Me:  1981462002@qq.com

sealed class WidthStrategy {
  final double min;
  final double max;

  const WidthStrategy({
    required this.min,
    required this.max,
  });
}

class FixStrategy extends WidthStrategy {
  final double width;

  FixStrategy(this.width, {required super.min, required super.max});
}

class ShrinkStrategy extends WidthStrategy {
  ShrinkStrategy({required super.min, required super.max});
}