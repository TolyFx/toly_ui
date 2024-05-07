
Map<String, dynamic> get feedbackMenus => {
  'path': '/widgets/feedback',
  // 'icon': FxIcon.icon_paint,
  'label': 'Feedback 反馈组件',
  'children': [
    {
      'path': '/popover',
      'label': 'Popover 弹出框',
      // 'icon': Icons.calculate_outlined,
    },
    {
      'path': '/tooltip',
      'label': 'Tooltip 文字提示',
    },
  ]
};
