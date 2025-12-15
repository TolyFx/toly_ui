import 'package:flutter/material.dart';

/// 缺省页类型基类
class DefaultType {
  final String key;
  final IconData? icon;
  final String? imagePath;
  final String title;
  final String description;

  const DefaultType({
    required this.key,
    this.icon,
    this.imagePath,
    required this.title,
    required this.description,
  }) : assert(icon != null || imagePath != null, 'icon or imagePath must be provided');

  /// 空数据
  static const empty = DefaultType(
    key: 'empty',
    icon: Icons.inbox_outlined,
    title: '暂无数据',
    description: '当前列表为空，请添加新的内容',
  );

  /// 搜索无结果
  static const noResult = DefaultType(
    key: 'noResult',
    icon: Icons.search_off,
    title: '未找到相关内容',
    description: '请尝试使用其他关键词搜索',
  );

  /// 网络错误
  static const networkError = DefaultType(
    key: 'networkError',
    icon: Icons.cloud_off_outlined,
    title: '网络连接失败',
    description: '请检查网络设置后重试',
  );

  /// 无权限
  static const noPermission = DefaultType(
    key: 'noPermission',
    icon: Icons.lock_outline,
    title: '暂无访问权限',
    description: '请联系管理员开通权限',
  );

  /// 404 未找到
  static const notFound = DefaultType(
    key: 'notFound',
    icon: Icons.error_outline,
    title: '页面不存在',
    description: '抱歉，您访问的页面不存在',
  );

  /// 服务器错误
  static const serverError = DefaultType(
    key: 'serverError',
    icon: Icons.warning_amber_outlined,
    title: '服务器错误',
    description: '服务器开小差了，请稍后再试',
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DefaultType && runtimeType == other.runtimeType && key == other.key;

  @override
  int get hashCode => key.hashCode;
}
