import 'package:flutter/foundation.dart';

import '../model/toly_menu_entry.dart';

/// 菜单控制器打开状态变化时的回调。
typedef TolyMenuOpenChanged = void Function(bool open);

/// 统一维护整棵级联菜单的打开状态、活动项和展开路径。
final class TolyMenuController extends ChangeNotifier {
  /// 当前菜单是否打开。
  bool _isOpen = false;

  /// 每一层当前活动条目的索引。
  final List<int> _activePath = <int>[];

  /// 当前展开到的子菜单索引路径。
  final List<int> _expandedPath = <int>[];

  /// 菜单打开状态发生变化时的可选回调。
  final TolyMenuOpenChanged? onOpenChanged;

  TolyMenuController({this.onOpenChanged});

  /// 当前菜单是否打开。
  bool get isOpen => _isOpen;

  /// 当前活动路径的只读快照。
  List<int> get activePath => List<int>.unmodifiable(_activePath);

  /// 当前展开路径的只读快照。
  List<int> get expandedPath => List<int>.unmodifiable(_expandedPath);

  /// 打开整组菜单。
  void open() {
    if (_isOpen) return;
    _isOpen = true;
    onOpenChanged?.call(true);
    notifyListeners();
  }

  /// 关闭整组菜单并清空临时交互状态。
  void close() {
    if (!_isOpen && _activePath.isEmpty && _expandedPath.isEmpty) return;
    _isOpen = false;
    _activePath.clear();
    _expandedPath.clear();
    onOpenChanged?.call(false);
    notifyListeners();
  }

  /// 激活指定层级的条目，并按需展开它的子菜单。
  void activate({
    required int depth,
    required int index,
    required bool expandable,
  }) {
    _replacePathValue(_activePath, depth, index);
    if (expandable) {
      _replacePathValue(_expandedPath, depth, index);
    } else if (_expandedPath.length > depth) {
      _expandedPath.removeRange(depth, _expandedPath.length);
    }
    notifyListeners();
  }

  /// 返回指定层级当前活动条目的索引。
  int? activeIndexAt(int depth) {
    return depth < _activePath.length ? _activePath[depth] : null;
  }

  /// 返回指定层级当前展开条目的索引。
  int? expandedIndexAt(int depth) {
    return depth < _expandedPath.length ? _expandedPath[depth] : null;
  }

  /// 在指定层级的可交互条目之间循环移动活动位置。
  void move({
    required int depth,
    required List<TolyMenuEntry> entries,
    required int delta,
  }) {
    final List<int> enabledIndices = <int>[];
    for (int index = 0; index < entries.length; index += 1) {
      final TolyMenuEntry entry = entries[index];
      if (entry is TolyMenuItem && entry.enabled) enabledIndices.add(index);
    }
    if (enabledIndices.isEmpty) return;
    final int? current = activeIndexAt(depth);
    if (current == null) {
      final int initialIndex =
          delta < 0 ? enabledIndices.last : enabledIndices.first;
      final TolyMenuItem initial = entries[initialIndex] as TolyMenuItem;
      activate(
        depth: depth,
        index: initialIndex,
        expandable: initial.hasChildren,
      );
      return;
    }
    int position = enabledIndices.indexOf(current);
    if (position < 0) position = 0;
    position = (position + delta) % enabledIndices.length;
    if (position < 0) position += enabledIndices.length;
    final int nextIndex = enabledIndices[position];
    final TolyMenuItem next = entries[nextIndex] as TolyMenuItem;
    activate(depth: depth, index: nextIndex, expandable: next.hasChildren);
  }

  /// 将路径指定深度替换为新值，并裁剪更深层的旧状态。
  void _replacePathValue(List<int> path, int depth, int value) {
    if (path.length > depth) {
      path[depth] = value;
      if (path.length > depth + 1) {
        path.removeRange(depth + 1, path.length);
      }
      return;
    }
    while (path.length < depth) {
      path.add(0);
    }
    path.add(value);
  }
}
