import 'package:flutter/widgets.dart';

/// 菜单动作被执行时的回调。
typedef TolyMenuAction = void Function();

/// 菜单树中的基础条目。
@immutable
sealed class TolyMenuEntry {
  /// 条目的稳定标识。
  final String id;

  const TolyMenuEntry({required this.id});
}

/// 可执行或包含子菜单的菜单条目。
final class TolyMenuItem extends TolyMenuEntry {
  /// 展示名称。
  final String label;

  /// 名称左侧的自定义组件。
  final Widget? leading;

  /// 名称右侧、展开箭头之前的自定义组件。
  final Widget? trailing;

  /// 快捷键提示文本。
  final String? shortcut;

  /// 条目是否允许交互。
  final bool enabled;

  /// 条目是否处于选中状态。
  final bool checked;

  /// 子菜单条目。
  final List<TolyMenuEntry> children;

  /// 叶子条目被执行时的回调。
  final TolyMenuAction? onSelected;

  const TolyMenuItem({
    required super.id,
    required this.label,
    this.leading,
    this.trailing,
    this.shortcut,
    this.enabled = true,
    this.checked = false,
    this.children = const <TolyMenuEntry>[],
    this.onSelected,
  });

  /// 当前条目是否包含下一级菜单。
  bool get hasChildren => children.isNotEmpty;
}

/// 菜单条目之间的分隔线。
final class TolyMenuDivider extends TolyMenuEntry {
  const TolyMenuDivider({required super.id});
}

/// 顶部菜单栏中的一个菜单组。
@immutable
final class TolyMenuGroup {
  /// 菜单组的稳定标识。
  final String id;

  /// 菜单栏展示名称。
  final String label;

  /// 菜单组包含的根条目。
  final List<TolyMenuEntry> entries;

  const TolyMenuGroup({
    required this.id,
    required this.label,
    required this.entries,
  });
}
