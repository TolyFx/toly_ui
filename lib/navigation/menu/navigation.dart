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
          'path': '/breadcrumb',
          'label': 'Breadcrumb',
          'subtitle': '面包屑',
          'tag' :'新'
        },
        {
          'path': '/drop_menu',
          'label': 'DropMenu',
          'subtitle': '下拉菜单',
          // 'icon': Icons.text_fields,
        },
        {
          'path': '/rail_menu_tree',
          'label': 'RailMenuTree',
          'subtitle': '树形菜单',


          // 'icon': Icons.text_fields,
        },
        {
          'path': '/rail_menu_bar',
          'label': 'RailMenuBar',
          'subtitle': '侧栏菜单',

          // 'icon': Icons.text_fields,
        },
        {
          'path': '/tabs',
          'label': 'Tabs',
          'subtitle': '标签页',
          'tag' :'新'

        },
        {
          'path': '/Steps',
          'label': 'Steps',
          'subtitle': '步骤条',
        },
      ]
    };
