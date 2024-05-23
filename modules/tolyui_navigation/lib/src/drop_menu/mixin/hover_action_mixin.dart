// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-19
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

mixin HoverActionMix<T extends StatefulWidget> on State<T> {
  bool _hovered = false;

  bool get hovered => _hovered;

  Widget wrap(Widget child, {MouseCursor? cursor}) {
    return MouseRegion(
      cursor: cursor ?? SystemMouseCursors.click,
      onEnter: _onEnter,
      onExit: _onExit,
      child: child,
    );
  }

  void _onEnter(PointerEnterEvent event) {
    setState(() {
      _hovered = true;
    });
  }

  void _onExit(PointerExitEvent event) {
    setState(() {
      _hovered = false;
    });
  }
}