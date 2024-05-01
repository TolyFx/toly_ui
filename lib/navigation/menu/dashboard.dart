
Map<String, dynamic> get dashboard => {
  'path': '/widgets/dashboard',
  'label': 'Overview 组件总览',

  'children': [
    {
      // 'icon': Icons.home,
      'path': '/overview',
      'label': '组件总览',
    },
    {
      'path': '/statistics',
      'label': '数据统计',
      // 'icon': Icons.collections_bookmark_outlined,
    },
  ],
};