import 'package:flutter/material.dart';

Map<String, dynamic> get navigationMenus => {
      'path': '/widgets/navigation',
      // 'icon': FxIcon.icon_paint,
'tag' :'新',
  'icon':Icons.navigation_sharp,

      'label': 'Navigation 导航',
      'children': [

        {
          'path': '/Anchor',
          'label': 'Anchor',
          'subtitle': '锚点',
          // 'icon': Icons.text_fields,
        },
        {
          'path': '/Breadcrumb',
          'label': 'Breadcrumb',
          'subtitle': '面包屑',

          // 'icon': Icons.text_fields,
        },
        {
          'path': '/drop_menu',
          'label': 'DropMenu',
          'subtitle': '下拉菜单',
          'tag' :'新'
          // 'icon': Icons.text_fields,
        },
        {
          'path': '/rail_menu_tree',
          'label': 'RailMenuTree',
          'subtitle': '树形菜单',
          'tag' :'新'


          // 'icon': Icons.text_fields,
        },
        {
          'path': '/rail_menu_bar',
          'label': 'RailMenuBar',
          'subtitle': '侧栏菜单',

          // 'icon': Icons.text_fields,
        },
        {
          'path': '/Tabs',
          'label': 'Tabs',
          'subtitle': '标签页',
          // 'icon': Icons.text_fields,
        },
        {
          'path': '/Steps',
          'label': 'Steps',
          'subtitle': '步骤条',

          // 'icon': Icons.text_fields,
        },
      ]
    };
