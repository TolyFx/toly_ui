import 'package:flutter/material.dart';

import '../controller/toly_menu_controller.dart';
import '../model/toly_menu_entry.dart';
import '../theme/toly_menu_theme.dart';
import 'toly_menu_surface.dart';

/// 菜单锚点内容构建器。
typedef TolyMenuAnchorBuilder = Widget Function(
  BuildContext context,
  TolyMenuController controller,
);

/// 菜单相对锚点展开的方向。
enum TolyMenuPlacement { bottomStart, bottomEnd, rightStart }

/// 为按钮、工具栏动作和任意组件提供下拉或上下文菜单能力。
final class TolyMenuAnchor extends StatefulWidget {
  /// 根菜单条目。
  final List<TolyMenuEntry> entries;

  /// 锚点内容构建器。
  final TolyMenuAnchorBuilder builder;

  /// 可选的外部菜单控制器。
  final TolyMenuController? controller;

  /// 菜单相对锚点的展开方向。
  final TolyMenuPlacement placement;

  /// 锚点和菜单之间的距离。
  final double gap;

  /// 是否点击锚点时切换菜单状态。
  final bool toggleOnTap;

  /// 叶子条目被选中时的回调。
  final TolyMenuItemSelected? onSelected;

  const TolyMenuAnchor({
    super.key,
    required this.entries,
    required this.builder,
    this.controller,
    this.placement = TolyMenuPlacement.bottomStart,
    this.gap = 4,
    this.toggleOnTap = true,
    this.onSelected,
  });

  @override
  State<TolyMenuAnchor> createState() => _TolyMenuAnchorState();
}

final class _TolyMenuAnchorState extends State<TolyMenuAnchor> {
  /// 当前锚点与浮层共享的点击区域标识。
  final Object _tapRegionGroup = Object();

  /// Flutter OverlayPortal 的显示控制器。
  final OverlayPortalController _overlayController = OverlayPortalController(
    debugLabel: 'TolyMenuAnchor',
  );

  /// 内部创建的菜单控制器。
  TolyMenuController? _internalController;

  /// 当前实际使用的菜单控制器。
  TolyMenuController get _controller {
    return widget.controller ?? _internalController!;
  }

  @override
  void initState() {
    super.initState();
    _attachController();
  }

  @override
  void didUpdateWidget(TolyMenuAnchor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _detachController(oldWidget.controller ?? _internalController);
      _internalController?.dispose();
      _internalController = null;
      _attachController();
    }
  }

  @override
  void dispose() {
    _detachController(_controller);
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget anchor = widget.builder(context, _controller);
    if (widget.toggleOnTap) {
      anchor = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggle,
        child: anchor,
      );
    }
    return TapRegion(
      groupId: _tapRegionGroup,
      onTapOutside: _handleTapOutside,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: _buildOverlay,
        child: anchor,
      ),
    );
  }

  /// 连接当前实际使用的控制器。
  void _attachController() {
    if (widget.controller == null) {
      _internalController = TolyMenuController();
    }
    _controller.addListener(_handleControllerChanged);
  }

  void _detachController(TolyMenuController? controller) {
    controller?.removeListener(_handleControllerChanged);
  }

  void _toggle() {
    _controller.isOpen ? _controller.close() : _controller.open();
  }

  void _handleTapOutside(PointerDownEvent event) {
    _controller.close();
  }

  /// 根据控制器状态同步 OverlayPortal，避免控制器持有 Widget State。
  void _handleControllerChanged() {
    if (_controller.isOpen) {
      if (!_overlayController.isShowing) _overlayController.show();
    } else if (_overlayController.isShowing) {
      _overlayController.hide();
    }
    if (mounted) setState(() {});
  }

  Widget _buildOverlay(BuildContext context) {
    final RenderBox anchorBox = this.context.findRenderObject()! as RenderBox;
    final OverlayState overlay = Overlay.of(context);
    final RenderBox overlayBox =
        overlay.context.findRenderObject()! as RenderBox;
    final Offset origin = anchorBox.localToGlobal(
      Offset.zero,
      ancestor: overlayBox,
    );
    final Size viewport = overlayBox.size;
    final TolyMenuThemeData theme = context.tolyMenuTheme;
    final int levelCount = _controller.expandedPath.length + 1;
    final double cascadeWidth =
        theme.panelWidth * levelCount + theme.submenuGap * (levelCount - 1);
    final double preferredLeft = switch (widget.placement) {
      TolyMenuPlacement.bottomStart => origin.dx,
      TolyMenuPlacement.bottomEnd =>
        origin.dx + anchorBox.size.width - cascadeWidth,
      TolyMenuPlacement.rightStart =>
        origin.dx + anchorBox.size.width + widget.gap,
    };
    final double left = preferredLeft
        .clamp(
            8.0, (viewport.width - cascadeWidth - 8).clamp(8.0, viewport.width))
        .toDouble();
    final double top = switch (widget.placement) {
      TolyMenuPlacement.bottomStart ||
      TolyMenuPlacement.bottomEnd =>
        origin.dy + anchorBox.size.height + widget.gap,
      TolyMenuPlacement.rightStart => origin.dy,
    };
    return Positioned(
      left: left,
      top: top,
      child: TapRegion(
        groupId: _tapRegionGroup,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: viewport.height - top - 8),
          child: SingleChildScrollView(
            child: TolyMenuSurface(
              entries: widget.entries,
              controller: _controller,
              onSelected: widget.onSelected,
            ),
          ),
        ),
      ),
    );
  }
}
