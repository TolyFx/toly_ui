import 'package:flutter/material.dart';

/// Timeline 模式
enum TimelineMode {
  /// 左侧显示
  start,
  /// 右侧显示
  end,
  /// 交替显示
  alternate,
}

/// Timeline 方向
enum TimelineOrientation {
  /// 垂直方向
  vertical,
  /// 水平方向
  horizontal,
}

/// Timeline 变体
enum TimelineVariant {
  /// 轮廓样式
  outlined,
  /// 填充样式
  filled,
}

/// Timeline 项目状态
enum TimelineItemStatus {
  /// 完成状态
  finish,
  /// 进行中状态
  process,
  /// 等待状态
  wait,
  /// 错误状态
  error,
}

/// Timeline 项目配置
class TimelineItemType {
  const TimelineItemType({
    this.key,
    this.title,
    this.content,
    this.color,
    this.icon,
    this.loading = false,
    this.className,
    this.style,
    this.placement,
  });

  /// 唯一标识
  final Key? key;
  
  /// 标题
  final Widget? title;
  
  /// 内容
  final Widget? content;
  
  /// 颜色
  final Color? color;
  
  /// 图标
  final Widget? icon;
  
  /// 是否加载中
  final bool loading;
  
  /// 类名（保持 API 一致性）
  final String? className;
  
  /// 样式
  final BoxDecoration? style;
  
  /// 位置
  final TimelineMode? placement;
}

/// Timeline 样式配置
class TimelineStyles {
  const TimelineStyles({
    this.root,
    this.item,
    this.itemTitle,
    this.itemIcon,
    this.itemContent,
    this.itemRail,
  });

  final BoxDecoration? root;
  final BoxDecoration? item;
  final TextStyle? itemTitle;
  final BoxDecoration? itemIcon;
  final BoxDecoration? itemContent;
  final BoxDecoration? itemRail;
}

/// Timeline 类名配置
class TimelineClassNames {
  const TimelineClassNames({
    this.root,
    this.item,
    this.itemTitle,
    this.itemIcon,
    this.itemContent,
    this.itemRail,
  });

  final String? root;
  final String? item;
  final String? itemTitle;
  final String? itemIcon;
  final String? itemContent;
  final String? itemRail;
}