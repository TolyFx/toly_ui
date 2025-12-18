import 'package:flutter/material.dart';

Map<String, dynamic> get advancedMenus => {
      'path': '/widgets/advanced',
      'icon': Icons.data_exploration_rounded,
      'label': 'Advanced 高级',
      'children': [
        {
          'path': '/color',
          'label': 'Color',
          'subtitle': '调色板',
          'tag': '新',
        },
        {
          'path': '/device_frame',
          'label': 'DeviceFrame',
          'subtitle': '设备外观',
          'tag': '新'
        },
      ]
    };
