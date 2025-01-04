import 'package:flutter/material.dart';

Map<String, dynamic> get formMenus => {
      'path': '/widgets/form',
      // 'icon': FxIcon.icon_paint,
      'icon': Icons.calculate_rounded,
  'tag': '新',

      'label': 'Form 表单组件',
      'children': [
        {
          'path': '/autocomplete',
          'label': 'Autocomplete',
          'subtitle': '自动补全',
          // 'icon': Icons.calculate_outlined,
        },
        {
          'path': '/ColorPicker',
          'label': 'ColorPicker',
          'subtitle': '取色器',
        },
        {
          'path': '/checkbox',
          'label': 'Checkbox',
          'subtitle': '多选框',
        },
        {
          'path': '/date_picker',
          'label': 'DatePicker',
          'subtitle': '日期选择器',
        },
        {
          'path': '/input',
          'label': 'Input',
          'subtitle': '输入框',
        },
        {
          'path': '/select',
          'label': 'Select',
          'subtitle': '选择器',
          'tag': '新',
          // 'icon': Icons.text_fields,
        },
        {
          'path': '/transfer',
          'label': 'Transfer',
          'subtitle': '穿梭框',
          'tag': '新',
          // 'icon': Icons.text_fields,
        },
      ]
    };
