import 'package:flutter/material.dart';

Map<String, dynamic> get feedbackMenus => {
      'path': '/widgets/feedback',
      'icon': Icons.feedback,
      'label': 'Feedback 反馈组件',
      'children': [
        {
          'path': '/message',
          'label': 'Message 消息提示',
          // 'icon': Icons.calculate_outlined,
        },
        {
          'path': '/notification',
          'label': 'Notification  通知',
          // 'icon': Icons.calculate_outlined,
        },
        {
          'path': '/loading',
          'label': 'Loading 加载',
          'tag': '新',
          // 'icon': Icons.calculate_outlined,
        },
        {
          'path': '/popover',
          'label': 'Popover 弹出框',
          // 'icon': Icons.calculate_outlined,
        },
        {
          'path': '/shortcuts',
          'label': 'Shortcuts 快捷键',
          'tag': '新',
          'isFlutter': true,
        },
        {
          'path': '/tooltip',
          'label': 'Tooltip 文字提示',
        },
      ]
    };
