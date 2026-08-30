import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controller/toly_menu_controller.dart';
import '../model/toly_menu_entry.dart';
import '../theme/toly_menu_theme.dart';

/// 菜单叶子条目被选中时的回调。
typedef TolyMenuItemSelected = void Function(TolyMenuItem item);

/// 在同一个 Overlay 中绘制完整级联路径的菜单表面。
final class TolyMenuSurface extends StatefulWidget {
  /// 根菜单条目。
  final List<TolyMenuEntry> entries;

  /// 整组菜单共用的控制器。
  final TolyMenuController controller;

  /// 叶子条目被选中时的回调。
  final TolyMenuItemSelected? onSelected;

  const TolyMenuSurface({
    super.key,
    required this.entries,
    required this.controller,
    this.onSelected,
  });

  @override
  State<TolyMenuSurface> createState() => _TolyMenuSurfaceState();
}

final class _TolyMenuSurfaceState extends State<TolyMenuSurface> {
  /// 键盘导航使用的焦点节点。
  final FocusNode _focusNode = FocusNode(debugLabel: 'TolyMenuSurface');

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: _buildAnimatedSurface,
    );
  }

  Widget _buildAnimatedSurface(BuildContext context, Widget? child) {
    final List<List<TolyMenuEntry>> levels = _visibleLevels();
    return Focus(
      autofocus: true,
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Material(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: List<Widget>.generate(
            levels.length,
            (int depth) => _buildLevel(levels[depth], depth),
          ),
        ),
      ),
    );
  }

  /// 根据控制器的展开路径生成当前可见的全部菜单层级。
  List<List<TolyMenuEntry>> _visibleLevels() {
    final List<List<TolyMenuEntry>> levels = <List<TolyMenuEntry>>[
      widget.entries,
    ];
    List<TolyMenuEntry> current = widget.entries;
    for (int depth = 0;
        depth < widget.controller.expandedPath.length;
        depth += 1) {
      final int index = widget.controller.expandedPath[depth];
      if (index < 0 || index >= current.length) break;
      final TolyMenuEntry entry = current[index];
      if (entry is! TolyMenuItem || !entry.enabled || !entry.hasChildren) break;
      current = entry.children;
      levels.add(current);
    }
    return levels;
  }

  Widget _buildLevel(List<TolyMenuEntry> entries, int depth) {
    final TolyMenuThemeData theme = context.tolyMenuTheme;
    return Padding(
      padding: EdgeInsets.only(left: depth == 0 ? 0 : theme.submenuGap),
      child: Material(
        key: ValueKey<String>('toly-menu-level-$depth'),
        color: theme.backgroundColor,
        elevation: theme.elevation,
        shadowColor: theme.shadowColor,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: theme.borderRadius,
          side: BorderSide(
            color: theme.borderColor,
            width: theme.borderWidth,
          ),
        ),
        child: SizedBox(
          width: theme.panelWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.generate(
                entries.length,
                (int index) => _buildEntry(entries[index], depth, index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEntry(TolyMenuEntry entry, int depth, int index) {
    if (entry is TolyMenuDivider) {
      return const Divider(height: 9, indent: 6, endIndent: 6);
    }
    return _TolyMenuRow(
      key: ValueKey<String>(entry.id),
      item: entry as TolyMenuItem,
      active: widget.controller.activeIndexAt(depth) == index,
      onEntered: () => _activate(entry, depth, index),
      onPressed: () => _select(entry, depth, index),
    );
  }

  void _activate(TolyMenuItem item, int depth, int index) {
    if (!item.enabled) return;
    widget.controller.activate(
      depth: depth,
      index: index,
      expandable: item.hasChildren,
    );
  }

  void _select(TolyMenuItem item, int depth, int index) {
    if (!item.enabled) return;
    _activate(item, depth, index);
    if (item.hasChildren) return;
    item.onSelected?.call();
    widget.onSelected?.call(item);
    widget.controller.close();
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final List<List<TolyMenuEntry>> levels = _visibleLevels();
    final int depth = levels.length - 1;
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      widget.controller.close();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      widget.controller.move(depth: depth, entries: levels.last, delta: 1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      widget.controller.move(depth: depth, entries: levels.last, delta: -1);
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft && depth > 0) {
      final int parentIndex = widget.controller.expandedPath[depth - 1];
      widget.controller.activate(
        depth: depth - 1,
        index: parentIndex,
        expandable: false,
      );
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.space ||
        event.logicalKey == LogicalKeyboardKey.arrowRight) {
      final int? index = widget.controller.activeIndexAt(depth);
      if (index == null || index >= levels.last.length) {
        return KeyEventResult.handled;
      }
      final TolyMenuEntry entry = levels.last[index];
      if (entry is TolyMenuItem) _select(entry, depth, index);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}

final class _TolyMenuRow extends StatelessWidget {
  /// 当前行展示的菜单项。
  final TolyMenuItem item;

  /// 当前行是否处于活动状态。
  final bool active;

  /// 鼠标进入当前行时的回调。
  final VoidCallback onEntered;

  /// 当前行被执行时的回调。
  final VoidCallback onPressed;

  const _TolyMenuRow({
    super.key,
    required this.item,
    required this.active,
    required this.onEntered,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final TolyMenuThemeData theme = context.tolyMenuTheme;
    final Color foreground =
        item.enabled ? theme.foregroundColor : theme.disabledColor;
    return Semantics(
      button: true,
      enabled: item.enabled,
      checked: item.checked,
      expanded: item.hasChildren ? active : null,
      child: MouseRegion(
        cursor:
            item.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
        onEnter: item.enabled ? (_) => onEntered() : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: item.enabled ? onPressed : null,
          child: Container(
            height: theme.itemHeight,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: active ? theme.activeColor : Colors.transparent,
              borderRadius: theme.itemBorderRadius,
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 22,
                  child: item.checked
                      ? const Icon(Icons.check, size: 15)
                      : _inheritForeground(item.leading, foreground),
                ),
                Expanded(
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: foreground, fontSize: 12),
                  ),
                ),
                if (item.shortcut != null)
                  Text(
                    item.shortcut!,
                    style: TextStyle(color: theme.disabledColor, fontSize: 11),
                  ),
                if (item.trailing != null) ...<Widget>[
                  const SizedBox(width: 8),
                  _inheritForeground(item.trailing, foreground)!,
                ],
                if (item.hasChildren) ...<Widget>[
                  const SizedBox(width: 8),
                  Icon(Icons.chevron_right, size: 16, color: foreground),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? _inheritForeground(Widget? child, Color color) {
    if (child == null) return null;
    return IconTheme.merge(
      data: IconThemeData(color: color),
      child: DefaultTextStyle.merge(
        style: TextStyle(color: color),
        child: child,
      ),
    );
  }
}
