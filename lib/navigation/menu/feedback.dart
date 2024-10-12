import 'package:flutter/material.dart';

Map<String, dynamic> get feedbackMenus => {
      'path': '/widgets/feedback',
      'icon': Icons.feedback,
      'label': 'Feedback 反馈组件',
      'children': [
        {
          'path': '/message',
          'label': 'Message',
          'subtitle': '消息提示'
          // 'icon': Icons.calculate_outlined,
        },
        {
          'path': '/notification',
          'label': 'Notification  通知',
          'subtitle': '消息提示'

          // 'icon': Icons.calculate_outlined,
        },
        {
          'path': '/loading',
          'label': 'Loading',
          'tag': '新',
          'subtitle': '加载'

          // 'icon': Icons.calculate_outlined,
        },
        {
          'path': '/popover',
          'label': 'Popover',
          'subtitle': '弹出框'

          // 'icon': Icons.calculate_outlined,
        },
        {
          'path': '/shortcuts',
          'label': 'Shortcuts',
          'tag': '新',
          'isFlutter': true,
          'subtitle': '快捷键'

        },
        {
          'path': '/tooltip',
          'label': 'Tooltip',
          'subtitle': '文字提示'

        },
      ]
    };
