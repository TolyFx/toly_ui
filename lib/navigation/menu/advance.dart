import 'package:flutter/material.dart';

Map<String, dynamic> get advanceMenus => {
      'path': '/widgets/advance',
      'icon': Icons.palette,
      'label': 'Advance 高级组件',
      'children': [
        {
          'path': '/color',
          'label': 'Color',
          'subtitle': '调色板',
          'tag': '新',
        },
      ]
    };
