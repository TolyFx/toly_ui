// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-16
// Contact Me:  1981462002@qq.com

import 'advance.dart';
import 'basic.dart';
import 'dashboard.dart';
import 'data.dart';
import 'feedback.dart';
import 'form.dart';
import 'navigation.dart';

Map<String, dynamic> get widgetMenus => {
      'path': '',
      'label': '',
      'children': [
        dashboard,
        basicMenus,
        formMenus,
        navigationMenus,
        dataMenus,
        advanceMenus,
        feedbackMenus,
      ],
    };
