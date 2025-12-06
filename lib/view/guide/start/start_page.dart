// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-14
// Contact Me:  1981462002@qq.com

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toly_ui/view/guide/start/tags_example.dart';

import 'time_line_demo.dart';

class StartUsePage extends StatelessWidget {
  const StartUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(color: Colors.white, child: TagDemo());
    // return Material(color: Colors.white, child: TimelineDemoPage());
  }
}
