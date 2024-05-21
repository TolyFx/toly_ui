import 'package:flutter/material.dart';

Map<String, dynamic> plckiMenuData = {
  'path': '',
  'label': '',
  'children': [
    {
      'path': '/dashboard',
      'icon': Icons.notes_outlined,
      'label': 'PLCKI 总览',
      'children': [
        {
          'path': '/home',
          'label': '欢迎使用',
        },
        {
          'path': '/language',
          'label': '语言支持',
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
        },
      ],
    },
    {
      'path': '/text',
      'icon': Icons.insights,

      'label': '语法基础',
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
