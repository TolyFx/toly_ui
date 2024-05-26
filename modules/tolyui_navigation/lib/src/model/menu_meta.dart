// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-12
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';

abstract class MenuMateExt{
  const MenuMateExt();

  T? me<T extends MenuMateExt>(){
    if(this is T){
      return this as T;
    }
    return null;
  }
}

class MenuMeta implements Identify<String>{
  final String router;
  final String label;
  final IconData? icon;
  final MenuMateExt? ext;

  const MenuMeta({
    this.router = '',
    required this.label,
    this.icon,
    this.ext,
  });

  @override
  String toString() {
    return 'MenuMeta{router: $router, label: $label, icon: $icon}';
  }

  bool get enable => router.isNotEmpty;

  @override
  String get id => router;
}

abstract interface class Identify<T> {
  T get id;
}
