
import 'package:flutter/material.dart';

Map<String, dynamic> get basicMenus => {
  'path': '/widgets/basic',
  'icon':Icons.calendar_view_day_rounded,

  'label': 'Basic 基础组件',
  'children': [
    {
      'path': '/button',
      'label': 'Button',
      'subtitle': '按钮',
      'isFlutter': true,
      // 'icon': Icons.text_fields,
    },
    {
      'path': '/icon',
      'label': 'Icon',
      'isFlutter': true,
      'subtitle': '图标'
      // 'icon': Icons.text_fields,
    },
    {
      'path': '/text',
      'label': 'Text',
      'isFlutter': true,
      'subtitle': '文本'
      // 'icon': Icons.text_fields,
    },   {
      'path': '/layout',
      'label': 'Layout',
      'subtitle': '布局',
      // 'icon': Icons.text_fields,
    },
    {
      'path': '/link',
      'label': 'Link',
      'subtitle': '链接',
      // 'icon': Icons.text_fields,
    },
  ]
};
