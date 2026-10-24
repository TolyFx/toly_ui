import 'package:flutter/material.dart';
import 'package:tolyui_action/tolyui_action.dart';

/// TolyUI 通用确认面板。
///
/// 面板只负责统一确认类交互的视觉与返回值，不感知具体业务状态。
class TolyConfirmPanel extends StatelessWidget {
  /// 面板标题。
  final String title;

  /// 面板说明。
  final String message;

  /// 取消按钮文案。
  final String cancelLabel;

  /// 确认按钮文案。
  final String confirmLabel;

  /// 顶部语义图标。
  final IconData icon;

  /// 面板强调色。
  final Color? accentColor;

  const TolyConfirmPanel({
    super.key,
    required this.title,
    required this.message,
    required this.cancelLabel,
    required this.confirmLabel,
    this.icon = Icons.shield_outlined,
    this.accentColor,
  });

  /// 展示统一确认面板并返回用户选择。
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    required String cancelLabel,
    required String confirmLabel,
    IconData icon = Icons.shield_outlined,
    Color? accentColor,
    bool barrierDismissible = true,
  }) async {
    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: Colors.black.withValues(alpha: 0.28),
      builder: (BuildContext dialogContext) => TolyConfirmPanel(
        title: title,
        message: message,
        cancelLabel: cancelLabel,
        confirmLabel: confirmLabel,
        icon: icon,
        accentColor: accentColor,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color surfaceColor = theme.colorScheme.surface;
    final Color titleColor = theme.colorScheme.onSurface;
    final Color messageColor = titleColor.withValues(alpha: 0.62);
    final Color resolvedAccentColor = accentColor ?? theme.colorScheme.primary;

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _ConfirmIcon(icon: icon, color: resolvedAccentColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: titleColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: messageColor,
                      height: 1.55,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _ConfirmActions(
                  cancelLabel: cancelLabel,
                  confirmLabel: confirmLabel,
                  accentColor: resolvedAccentColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfirmIcon extends StatelessWidget {
  /// 图标数据。
  final IconData icon;

  /// 图标强调色。
  final Color color;

  const _ConfirmIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(11),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: 20, color: color),
    );
  }
}

class _ConfirmActions extends StatelessWidget {
  /// 取消按钮文案。
  final String cancelLabel;

  /// 确认按钮文案。
  final String confirmLabel;

  /// 确认按钮强调色。
  final Color accentColor;

  const _ConfirmActions({
    required this.cancelLabel,
    required this.confirmLabel,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TolyActionButton(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          autofocus: true,
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        const SizedBox(width: 8),
        TolyActionButton(
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          foregroundColor: Colors.white,
          backgroundColor: accentColor,
          hoverColor: Color.alphaBlend(const Color(0x18000000), accentColor),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
