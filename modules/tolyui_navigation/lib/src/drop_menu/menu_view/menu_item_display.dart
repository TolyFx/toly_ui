// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-19
// Contact Me:  1981462002@qq.com

import '../../model/model.dart';

sealed class MenuDisplay {
  const MenuDisplay();
}

class ActionMenu extends MenuDisplay {
  final MenuMeta menu;
  final bool enable;
  final bool active;

  ActionMenu(
    this.menu, {
    this.enable = true,
    this.active = false,
  });

  bool get disable => !enable;
}

class SubMenu extends MenuDisplay {
  final List<MenuDisplay> menus;
  final MenuMeta menu;
  final bool enable;

  SubMenu(
    this.menu, {
    this.enable = true,
    required this.menus,
  });

  bool get disable => !enable;
}

class DividerMenu extends MenuDisplay {
  final double height;

  const DividerMenu({
    this.height = 10,
  });
}
