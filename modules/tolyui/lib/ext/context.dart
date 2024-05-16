// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-14
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';

extension DarkTheme on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
