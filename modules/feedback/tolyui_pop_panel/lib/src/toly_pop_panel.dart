import 'package:flutter/material.dart';

/// TolyUI 通用底部弹出面板。
///
/// 统一管理面板高度、顶部拖拽条、标题、关闭动作、内容区与底部操作区。
class TolyPopPanel extends StatelessWidget {
  /// 面板标题。
  final String title;

  /// 面板主内容。
  final Widget child;

  /// 可选的底部操作区。
  final Widget? footer;

  /// 关闭面板动作。
  final VoidCallback? onClose;

  /// 是否显示顶部拖拽条。
  final bool showHandle;

  const TolyPopPanel({
    super.key,
    required this.title,
    required this.child,
    this.footer,
    this.onClose,
    this.showHandle = true,
  });

  /// 以统一样式展示底部面板。
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    Widget? footer,
    double heightFactor = 0.75,
    bool showHandle = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.24),
      builder: (BuildContext sheetContext) {
        final double maxHeight = MediaQuery.sizeOf(sheetContext).height *
            heightFactor.clamp(0.1, 1.0);
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: TolyPopPanel(
            title: title,
            footer: footer,
            showHandle: showHandle,
            onClose: () => Navigator.of(sheetContext).pop(),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (showHandle) _PanelHandle(theme: theme),
          _PanelHeader(title: title, onClose: onClose),
          const Divider(height: 1),
          Flexible(fit: FlexFit.loose, child: child),
          if (footer != null) ...<Widget>[
            const Divider(height: 1),
            SafeArea(top: false, child: footer!),
          ],
        ],
      ),
    );
  }
}

class _PanelHandle extends StatelessWidget {
  /// 当前主题。
  final ThemeData theme;

  const _PanelHandle({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(top: 8, bottom: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  /// 面板标题。
  final String title;

  /// 关闭面板动作。
  final VoidCallback? onClose;

  const _PanelHeader({required this.title, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      height: 44,
      child: Row(
        children: <Widget>[
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            constraints: const BoxConstraints.tightFor(width: 44, height: 44),
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.close),
            onPressed: onClose,
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
