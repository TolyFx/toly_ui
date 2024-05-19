// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-19
// Contact Me:  1981462002@qq.com

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:tolyui/tolyui.dart';

sealed class MenuDisplay {
  const MenuDisplay();
}

class ActionMenuDisplay extends MenuDisplay {
  final MenuMeta menu;
  final bool enable;

  final ValueChanged<MenuMeta>? onSelect;

  ActionMenuDisplay(
    this.menu, {
    this.onSelect,
    this.enable = true,
  });

  bool get disable => !enable || onSelect == null;
}

class DividerMenuDisplay extends MenuDisplay {
  final double height;

  const DividerMenuDisplay({
    this.height = 10,
  });
}
