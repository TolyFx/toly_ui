import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../controller/toly_menu_controller.dart';
import '../model/toly_menu_entry.dart';
import '../theme/toly_menu_theme.dart';
import 'toly_menu_anchor.dart';

/// 支持点击打开和打开后悬浮切换的桌面菜单栏。
final class TolyMenuBar extends StatefulWidget {
  /// 顶部菜单组。
  final List<TolyMenuGroup> groups;

  /// 菜单栏右侧的自定义内容。
  final Widget? trailing;

  /// 菜单栏高度。
  final double height;

  /// 菜单尚未打开时，是否允许首次悬浮直接展开。
  final bool openOnHover;

  const TolyMenuBar({
    super.key,
    required this.groups,
    this.trailing,
    this.height = 32,
    this.openOnHover = false,
  });

  @override
  State<TolyMenuBar> createState() => _TolyMenuBarState();
}

final class _TolyMenuBarState extends State<TolyMenuBar> {
  /// 每个菜单组对应的独立控制器。
  final Map<String, TolyMenuController> _controllers =
      <String, TolyMenuController>{};

  /// 当前打开的菜单组标识。
  String? _openGroupId;

  @override
  void initState() {
    super.initState();
    _syncControllers();
  }

  @override
  void didUpdateWidget(TolyMenuBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncControllers();
  }

  @override
  void dispose() {
    for (final TolyMenuController controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Row(
        children: <Widget>[
          ...widget.groups.map(_buildGroup),
          const Spacer(),
          if (widget.trailing != null) widget.trailing!,
        ],
      ),
    );
  }

  Widget _buildGroup(TolyMenuGroup group) {
    final TolyMenuController controller = _controllers[group.id]!;
    return TolyMenuAnchor(
      key: ValueKey<String>('toly-menu-group-${group.id}'),
      entries: group.entries,
      controller: controller,
      gap: 2,
      builder: (BuildContext context, TolyMenuController menuController) {
        return _TolyMenuBarButton(
          label: group.label,
          open: menuController.isOpen,
          onEntered: () => _handleGroupEntered(group.id),
        );
      },
    );
  }

  /// 同步菜单组与控制器集合，并释放已经删除的组。
  void _syncControllers() {
    final Set<String> ids =
        widget.groups.map((TolyMenuGroup group) => group.id).toSet();
    final List<String> removed = _controllers.keys
        .where((String id) => !ids.contains(id))
        .toList(growable: false);
    for (final String id in removed) {
      _controllers.remove(id)?.dispose();
    }
    for (final TolyMenuGroup group in widget.groups) {
      _controllers.putIfAbsent(
        group.id,
        () => TolyMenuController(
          onOpenChanged: (bool open) => _handleGroupOpenChanged(group.id, open),
        ),
      );
    }
  }

  void _handleGroupOpenChanged(String groupId, bool open) {
    if (open) {
      final String? previous = _openGroupId;
      _openGroupId = groupId;
      if (previous != null && previous != groupId) {
        _controllers[previous]?.close();
      }
    } else if (_openGroupId == groupId) {
      _openGroupId = null;
    }
    if (mounted) setState(() {});
  }

  void _handleGroupEntered(String groupId) {
    if (_openGroupId == groupId) return;
    if (_openGroupId == null && !widget.openOnHover) return;
    _controllers[groupId]?.open();
  }
}

final class _TolyMenuBarButton extends StatefulWidget {
  /// 顶部菜单名称。
  final String label;

  /// 当前菜单是否打开。
  final bool open;

  /// 鼠标进入按钮时的回调。
  final VoidCallback onEntered;

  const _TolyMenuBarButton({
    required this.label,
    required this.open,
    required this.onEntered,
  });

  @override
  State<_TolyMenuBarButton> createState() => _TolyMenuBarButtonState();
}

final class _TolyMenuBarButtonState extends State<_TolyMenuBarButton> {
  /// 鼠标是否停留在按钮上。
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final TolyMenuThemeData theme = context.tolyMenuTheme;
    return MouseRegion(
      onEnter: _handleEnter,
      onExit: _handleExit,
      child: Container(
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 9),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              _hovered || widget.open ? theme.activeColor : Colors.transparent,
          borderRadius: theme.itemBorderRadius,
        ),
        child: Text(
          widget.label,
          style: TextStyle(color: theme.foregroundColor, fontSize: 12),
        ),
      ),
    );
  }

  void _handleEnter(PointerEnterEvent event) {
    setState(() => _hovered = true);
    widget.onEntered();
  }

  void _handleExit(PointerExitEvent event) {
    setState(() => _hovered = false);
  }
}
