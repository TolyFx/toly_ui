import 'package:flutter/material.dart';

Map<String, dynamic> get dataMenus => {
      'path': '/widgets/data',
      'icon': Icons.data_thresholding_sharp,
      'label': 'Data 数据展示',
      'children': [
        {
          'path': '/avatar',
          'label': 'Avatar',
          'subtitle': '头像',
          'isFlutter': true,
        },
        {
          'path': '/badge',
          'label': 'Badge',
          'subtitle': '头像',
          'isFlutter': true,
          'tag': '新',
        },
        {'path': '/card', 'label': 'Card', 'subtitle': '卡片', 'tag': '新'},
        {
          'path': '/collapse',
          'label': 'Collapse',
          'subtitle': '折叠面板',
          'tag': '新'
          // 'icon': Icons.text_fields,
        },
        {
          'path': '/image',
          'label': 'Image',
          'subtitle': '图片',
          'isFlutter': true,

          // 'icon': Icons.text_fields,
        },
        {
          'path': '/Pagination',
          'label': 'Pagination',
          'subtitle': '分页',
          // 'icon': Icons.text_fields,
        },
        {
          'path': '/Progress',
          'label': 'Progress',
          'subtitle': '进度条',

          // 'icon': Icons.text_fields,
        },
        {
          'path': '/Skeleton',
          'label': 'Skeleton',
          'subtitle': '骨架屏',

          // 'icon': Icons.text_fields,
        },
        {
          'path': '/Tag',
          'label': 'Tag',
          'subtitle': '标签',
          'tag': '新'
          // 'icon': Icons.text_fields,
        },
        {
          'path': '/Tree',
          'label': 'Tree',
          'subtitle': '树形控件',

          // 'icon': Icons.text_fields,
        },
        {
          'path': '/statistics',
          'label': 'Statistics',
          'subtitle': '数据统计',

          // 'icon': Icons.text_fields,
        },
        {
          'path': '/segmented',
          'label': 'Segmented',
          'subtitle': '分段控制器',
          'isFlutter': true,
          'tag': '新'
          // 'icon': Icons.text_fields,
        },
      ]
    };
