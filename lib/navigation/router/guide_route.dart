// Copyright 2014 The 张风捷特烈 . All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Author:      张风捷特烈
// CreateTime:  2024-05-14
// Contact Me:  1981462002@qq.com

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../view/guide/guide_page.dart';
import '../../view/guide/modules_tree/modules_tree.dart';
import '../../view/guide/principle/principle.dart';
import '../../view/guide/start/start_page.dart';
import '../../view/guide/update_log/update_log.dart';
import 'transition/page_route/zero_page_route.dart';

RouteBase get guideRoute => ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return GuideNavigation(
          child: child,
        );
      },
      routes: [
        GoRoute(path: 'guide', redirect: _guideRedirect, routes: [
          GoRoute(
            path: 'start',
            pageBuilder: (_, state) {
              return ZeroPage(key: state.pageKey, child: StartUsePage());
            },
          ),
          GoRoute(
            path: 'modules',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return ZeroPage(key: state.pageKey, child: ModulesTreePage());
            },
          ),
          GoRoute(
            path: 'principle',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return ZeroPage(key: state.pageKey, child: PrinciplePage());
            },
          ),
          GoRoute(
            path: 'update_log',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return ZeroPage(key: state.pageKey, child: UpdateLogPage());
            },
          ),
        ]),
      ],
    );

String? _guideRedirect(_, state) {
  if (state.fullPath == '/guide') {
    return '/guide/start';
  }
  return null;
}
