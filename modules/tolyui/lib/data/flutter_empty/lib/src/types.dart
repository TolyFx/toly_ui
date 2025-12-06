import 'package:flutter/material.dart';

/// Empty 组件的图片类型枚举
enum EmptyImageType {
  /// 默认图片
  defaultImage,
  /// 简单图片
  simple,
}

/// Empty 组件的样式配置
class EmptyStyles {
  const EmptyStyles({
    this.root,
    this.image,
    this.description,
    this.footer,
  });

  final BoxDecoration? root;
  final BoxDecoration? image;
  final TextStyle? description;
  final BoxDecoration? footer;
}

/// Empty 组件的类名配置
class EmptyClassNames {
  const EmptyClassNames({
    this.root,
    this.image,
    this.description,
    this.footer,
  });

  final String? root;
  final String? image;
  final String? description;
  final String? footer;
}