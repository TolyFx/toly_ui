
// import '../../../app/res/fx_icon.dart';

import 'package:flutter/material.dart';

Map<String, dynamic> get dashboard => {
  'path': '/dashboard',
  'label': 'Overview 组件总览',

  'children': [
    {
      // 'icon': Icons.home,
      'path': '/home',
      'label': '组件总览',
    },
    {
      'path': '/collect',
      'label': '数据统计',
      // 'icon': Icons.collections_bookmark_outlined,
    },
  ],
};