import 'package:flutter/material.dart';

Map<String, dynamic> get plckiMenuDataPlus => {
      'path': '',
      'label': '',
      'children': [
        {
          'path': '/dashboard',
          'icon': Icons.notes_outlined,
          'label': 'PLCKI 总览',
          'subtitle': '编程语言通用知识手册',
          'children': [
            {
              'path': '/home',
              'label': '欢迎使用',
              'subtitle': '开启你的编程之旅',
            },
            {
              'path': '/language',
              'label': '语言支持',
              'subtitle': '各大编程语言',
              'children': [
                {
                  'path': '/rust',
                  'label': 'Rust 语言',
                },
                {
                  'path': '/dart',
                  'label': 'Dart 语言',
                },
                {
                  'path': '/cpp',
                  'label': 'C++ 语言',
                },
                {
                  'path': '/java',
                  'label': 'Java 语言',
                },
                {
                  'path': '/kotlin',
                  'label': 'Kotlin 语言',
                },
                {
                  'path': '/python',
                  'label': 'Python 语言',
                },
              ]
            },
            {
              'path': '/collect',
              'label': '数据统计',
              'subtitle': '接口统计信息',
            },
          ],
        },
        {
          'path': '/text',
          // 'icon': FxIcon.icon_paint,
          'icon': Icons.insights,
          'label': '语法基础',
          'subtitle': '编程应用基础语法',
          'tag': '新',
          'children': [
            {
              'path': '/gen',
              'label': '量与定义',
            },
            {
              'path': '/parser',
              'label': '数据类型',
            },
            {
              'path': '/function',
              'label': '函数封装',
              'tag':'42'
            },
            {
              'path': '/ctrl',
              'label': '流程控制',
            },
          ]
        },
        {
          'path': '/struct',
          'icon': Icons.stadium_outlined,
          'label': '结构化',
          'subtitle': '组织数据类型化',
          'children': [
            {
              'path': '/class',
              'label': '结构/类型',
            },
            {
              'path': '/enum',
              'label': '枚举支持',
            },
            {
              'path': '/gen',
              'label': '泛型支持',
            },
            {
              'path': '/inherit',
              'label': '继承/组合',
            },
          ]
        },
        {
          'path': '/data',
          'icon': Icons.dashboard_outlined,
          'label': '数据结构',
          'subtitle': '数据的经典组织形式',
          'children': [
            {
              'path': '/list',
              'label': '列表/数组',
            },
            {
              'path': '/map',
              'label': '映射/字典',
            },
            {
              'path': '/set',
              'label': '集合结构',
            },
          ]
        },
        {
          'path': '/calc',
          'icon': Icons.calculate_outlined,
          'label': '语言能力',
          'subtitle': '编程语言能提供的功能',
          'children': [
            {
              'path': '/calculator',
              'label': '日期时间',
            },
            {
              'path': '/random',
              'label': '随机数',
            },
            {
              'path': '/date',
              'label': '序列/反序列化',
            },
          ]
        }
      ]
    };
