import 'package:flutter/widgets.dart';

/// 类型动作选择器的一项类型与动作配置。
@immutable
class TolyTypeActionOption<T extends Object> {
  /// 稳定且唯一的类型值。
  final T value;

  /// 类型显示名称。
  final String label;

  /// 类型对应的纯图标动作。
  final Widget actionIcon;

  /// 动作提示及无障碍名称。
  final String actionLabel;

  /// 当前类型是否可以选择和执行。
  final bool enabled;

  const TolyTypeActionOption({
    required this.value,
    required this.label,
    required this.actionIcon,
    required this.actionLabel,
    this.enabled = true,
  });
}
