import 'package:flutter/material.dart';
// import 'package:iroute/app/res/fx_icon.dart';

Map<String, dynamic> get formMenus => {
  'path': '/form',
  // 'icon': FxIcon.icon_paint,
  'label': 'Form 表单组件',
  'children': [
    {
      'path': '/Autocomplete',
      'label': 'Autocomplete 自动补全',
      // 'icon': Icons.calculate_outlined,
    },
    {
      'path': '/ColorPicker',
      'label': 'ColorPicker 取色器',
    },    {
      'path': '/DatePicker',
      'label': 'DatePicker 日期选择器',
    },
    // {
    //   'path': '/parser',
    //   'label': '文字解析器',
    //   'icon': Icons.text_fields,
    // },
  ]
};
